require "spec_helper"

describe QuestionsController do
  # before(:all) {
  #   @school = create(:school)
  #   @quiz = create(:quiz, school: @school)
  #   @other_quiz = create(:quiz)
  # }

  # before do
  #   controller.send(:log_in!, @school)
  #   controller.stub(:question_class).with(BooleanQuestion)
  # end

  # describe "#index" do
  #   it "assigns quiz's questions" do
  #     quiz_question = create(:question, school: @school)
  #     quiz_question.quizzes << @quiz
  #     other_questions = create(:question, school: @school)
  #     get :index, quiz_id: @quiz.id
  #     expect(assigns(:questions)).to eq [quiz_question]
  #   end

  #   it "renders :index" do
  #     get :index, quiz_id: @quiz.id
  #     expect(response).to render_template(:index)
  #   end
  # end

  # describe "#new" do
  #   it "authorizes" do
  #     get :new, quiz_id: @other_quiz.id
  #     expect(response).to redirect_to(root_path)
  #   end

  #   it "assigns the right type of question" do
  #     get :new, quiz_id: @quiz.id
  #     expect(assigns).to be_a_new(BooleanQuestion)
  #   end

  #   it "renders :new" do
  #     get :new, quiz_id: @quiz.id
  #     expect(response).to render_template(:new)
  #   end
  # end

  # describe "#create" do
  #   it "authorizes" do
  #     post :create, quiz_id: @other_quiz.id
  #     expect(response).to redirect_to(root_path)
  #   end

  #   it "assigns the right type of question" do
  #     post :create, quiz_id: @quiz.id
  #     expect(assigns).to be_a_new(BooleanQuestion)
  #   end

  #   context "when valid" do
  #     before do
  #       Quiz.any_instance.stub(:valid?).and_return(true)
  #       Quiz.any_instance.stub(:save)
  #     end
  #   end

  #   context "when invalid" do
  #     before do
  #       Quiz.any_instance.stub(:valid?).and_return(false)
  #     end
  #   end
  # end

  # after(:all) {
  #   @quiz.destroy
  #   @other_quiz.destroy
  #   @school.destroy
  # }
end
