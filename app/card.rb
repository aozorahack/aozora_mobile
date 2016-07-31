module Aozora

  class Card

    attr_reader :dom, :info

    def initialize(person_id, book_id)
      fetcher = Aozora::Fetcher.new("cards/#{person_id}/card#{book_id}.html")
      @dom = fetcher.fetch('utf-8')
      get_info
    end

    def get_info
      @info = {}
    end

  end

end
