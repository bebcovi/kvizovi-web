class SchoolPresenter < BasePresenter
  presents :school

  def edit_button(text)
    settings_button text, edit_school_path(school)
  end

  def delete_button(text)
    @template.delete_button text, school_path(school)
  end
end
