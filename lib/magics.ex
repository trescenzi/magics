defmodule Magics do
  def get_top_cards_at_page(page) do 
    Tesla.get("http://www.mtgtop8.com/topcards?f=MO&meta=51&current_page=#{page}") 
  end 

  def get_card_names_at_page(page) do
    response_body = get_top_cards_at_page(page).body
    list_of_names = Floki.parse(response_body)
                    |> Floki.find(".L14") 
                    |> Enum.take_every(3) 
                    |> Enum.map(fn(x) -> elem(x,2) end)
    List.flatten list_of_names
  end

  def parallel_card_fetch do
    list_of_names = []
    me = self
    Enum.map( 1..20, fn(page_num) ->
      spawn_link fn -> 
        send(me, {self, get_card_names_at_page page_num})
      end
    end)
    |> Enum.map( fn(pid) ->
      receive do {^pid, names} -> 
        list_of_names ++ names
      end
    end)
  end

  def most_played_modern_cards do
    List.flatten parallel_card_fetch
  end
end
