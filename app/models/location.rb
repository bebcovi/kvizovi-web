# encoding: utf-8

module Location
  extend self

  def regions
    REGIONS.sort
  end

  REGIONS = [
    "Bjelovarsko-bilogorska županija",
    "Grad Zagreb",
    "Zagrebačka županija",
    "Krapinsko-zagorska županija",
    "Varaždinska županija",
    "Međimurska županija",
    "Koprivničko-križevačka županija",
    "Sisačko-moslavačka županija",
    "Virovitičko-podravska županija",
    "Požeško-slavonska županija",
    "Brodsko-posavska županija",
    "Osječko-baranjska županija",
    "Vukovarsko-srijemska županija",
    "Karlovačka županija",
    "Primorsko-goranska županija",
    "Istarska županija",
    "Ličko-senjska županija",
    "Zadarska županija",
    "Šibensko-kninska županija",
    "Splitsko-dalmatinska županija",
    "Dubrovačko-neretvanska županija"
  ]
end
