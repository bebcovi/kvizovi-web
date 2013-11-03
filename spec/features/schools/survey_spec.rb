require "spec_helper"

feature "Survey" do
  let!(:school) { register(:school) }

  before do
    login(school)
  end

  scenario "Completing" do
    click_on "Anketa"

    divs = all("div.survey_fields_answer")
    within(divs[0])  { choose "Žensko" }
    within(divs[1])  { choose "Srednja škola" }
    within(divs[2])  { fill_in "Naziv škole", with: "XV. Gimnazija" }
    within(divs[3])  { fill_in "Zanimanje", with: "Profesorica hrvatskog" }
    within(divs[4])  { fill_in "Koliko dugo radite u školi?", with: "7 godina" }
    within(divs[5])  { fill_in "Koje predmete predajete", with: "Hrvatski" }
    within(divs[6])  { choose "Da" }
    within(divs[7])  { choose "Jednom tjedno" }
    within(divs[8])  { choose "Da" }
    within(divs[9])  { choose "Tjedne pripreme" }
    within(divs[10]) { fill_in "Koliko ste dugo koristili aplikaciju Lektire?", with: "5 mjeseci" }
    within(divs[11]) { choose "Da" }
    within(divs[12]) { fill_in "Ako da, koje ste poteškoće imali?", with: "Nisam mogla vidjeti odigrane kvizove" }
    within(divs[13]) { choose "Da" }
    within(divs[14]) { choose "Da" }
    within(divs[15]) { check "Ne, ne bih je nikome preporučio/la" }
    within(divs[16]) { choose "Značajno im se poboljšalo poznavanje gradiva iz lektire" }
    within(divs[17]) { choose "Djelomično bila od pomoći" }
    within(divs[18]) { choose "svi su pokazali podjednako znanje." }
    within(divs[19]) { (0..2).each { |n| choose "survey_fields_attributes_19_answer_#{n}_answer_jako_mi_se_svia" } }
    submit

    expect(navbar).not_to have_content("Anketa")
  end
end
