namespace :questions do
  task :generate => [:environment, :load_factories] do
    require "ostruct"
    require "paperclip"

    Paperclip.options[:log] = false

    if ENV["SCHOOL_USERNAME"].blank?
      puts "Usage: rake questions:generate SCHOOL_USERNAME=<username>"
      exit
    end

    ActiveRecord::Base.transaction do
      school = School.find_by_username(ENV["SCHOOL_USERNAME"])
      begin
        quiz = Factory.create(:quiz, school: school)
      rescue => ActiveRecord::RecordInvalid
        puts "There already exist a quiz with name \"#{Factory.attributes_for(:quiz)[:name]}\". Delete it first."
        exit
      end
      quiz.questions = create_questions(20)
      Factory.create_list(:student, 2, school: school) if school.students.empty?
      quiz_snapshot = QuizSnapshot.capture(OpenStruct.new(students: school.students, quiz: quiz))
      played_quiz = Factory.create(:played_quiz, quiz_snapshot: quiz_snapshot)
      played_quiz.students = school.students
    end
  end

  task :load_factories do
    require "factory_girl"
    FactoryGirl.factories.clear
    $load_factories = true
    Dir[Rails.root.join("features/support/factories/**/*.rb")].each &method(:require)
    $load_factories = false
    Factory = FactoryGirl unless defined?(Factory)
  end

  def create_questions(number)
    question_creations = [
      proc do
        ChoiceQuestion.create!(
          content: "Eliminate the bastard.",
          provided_answers: ["Jon Snow", "Robb Stark", "Bran Stark", "Ned Stark"],
        )
      end, proc do
        AssociationQuestion.create!(
          content: "Connect Game of Thrones characters:",
          associations: {
            "Sansa Stark"      => %("...but I don't want anyone smart, brave or good looking, I want Joffrey!"),
            "Tywin Lannister"  => %("Attacking Ned Stark in the middle of King Landing was stupid. Lannisters don't do stupid things."),
            "Tyrion Lannister" => %("Why is every god so vicious? Why aren't there gods of tits and wine?"),
            "Cercei Lannister" => %("Everyone except us is our enemy."),
          },
        )
      end, proc do
        BooleanQuestion.create!(
          content: "Stannis Baratheon won the war against King's Landing.",
          answer: false,
        )
      end, proc do
        ImageQuestion.create!(
          content: "Who is in the photo?",
          image: Rack::Test::UploadedFile.new(Rails.root.join("features/support/fixtures/files/clint_eastwood.jpg"), "image/jpeg"),
          answer: "Clint Eastwood",
        )
      end, proc do
        TextQuestion.create!(
          content: "Which family does Khaleesi belong to?",
          answer: "Targaryen",
        )
      end,
    ]

    number.times.map do |idx|
      question_creations[idx % 5].call
    end
  end
end
