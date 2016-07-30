module Aozora

  class Index

    attr_reader :dom

    def initialize
      fetcher = Aozora::Fetcher.new('')
      @dom = fetcher.fetch
    end

  end

end
