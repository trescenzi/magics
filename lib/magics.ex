defmodule Magics do
  def most_played_modern_cards do
    List.flatten Magics.Scraper.parallel_card_name_fetch("MO")
  end
end
