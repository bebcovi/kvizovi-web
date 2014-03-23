require "spec_helper"

feature "Contact" do
  let(:school) { register(:school) }

  scenario "contacting when not logged in", js: true do
    visit root_path

    click_on "Kontakt"
    within("#contact") do
      fill_in "Vaš email", with: "foo@bar.com"
      fill_in "Poruka",    with: "Ova aplikacija je zakon!"
      submit
    end

    expect(page).to have_no_css("#contact")

    expect(sent_emails.last.to).to include("janko.marohnic@gmail.com")
    expect(sent_emails.last.reply_to).to include("foo@bar.com")
  end

  scenario "contacting when logged in", js: true do
    login(school)

    click_on "Kontakt"
    within("#contact") do
      expect(page).to have_no_text("Vaš email")

      fill_in "Poruka", with: "Ova aplikacija je zakon!"
      submit
    end

    expect(page).to have_no_css("#contact")

    expect(sent_emails.last.to).to include("janko.marohnic@gmail.com")
    expect(sent_emails.last.reply_to).to include(school.email)
  end
end
