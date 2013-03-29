module Student::BaseHelper
  def student_navigation_pages
    [
      ["Kvizovi", new_game_path, params[:controller] == "games"],
      ["Vodič", tour_path, params[:action] == "tour"],
    ]
  end

  ORDINALS = {
    1 => "Prvi",
    2 => "Drugi",
    3 => "Treći",
    4 => "Četvrti",
    5 => "Peti",
    6 => "Šesti",
    7 => "Sedmi",
    8 => "Osmi"
  }
end
