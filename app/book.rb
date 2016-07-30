module Aozora

  class Book

    attr_reader :body

    def initialize(person_id, book_id, book_format_id)
      dir = %{cards/#{person_id}/files}
      path = %{#{dir}/#{book_id}_#{book_format_id}}

      fetcher = Fetcher.new(path)
      response = fetcher.fetch
      @body = response.css('body')
      @body.css('.main_text img').map do |img|
        img['src'] = %{#{Fetcher::BASE_URI}/#{dir}/#{img['src']}}
      end
    end

  end

end
