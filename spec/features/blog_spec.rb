require "spec_helper"

feature "Blog" do
  let!(:school) { register(:school) }

  scenario "Viewing" do
    blog_post = create(:post)

    login(school)

    expect(find(".navbar-right .badge")).to have_content("1")

    click_on "Blog"

    expect(page).to have_content(blog_post.title)
    expect(page).not_to have_content("Novi post")

    visit account_quizzes_path

    expect(find(".navbar-right")).not_to have_css(".badge")
  end

  scenario "Managing" do
    school.update(admin: true)

    login(school)
    click_on "Blog"

    click_on "Novi post"
    fill_in "Naslov", with: "Blog post"
    fill_in "Sadržaj", with: "Blog post sadržaj"
    submit

    expect(page).to have_css(".post")

    click_on "Izmijeni"
    submit

    expect(page).to have_css(".post")

    click_on "Izbriši"

    expect(page).not_to have_css(".post")
  end
end
