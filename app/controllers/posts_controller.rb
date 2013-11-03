class PostsController < InheritedResources::Base
  actions :all, except: [:show]
  before_filter :authorize!, except: :index

  def index
    PostService.new(current_user.unread_posts).mark_as_read(current_user) if user_logged_in?
    super
  end

  private

  def collection
    @posts ||= end_of_association_chain.paginate(page: params[:page], per_page: 3)
  end

  def authorize!
    if not (user_logged_in? and current_user.admin?)
      redirect_to root_path, error: "Nemate ovlasti da izmjenjujete blog postove."
    end
  end

  def permitted_params
    params.permit!
  end
end
