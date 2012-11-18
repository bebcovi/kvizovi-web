# encoding: utf-8
require "spec_helper_full"

describe "School" do
  context "when registering" do
    it "has the link for it on the login page" do
      visit login_path(type: "school")
      find_link("Registrirajte se")[:href].should eq new_school_path
    end

    it "is required to authorize" do
      visit new_school_path
      current_path.should eq authorize_path
    end

    context "when authorizing" do
      context "on validation errors" do
        it "is held on the same page" do
          visit authorize_path
          fill_in "Tajni ključ aplikacije", with: "wrong key"
          click_on "Potvrdi"
          current_path.should eq authorize_path
        end
      end

      context "on success" do
        it "gets redirected to the registration page" do
          visit authorize_path
          fill_in "Tajni ključ aplikacije", with: ENV["LEKTIRE_KEY"]
          click_on "Potvrdi"
          current_path.should eq new_school_path
        end
      end
    end

    def authorize
      visit authorize_path
      fill_in "Tajni ključ aplikacije", with: ENV["LEKTIRE_KEY"]
      click_on "Potvrdi"
    end

    context "on validation errors" do
      it "is held on the same page" do
        authorize
        expect { click_on "Registriraj se" }.to_not change{School.count}
        current_path.should eq schools_path
      end
    end

    context "on success" do
      let(:attributes) { attributes_for(:school) }

      it "gets redirected to its quizzes with example quizzes created" do
        authorize

        fill_in "Ime škole", with: attributes[:name]
        select attributes[:level], from: "Tip škole"
        fill_in "Mjesto", with: attributes[:place]
        select attributes[:region], from: "Županija"
        fill_in "Korisničko ime", with: attributes[:username]
        fill_in "Lozinka", with: attributes[:password]
        fill_in "Email", with: attributes[:email]
        fill_in "Potvrda lozinke", with: attributes[:password]
        fill_in "Tajni ključ", with: attributes[:key]

        expect { click_on "Registriraj se" }.to change{School.count}.by 1

        School.first.quizzes.should_not be_empty
        current_path.should eq quizzes_path
        page.should have_content(attributes[:name])
      end
    end

    after(:all) { School.destroy_all }
  end

  context "when logging in" do
    before(:all) { @school = create(:school) }

    it "has the link for it on the root page" do
      visit root_path
      find_link("Ja sam škola")[:href].should eq login_path(type: "school")
    end

    context "on incorrect credentials" do
      it "is held on the same page" do
        visit login_path(type: "school")
        click_on "Prijava"
        current_path.should eq login_path
      end
    end

    context "on success" do
      let(:attributes) { attributes_for(:school) }

      it "gets logged in and redirected to its quizzes" do
        visit login_path(type: "school")
        fill_in "Korisničko ime", with: attributes[:username]
        fill_in "Lozinka", with: attributes[:password]
        click_on "Prijava"

        current_path.should eq quizzes_path
        page.should have_content(attributes[:name])
      end
    end

    after(:all) { @school.destroy }
  end

  context "when logged in" do
    before(:all) { @school = create(:school) }
    before(:each) { login(:school, attributes_for(:school)) }

    context "when updating its profile" do
      it "has the link for it on the profile page" do
        visit school_path(@school)
        click_on "Izmjeni profil"
        current_path.should eq edit_school_path(@school)
      end

      context "on validation errors" do
        it "is held on the same page" do
          visit edit_school_path(@school)
          fill_in "Korisničko ime", with: ""
          click_on "Spremi"
          current_path.should eq school_path(@school)
        end
      end

      context "on success" do
        it "gets redirected back to its profile" do
          visit edit_school_path(@school)
          click_on "Spremi"
          current_path.should eq school_path(@school)
        end
      end
    end

    context "when it wants to try out its quiz" do
      before(:all) {
        @quiz = create(:quiz, school: @school)
        create(:question, quizzes: [@quiz])
      }

      it "has the link for it on the quiz page" do
        visit quiz_questions_path(@quiz)
        click_on "Isprobajte kviz"
        current_path.should eq edit_game_path
      end

      context "when the game is interrupted" do
        it "gets redirected back to the quiz" do
          visit quiz_questions_path(@quiz)
          click_on "Isprobajte kviz"
          click_on "Prekini"
          click_on "Jesam"
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "when the game is finished" do
        it "gets redirected back to the quiz" do
          visit quiz_questions_path(@quiz)
          click_on "Isprobajte kviz"
          click_on "Odgovori"
          within(".btn-toolbar") { find("*").click }
          click_on "Završi"
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      after(:all) { @quiz.destroy }
    end

    context "when there is a new update" do
      before(:each) { @school.connection.execute %(UPDATE "schools" SET "notified" = 'f') }

      it "receives an announcement that there is a new update" do
        visit quizzes_path
        page.should have_content("Napravili smo neke važne promjene")
      end

      it "can view that announcement, and then it won't be displayed anymore" do
        visit quizzes_path
        within(".alert-info") { click_link("ovdje") }
        current_path.should eq updates_path
        page.should_not have_content("Napravili smo neke važne promjene")
        visit quizzes_path
        page.should_not have_content("Napravili smo neke važne promjene")
      end

      it "can close that announcement, and then it won't be displayed anymore" do
        visit quizzes_path
        within(".alert-info") { find(".close").click }
        current_path.should eq quizzes_path
        page.should_not have_content("Napravili smo neke važne promjene")
      end
    end

    context "when changing password" do
      it "has the link for it on the profile page" do
        visit school_path(@school)
        click_on "Izmjeni lozinku"
        current_path.should eq edit_password_path
      end

      context "on validation errors" do
        it "is held on the same page" do
          visit edit_password_path
          click_on "Spremi"
          current_path.should eq password_path
        end
      end

      context "on success" do
        let(:attributes) { attributes_for(:school) }

        it "gets redirected back to its profile with its password changed" do
          visit edit_password_path
          fill_in "Stara lozinka", with: attributes[:password]
          fill_in "Nova lozinka", with: "new password"
          fill_in "Potvrda nove lozinke", with: "new password"
          click_on "Spremi"

          current_path.should eq school_path(@school)
          @school.reload.authenticate("new password").should be_true

          visit edit_password_path
          fill_in "Stara lozinka", with: "new password"
          fill_in "Nova lozinka", with: attributes[:password]
          fill_in "Potvrda nove lozinke", with: attributes[:password]
          click_on "Spremi"
        end
      end
    end

    context "when deleting account" do
      it "has the link for it on the profile page" do
        visit school_path(@school)
        click_on "Izbriši korisnički račun"
        current_path.should eq delete_school_path(@school)
      end

      context "on validation errors" do
        it "is held on the same page" do
          visit delete_school_path(@school)
          click_on "Potvrdi"
          current_path.should eq school_path(@school)
        end
      end

      context "on success" do
        it "gets redirected to root" do
          visit delete_school_path(@school)
          fill_in "Lozinka", with: attributes_for(:school)[:password]
          expect { click_on "Potvrdi" }.to change{School.count}.by(-1)
          current_path.should eq root_path
        end
      end
    end
  end
end
