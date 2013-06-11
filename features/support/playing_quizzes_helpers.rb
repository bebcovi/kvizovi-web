module PlayingQuizzesHelpers
  def answers(&block)
    loop do
      block.call

      if page.has_link?("Sljedeće pitanje")
        click_on "Sljedeće pitanje"
      else
        click_on "Rezultati"
        break
      end
    end
  end

  def connect(hash)
    hash.each_with_index do |(left, right), index|
      divs = all(".association-pair")[index].all("td")
      divs.first.fill_in :play_answer, with: left
      divs.last.fill_in :play_answer, with: right
    end
  end
end

World(PlayingQuizzesHelpers)
