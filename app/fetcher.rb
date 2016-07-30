module Aozora

  class Fetcher

    attr_reader :url

    BASE_URI = 'http://www.aozora.gr.jp'

    def initialize(url)
      @url = "#{BASE_URI}/#{url}"
    end

    def fetch(charset = 'utf-8')
      html = open(url) do |f|
        f.read
      end
      Nokogiri::HTML.parse(html, nil, charset)
    end

  end

end
