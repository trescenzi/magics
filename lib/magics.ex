defmodule Magics do
  def get_top_cards_at_page(page) do 
    Tesla.get("http://www.mtgtop8.com/topcards?f=MO&meta=51&current_page=#{page}") 
  end 

  def get_card_names_at_page(page) do
    response_body = get_top_cards_at_page(1).body
    list_of_names = Floki.parse(response_body)
                    |> Floki.find(".L14") 
                    |> Enum.take_every(3) 
                    |> Enum.map(fn(x) -> elem(x,2) end)
    List.flatten list_of_names
  end
  def modern_most_played_cards do
    Enum.reduce(1..20, [], fn(page_num, list_of_names) ->
      list_of_names ++ get_card_names_at_page(page_num)  
    end)
  end
end
