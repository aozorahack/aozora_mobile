module Aozora

  class Index

    attr_reader :dom, :info

    def initialize
      fetcher = Aozora::Fetcher.new('')
      @dom = fetcher.fetch('utf-8')
      get_info
    end

    def get_info
      @info = {}

      information_el = @dom.at_css('[summary=information]')

      latest_work_el = information_el.css('tr').find do |tr|
        tr.children.at('td.subheader')&.text&.include?('最新公開作品')
      end

      @info[:latest_work_name] = latest_work_el.at_css('td.summary').text
      @info[:latest_work_url] = latest_work_el.at_css('td.summary > a').attribute('href')
    end

  end

end
