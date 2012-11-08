# encoding: utf-8
require "spec_helper_full"

describe "Student" do
  context "when registering" do
    before(:all) { @school = create(:school) }

    it "has the link for it on the login page" do
      visit login_path(type: "student")
      click_on "ovdje"
      current_path.should eq new_student_path
    end

    context "on validation errors" do
      it "is held on the same page" do
        visit new_student_path
        expect { click_on "Registriraj se" }.to_not change{Student.count}
        current_path.should eq students_path
      end
    end

    context "on success" do
      let(:attributes) { attributes_for(:student) }

      it "gets logged in and redirected to the new game page" do
        visit new_student_path

        fill_in "Ime", with: attributes[:first_name]
        fill_in "Prezime", with: attributes[:last_name]
        choose attributes[:gender]
        select attributes[:year_of_birth].to_s, from: "Godina rođenja"
        fill_in "Korisničko ime", with: attributes[:username]
        fill_in "Lozinka", with: attributes[:password]
        fill_in "Potvrda lozinke", with: attributes[:password]
        fill_in "Razred", with: attributes[:grade]
        fill_in "Tajni ključ škole", with: @school.key

        expect { click_on "Registriraj se" }.to change{Student.count}.by 1

        current_path.should eq new_game_path
        page.should have_content(attributes[:first_name])
      end
    end

    after(:all) {
      Student.destroy_all
      @school.destroy
    }
  end

  context "when logging in" do
    before(:all) {
      @school = create(:school)
      @student = create(:student, school: @school)
    }

    it "has the link for it on the root page" do
      visit root_path
      find_link("Ja sam učenik")[:href].should eq login_path(type: "student")
    end

    context "on incorrect credentials" do
      it "is held on the same page" do
        visit login_path(type: "student")
        click_on "Prijava"
        current_path.should eq login_path
      end
    end

    context "on success" do
      let(:attributes) { attributes_for(:student) }

      it "gets logged in and redirected to the new game page" do
        visit login_path(type: "student")
        fill_in "Korisničko ime", with: attributes[:username]
        fill_in "Lozinka", with: attributes[:password]
        click_on "Prijava"

        current_path.should eq new_game_path
        page.should have_content(attributes[:first_name])
      end
    end

    after(:all) {
      @student.destroy
      @school.destroy
    }
  end

  context "when logged in" do
    before(:all) {
      @school = create(:school)
      @student = create(:student, school: @school)
    }
    before(:each) { login(:student, attributes_for(:student)) }

    context "when updating its profile" do
      it "has the link for it on the profile page" do
        visit student_path(@student)
        click_on "Izmjeni profil"
        current_path.should eq edit_student_path(@student)
      end

      context "on validation errors" do
        it "is held on the same page" do
          visit edit_student_path(@student)
          fill_in "Korisničko ime", with: ""
          click_on "Spremi"
          current_path.should eq student_path(@student)
        end
      end

      context "on success" do
        it "gets redirected back to its profile" do
          visit edit_student_path(@student)
          click_on "Spremi"
          current_path.should eq student_path(@student)
        end
      end
    end

    context "when changing its password" do
      it "has the link for it on the profile page" do
        visit student_path(@student)
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
        let(:attributes) { attributes_for(:student) }

        it "gets redirected back to its profile with its password changed" do
          visit edit_password_path
          fill_in "Stara lozinka", with: attributes[:password]
          fill_in "Nova lozinka", with: "new password"
          fill_in "Potvrda nove lozinke", with: "new password"
          click_on "Spremi"

          current_path.should eq student_path(@student)
          @student.reload.authenticate("new password").should be_true

          visit edit_password_path
          fill_in "Stara lozinka", with: "new password"
          fill_in "Nova lozinka", with: attributes[:password]
          fill_in "Potvrda nove lozinke", with: attributes[:password]
          click_on "Spremi"
        end
      end
    end

    context "when deleting its account" do
      it "has the link for it on the profile page" do
        visit student_path(@student)
        click_on "Izbriši korisnički račun"
        current_path.should eq delete_student_path(@student)
      end

      context "on validation erros" do
        it "is held on the same page" do
          visit delete_student_path(@student)
          click_on "Potvrdi"
          current_path.should eq student_path(@student)
        end
      end

      context "on success" do
        it "gets redirected to root" do
          visit delete_student_path(@student)
          fill_in "Lozinka", with: attributes_for(:student)[:password]
          expect { click_on "Potvrdi" }.to change{Student.count}.by(-1)
          current_path.should eq root_path
        end
      end
    end

    after(:all) { @school.destroy }
  end
end
