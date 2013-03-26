require "spec_helper"

describe Student::RegistrationsController do
  describe "#new" do
    it "assigns student" do
      get :new, {}, {}, {authorized: true}
      expect(assigns(:student)).to be_a_new(Student)
    end

    it "renders :new" do
      get :new, {}, {}, {authorized: true}
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        Student.any_instance.stub(:valid?).and_return(true)
        Student.any_instance.stub(:save)
      end

      it "saves the user" do
        Student.any_instance.unstub(:save)
        expect {
          post :create
        }.to change{Student.count}.by 1
      end

      it "log the created student in" do
        controller.should_receive(:log_in!)
        post :create
      end

      it "redirects to root" do
        post :create
        expect(response).to redirect_to(root_path)
      end
    end

    context "when invalid" do
      before do
        Student.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns the student and its attributes" do
        post :create, student: {first_name: "New name"}
        expect(assigns(:student)).to be_a_new(Student)
        expect(assigns(:student).first_name).to eq "New name"
      end

      it "renders :new" do
        post :create
        expect(flash).to render_template(:new)
      end
    end
  end
end
