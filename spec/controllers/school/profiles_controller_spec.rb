require "spec_helper"

describe School::ProfilesController do
  before(:all) { @school = create(:school) }

  before do
    controller.send(:log_in!, @school)
  end

  describe "#show" do
    it "assigns school" do
      get :show
      expect(assigns(:school)).to eq @school
    end

    it "renders :show" do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe "#edit" do
    it "assigns school" do
      get :edit
      expect(assigns(:school)).to eq @school
    end

    it "renders :edit" do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    context "when valid" do
      before do
        School.any_instance.stub(:valid?).and_return(true)
        School.any_instance.stub(:update_attributes)
      end

      it "updates school's attributes" do
        @school.class.any_instance.unstub(:update_attributes)
        post :update, school: {name: "Name"}
        expect(@school.reload.name).to eq "Name"
      end

      it "redirects to profile" do
        post :update
        expect(response).to redirect_to(profile_path)
      end
    end

    context "when invalid" do
      before do
        School.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns school and its attributes" do
        post :update, school: {name: "Name"}
        expect(assigns(:school)).to eq @school
        expect(assigns(:school).name).to eq "Name"
      end

      it "renders :edit" do
        post :update
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#delete" do
    it "renders :delete" do
      get :delete
      expect(response).to render_template(:delete)
    end
  end

  describe "#destroy" do
    context "when valid" do
      before do
        School.any_instance.stub(:authenticate).and_return(true)
        School.any_instance.stub(:destroy)
      end

      it "deletes the school" do
        school = create(:school)
        school.class.any_instance.unstub(:destroy)
        controller.send(:log_in!, school)
        expect {
          delete :destroy
        }.to change{School.count}.by -1
      end

      it "logs the school out" do
        delete :destroy
        expect(cookies[:user_id]).to be_nil
      end

      it "redirects to root" do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash notice" do
        delete :destroy
        expect(flash[:notice]).not_to be_nil
      end
    end

    context "when not valid" do
      before do
        School.any_instance.stub(:authenticate).and_return(false)
      end

      it "sets an alert message" do
        delete :destroy
        expect(flash[:alert]).not_to be_nil
      end

      it "renders :delete" do
        delete :destroy
        expect(response).to render_template(:delete)
      end
    end
  end

  after(:all) { @school.destroy }
end
