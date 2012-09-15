class SchoolPresenter < BasePresenter
  presents :school

  def edit_button(text)
    settings_button "Izmjeni profil", edit_school_path(school)
  end
end
