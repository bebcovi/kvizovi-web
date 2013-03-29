require "spec_helper"

describe Student::ProfilesController do
  before(:all) { @student = create(:student) }

  before do
    controller.send(:log_in!, @student)
  end

  describe "#show" do
    it "assigns student" do
      get :show
      expect(assigns(:student)).to eq @student
    end

    it "renders :show" do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe "#edit" do
    it "assigns student" do
      get :edit
      expect(assigns(:student)).to eq @student
    end

    it "renders :edit" do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    context "when valid" do
      before do
        Student.any_instance.stub(:valid?).and_return(true)
        Student.any_instance.stub(:update_attributes)
      end

      it "updates student's attributes" do
        @student.class.any_instance.unstub(:update_attributes)
        post :update, student: {first_name: "Name"}
        expect(@student.reload.first_name).to eq "Name"
      end

      it "redirects to profile" do
        post :update
        expect(response).to redirect_to(profile_path)
      end
    end

    context "when invalid" do
      before do
        Student.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns student and its attributes" do
        post :update, student: {first_name: "Name"}
        expect(assigns(:student)).to eq @student
        expect(assigns(:student).first_name).to eq "Name"
      end

      it "renders :edit" do
        post :update
        expect(response).to render_template(:edit)
      end
    end
  end

  after(:all) { @student.destroy }
end
