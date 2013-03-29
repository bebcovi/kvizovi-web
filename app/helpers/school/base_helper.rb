module School::BaseHelper
  def school_navigation_pages
    [
      ["Kvizovi", quizzes_path, (params[:controller] == "quizzes" or (params[:controller] == "questions" and @scope.is_a?(Quiz)) or (params[:controller] == "questions" and params[:include].present?))],
      # ["Pitanja", questions_path(user), (params[:controller] == "questions" and not @scope.is_a?(Quiz) and not params[:include].present?)],
      # ["Učenici", students_path, params[:controller] == "students"],
      ["Vodič", tour_path, params[:action] == "tour"],
    ]
  end

  def regions
    REGIONS
  end

  REGIONS = [
    "Bjelovarsko-bilogorska županija",
    "Brodsko-posavska županija",
    "Dubrovačko-neretvanska županija",
    "Grad Zagreb",
    "Istarska županija",
    "Karlovačka županija",
    "Koprivničko-križevačka županija",
    "Krapinsko-zagorska županija",
    "Ličko-@senjska županija",
    "Međimurska županija",
    "Osječko-baranjska županija",
    "Požeško-slavonska županija",
    "Primorsko-goranska županija",
    "Sisačko-moslavačka županija",
    "Splitsko-dalmatinska županija",
    "Šibensko-kninska županija",
    "Varaždinska županija",
    "Virovitičko-podravska županija",
    "Vukovarsko-srijemska županija",
    "Zagrebačka županija",
    "Zadarska županija",
  ]
end
