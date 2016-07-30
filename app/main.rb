require_relative 'index'
require_relative 'book'

get '/' do
  index = Aozora::Index.new
  haml :index, locals: {
    index: index,
    hoge: 'fuga',
  }
end

get %r{cards/(\d{6})/files/(\d+)_(\d+)} do |person_id, book_id, book_format_id|
  book = Aozora::Book.new(person_id, book_id, book_format_id)
  haml :book, locals: {
    book: book,
    charset: 'Shift_JIS'
  }
end
