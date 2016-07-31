module Aozora

  class Top

    attr_reader :tables, :headers

    def initialize()
      fetcher = Fetcher.new('index_pages/index_top.html')
      response = fetcher.fetch('euc-jp')
      @headers = ['公開中の作品', '作業中の作品']
      @tables = response.css('table table')
    end

  end
end
