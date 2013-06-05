class PostService
  def initialize(posts)
    @posts = posts.is_a?(Post) ? [posts] : posts
  end

  def mark_as_read(user)
    @posts.each do |post|
      Reading.create!(post: post, user: user)
    end
  end
end
