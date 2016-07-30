module Aozora

  class Book

    attr_reader :body

    def initialize(person_id, book_id, book_format_id)
      path = %{cards/#{person_id}/files/#{book_id}_#{book_format_id}}

      fetcher = Fetcher.new(path)
      response = fetcher.fetch
      @body = response.css('body')
      imgs = @body.css('.main_text img')
      imgs.map {|img| img['src'] = "http://www.aozora.gr.jp/cards/#{person_id}/files/#{img['src']}" }
    end

  end

end
