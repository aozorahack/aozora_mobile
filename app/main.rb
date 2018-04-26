require_relative 'index'
require_relative 'top'
require_relative 'book'
require_relative 'card'
require_relative 'page'

helpers do
  def proxy
    fetcher = Aozora::Fetcher.new(request.path)
    content, c_type = fetcher.proxy
    content_type c_type
    content
  end
end

get '/' do
  index = Aozora::Index.new

  haml :main_layout do
    haml :index, locals: {
      index: index,
    }
  end
end

get '/index_pages/index_top.html' do
  top = Aozora::Top.new
  haml :main_layout do
    haml :top, locals: {
      tables: top.tables,
      headers: top.headers
    }
  end
end

get %r{/cards/(\d{6})/files/(\d+)_(\d+)} do |person_id, book_id, book_format_id|
  book = Aozora::Book.new(person_id, book_id, book_format_id)
  charset = 'Shift_JIS'
  content_type :html, charset: charset
  haml :book, locals: {
    book: book,
    charset: charset
  }
end

get %r{/cards/(\d{6})/card(\d+)} do |person_id, book_id|
  card = Aozora::Card.new(person_id, book_id)
  haml :main_layout do
    haml :card, locals: {
      card: card,
    }
  end
end

get '/css/card.css' do
  sass :'sass/card'
end

get '/css/index.css' do
  sass :'sass/index'
end

get '/css/top.css' do
  sass :'sass/top'
end

get '/css/main.css' do
  sass :'sass/main'
end

get '/css/book.css' do
  sass :'sass/book'
end

get '/*.ico' do
  proxy
end

get '/images/*.png' do
  proxy
end

get '/*' do
  page = Aozora::Page.new(request.path.gsub(%r{^/}, ''))
  haml :main_layout do
    haml :page, locals: {
      page: page
    }
  end
end
