require "spec_helper"

feature "Survey" do
  let!(:student) { register(:student) }

  background do
    login(student)
  end

  scenario "Completing" do
    click_on "Anketa"

    divs = all("div.survey_fields_answer")
    within(divs[0])  { choose "Muško" }
    within(divs[1])  { choose "Srednja škola" }
    within(divs[2])  { fill_in "Naziv škole", with: "XV. Gimnazija" }
    within(divs[3])  { fill_in "Razred", with: "4e" }
    within(divs[4])  { (0..2).each { |n| choose "survey_fields_attributes_4_answer_#{n}_answer_jako_mi_se_svia" } }
    within(divs[5])  { choose "Da" }
    within(divs[6])  { choose "Da" }
    within(divs[7])  { choose "Jednom tjedno" }
    within(divs[8])  { choose "Da" }
    within(divs[9])  { fill_in "Ako da, koje ste poteškoće imali?", with: "Nisam mogao vidjeti povijest svojih odigranih kvizova" }
    within(divs[10]) { (0..2).each { |n| choose "survey_fields_attributes_10_answer_#{n}_answer_da" } }
    within(divs[11]) { check "Od prijatelja"; check "Iz školske knjižnice" }
    within(divs[12]) { check "Nakon čitanja lektire koja se testira" }
    within(divs[13]) { choose "ostala je ista" }
    within(divs[14]) { choose "Djelomično kao i u aplikaciji" }
    within(divs[15]) { choose "podjednako teška" }
    within(divs[16]) { fill_in "Biste li voljeli da se ovakav način učenja organizira i u drugim predmetima? Ako da, u kojim?", with: "U zemljopisu" }
    within(divs[17]) { choose "Dodatno bi me poticalo u čitanju lektira" }
    within(divs[18]) { choose "Pojedinačno" }
    within(divs[19]) { (0..2).each { |n| choose "survey_fields_attributes_19_answer_#{n}_answer_je_bilo_interesantno" } }
    within(divs[20]) { choose "Ništa, samo zabavu" }
    within(divs[21]) { choose "Ništa, samo zabavu" }
    submit

    expect(navbar).not_to have_content("Anketa")
  end
end
