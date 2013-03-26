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

  describe "#delete" do
    it "renders :delete" do
      get :delete
      expect(response).to render_template(:delete)
    end
  end

  describe "#destroy" do
    context "when valid" do
      before do
        Student.any_instance.stub(:authenticate).and_return(true)
        Student.any_instance.stub(:destroy)
      end

      it "deletes the student" do
        student = create(:student)
        student.class.any_instance.unstub(:destroy)
        controller.send(:log_in!, student)
        expect {
          delete :destroy
        }.to change{Student.count}.by -1
      end

      it "logs the student out" do
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
        Student.any_instance.stub(:authenticate).and_return(false)
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

  after(:all) { @student.destroy }
end
