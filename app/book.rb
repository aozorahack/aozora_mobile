module Aozora

  class Book

    attr_reader :body

    def initialize(person_id, book_id, book_format_id)
      dir = %{cards/#{person_id}/files}
      path = %{#{dir}/#{book_id}_#{book_format_id}}

      fetcher = Fetcher.new(path)
      response = fetcher.fetch('Shift_JIS')
      @body = response.css('body')
      gaiji_img_to_html_entity!
      remove_script!
      dot_emphasize!
      normalize_path!(%{#{Fetcher::BASE_URI}/#{dir}})
    end

    def normalize_path!(path)
      @body.css('[src]').map do |img|
        img['src'] = %{#{path}/#{img['src']}}
      end
    end

    def gaiji_img_to_html_entity!
      @body.css('img.gaiji').map do |img|
        m, k, t = File.basename(img['src'], '.png').split(?-).map(&:to_i)
        charcode = ((0xa0 + k) << 8) + 0xa0 + t
        charcode += 0x8f0000 if m == 2
        img.replace(
          Nokogiri::HTML.fragment(
            charcode.chr('euc-jis-2004').encode('UTF-8').gsub(/[^\u{0}-\u{FFFF}]/) { '&#x%X;' % $&.ord }
          )
        )
      end
    end

    def remove_script!
      @body.css('script').remove
    end

    def dot_emphasize!
      classes = %w{
        .sesame_dot
        .white_sesame_dot
        .black_circle
        .white_circle
        .black_up-pointing_triangle
        .white_up-pointing_triangle
        .bullseye
        .fisheye
        .saltire
      }.join(?,)
      @body.css(classes).map do |bouten|
        bouten.inner_html = Nokogiri::HTML.fragment(bouten.text.encode('Shift_JIS').each_char.map {|char|
          "<span><b>#{char}</b></span>"
        }.join)
      end
    end

  end

end
