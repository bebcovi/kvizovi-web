When(/^I click on the link for survey$/) do
  click_on "Anketa"
end

When(/^I fill in the survey$/) do
  divs = all("div.survey_fields_answer")

  school do
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
  end

  student do
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
  end
end

Then(/^I should not see the link for the survey(?: anymore)?$/) do
  expect(page).not_to have_link("Anketa")
end
