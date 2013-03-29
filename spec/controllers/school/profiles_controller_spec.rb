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

  after(:all) { @school.destroy }
end
