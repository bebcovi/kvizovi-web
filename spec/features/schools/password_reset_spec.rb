require "spec_helper"
require "nokogiri"

feature "School" do
  before do
    @school = create(:school)
  end

  scenario "A school can reset its password" do
    visit root_path
    click_on "Ja sam škola"
    click_on "Zatražite novu"

    fill_in "email", with: @school.email
    click_on "Zatraži novu lozinku"

    new_password = Nokogiri::HTML(PasswordSender.deliveries.first.body.to_s).at("strong").text

    fill_in "Korisničko ime", with: @school.username
    fill_in "Lozinka",        with: new_password
    click_on "Prijava"

    expect(current_path).not_to eq login_path
  end
end

