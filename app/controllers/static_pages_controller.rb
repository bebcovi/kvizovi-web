class StaticPagesController < ApplicationController
  before_filter :mark_posts_as_read, if: :user_logged_in?, only: :blog

  def tour
  end

  def contact
  end

  def blog
    @posts = Post.paginate(page: params[:page], per_page: 3)
  end

  private

  def mark_posts_as_read
    PostService.new(current_user.unread_posts).mark_as_read(current_user)
  end
end
