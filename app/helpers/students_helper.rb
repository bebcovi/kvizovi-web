# encoding: utf-8

module StudentsHelper
  def classes
    {
      "Osnovna škola" => ordinalize(1..8).zip(1..8),
      "Srednja škola" => ordinalize(1..4).zip(1..4)
    }
  end
end
