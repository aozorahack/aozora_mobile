get '/' do
  haml :index
end

get %r{cards/(\d{6})/files/(\d+)_(\d+)} do |person_id, book_id, book_format_id|
  book = Book.new(person_id, book_id, book_format_id)
  haml :book, locals: {
    book: book
  }
end
