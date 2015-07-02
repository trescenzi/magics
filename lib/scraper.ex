defmodule Magics.Scraper do
  def get_top_cards_at_page(page \\ "1", format \\ "MO") do 
    Tesla.get("http://www.mtgtop8.com/topcards?f=#{format}&meta=51&current_page=#{page}") 
  end 

  def get_card_names_with_class(parsed_html, class \\".L14") do
    Floki.find(parsed_html, class) 
      |> Enum.take_every(3) 
      |> Enum.map(fn(x) -> elem(x,2) end)
  end

  def get_card_names_at_page(page \\ "1", format \\ "MO") do
    response_body = get_top_cards_at_page(page, format).body
    parsed_response = Floki.parse(response_body)
    first_card = get_card_names_with_class(parsed_response, ".W14")
    rest = get_card_names_with_class(parsed_response, ".L14")
    List.flatten( first_card ++ rest )
  end

  def parallel_card_name_fetch(format \\"MO") do
    list_of_names = []
    parent = self
    Enum.map( 1..20, fn(page_num) ->
      spawn_link fn -> 
        send(parent, {self, get_card_names_at_page(page_num, format)})
      end
    end)
    |> Enum.map( fn(pid) ->
      receive do {^pid, names} -> 
        list_of_names ++ names
      end
    end)
  end
end
