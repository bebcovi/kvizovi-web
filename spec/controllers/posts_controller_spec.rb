require "spec_helper"

describe PostsController, user: :school do
  before do
    @user = Factory.create(:school, :admin)
    login_as(@user)
  end

  context "collection" do
    describe "#new" do
      it "doesn't raise errors" do
        get :new
      end
    end

    describe "#create" do
      context "when valid" do
        it "creates a post" do
          expect do
            post :create, post: {title: "Title", body: "Body"}
          end.to change { Post.count }.by 1
        end
      end

      context "when invalid" do
        it "doesn't raise errors" do
          post :create, post: {}
        end
      end
    end
  end

  context "member" do
    before do
      @post = Factory.create(:post)
    end

    describe "#edit" do
      it "doesn't raise errors" do
        get :edit, id: @post.id
      end
    end

    describe "#update" do
      context "when valid" do
        before do
          Post.any_instance.stub(:valid?) { true }
        end

        it "updates the post" do
          expect do
            put :update, id: @post.id, post: {title: "New title"}
          end.to change { @post.reload.title }.to "New title"
        end
      end

      context "when invalid" do
        it "doesn't raise errors" do
          put :update, id: @post.id, post: {title: nil}
        end
      end
    end

    describe "#delete" do
      it "doesn't raise errors" do
        get :delete, id: @post.id
      end
    end

    describe "#destroy" do
      it "destroys the post" do
        delete :destroy, id: @post.id
        expect(Post.exists?(@post)).to be_false
      end
    end
  end
end