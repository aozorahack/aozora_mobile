module Aozora

  class Page

    attr_reader :dom

    def initialize(path)
      fetcher = Aozora::Fetcher.new(path)
      @dom = fetcher.fetch('utf-8')
    end

  end

end
