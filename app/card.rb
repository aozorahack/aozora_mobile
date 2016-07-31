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

      title_data_el = @dom.at_css('[summary="タイトルデータ"]')

      title_el = title_data_el.css('tr').find do |tr|
        tr.children.at('td')&.text&.include?('作品名')
      end

      @info[:title] = title_el.at_css('td:nth-child(2)').text

      author_el = title_data_el.css('tr').find do |tr|
        tr.children.at('td')&.text&.include?('著者名')
      end

      @info[:author] = author_el.at_css('td:nth-child(2)').text
      @info[:author_url] = author_el.at_css('td:nth-child(2) a').attribute('href')

      link_body_el = @dom.css('a').find do |a|
        a.text == 'いますぐXHTML版で読む'
      end

      @info[:body_url] = link_body_el.attribute('href')

      work_data_el = @dom.at_css('[summary="作品データ"]')

      description_el = work_data_el.css('tr').find do |tr|
        tr.children.at('td')&.text&.include?('作品について')
      end

      unless description_el.nil?
        @info[:description] = description_el.at_css('td:nth-child(2)').text
      end

      letter_type_el = work_data_el.css('tr').find do |tr|
        tr.children.at('td')&.text&.include?('文字遣い種別')
      end

      @info[:letter_type] = letter_type_el.at_css('td:nth-child(2)').text

      remarks_el = work_data_el.css('tr').find do |tr|
        tr.children.at('td')&.text&.include?('備考')
      end

      @info[:remarks] = remarks_el.at_css('td:nth-child(2)').text

      author_data_els = @dom.css('[summary="作家データ"]')

      @info[:authors] = author_data_els.map do |author_data_el|
        author_data = {}

        role_el = author_data_el.css('tr').find do |tr|
          tr.children.at('td')&.text&.include?('分類')
        end

        author_data[:role] = role_el.at_css('td:nth-child(2)').text

        name_el = author_data_el.css('tr').find do |tr|
          tr.children.at('td')&.text&.include?('作家名')
        end

        author_data[:name] = name_el.at_css('td:nth-child(2)').text

        kana_el = author_data_el.css('tr').find do |tr|
          tr.children.at('td')&.text&.include?('読み')
        end

        author_data[:kana] = kana_el.at_css('td:nth-child(2)').text

        description_el = author_data_el.css('tr').find do |tr|
          tr.children.at('td')&.text&.include?('人物について')
        end

        unless description_el.nil?
          wikipedia_el = description_el.at_css('a:nth-child(2)')

          unless wikipedia_el.nil?
            author_data[:wikipedia] = wikipedia_el.attribute('href')
          end

          description_el.css('a').remove

          author_data[:description] = description_el.at_css('td:nth-child(2)').text.gsub('「」', '')
        end

        author_data
      end

      planter_data_el = @dom.at_css('[summary="工作員データ"]')

      @info[:planters] = planter_data_el.css('tr').map do |tr|
        planter = {}
        planter[:role] = tr.at_css('td:nth-child(1)').text.gsub('：', '')
        planter[:name] = tr.at_css('td:nth-child(2)').text
        planter
      end
    end

  end

end
