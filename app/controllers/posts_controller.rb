class PostsController < ApplicationController
  before_filter :authenticate!
  before_filter :authorize!

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.assign_attributes(post_params)

    if @post.valid?
      @post.save
      redirect_to blog_path, success: flash_success
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)

    if @post.valid?
      @post.save
      redirect_to blog_path, success: flash_success
    else
      render :edit
    end
  end

  def delete
    @post = Post.find(params[:id])
  end

  def destroy
    Post.destroy(params[:id])
    redirect_to blog_path, success: flash_success
  end

  private

  def authorize!
    if not current_user.admin?
      redirect_to root_path_for(current_user), error: flash("unauthorized")
    end
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
