require_relative 'index'
require_relative 'book'

get '/' do
  index = Aozora::Index.new

  haml :main_layout do
    haml :index, locals: {
      index: index,
      hoge: 'fuga',
    }
  end
end

get %r{cards/(\d{6})/files/(\d+)_(\d+)} do |person_id, book_id, book_format_id|
  book = Aozora::Book.new(person_id, book_id, book_format_id)
  charset = 'Shift_JIS'
  content_type :html, charset: charset
  haml :book, locals: {
    book: book,
    charset: charset
  }
end

get '/css/index.css' do
  sass :'sass/index'
end

get '/css/main.css' do
  sass :'sass/main'
end

get '/css/book.css' do
  sass :'sass/book'
end
