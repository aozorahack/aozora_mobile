module Aozora

  class Fetcher

    attr_reader :url

    BASE_URI = 'http://www.aozora.gr.jp'

    def initialize(url)
      @url = "#{BASE_URI}/#{url}"
    end

    def proxy
      content = content_type = nil
      open(url) do |f|
        content_type = f.content_type
        content = f.read
      end
      return content, content_type
    end

    def fetch(charset = nil)
      html = open(url) do |f|
        charset ||= f.charset
        f.read
      end
      Nokogiri::HTML.parse(html, nil, charset)
    end

  end

end
