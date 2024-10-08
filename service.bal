import ballerina/http;

// Define a record to represent a book
type Book record {|
    // The key must be read-only
    readonly int id;
    string title;
    string author;
    int publication_year;
|};

table<Book> key(id) books = table [
    {id: 1, title: "The Great Gatsby", author: "F. Scott Fitzgerald", publication_year: 1925},
    {id: 2, title: "To Kill a Mockingbird", author: "Harper Lee", publication_year: 1960},
    {id: 3, title: "1984", author: "George Orwell", publication_year: 1949}
];

# A service representing a network-accessible API
# bound to port `9090`.
service /bookstore on new http:Listener(9090) {      
    // Get all books (GET)
    resource function get books() returns Book[] {
        return books.toArray();
    }
    
    // Get details of a single book by ID (GET)
    resource function get book/[int id]() returns Book|http:NotFound {
        Book? book = books[id];
        if book is () {
            return http:NOT_FOUND;
        }
        return book;
    }

    // Get details of books by author's name (GET)
    resource function get books/author(string name) returns Book[]|http:NotFound {
        Book[] authorBooks = from Book book in books
                            where book.author.toLowerAscii() == name.toLowerAscii()
                            select book;
        
        if authorBooks.length() == 0 {
            return http:NOT_FOUND;
        }
        return authorBooks;
    }

    // Create a new book (POST)
    resource function post books(@http:Payload Book newBook) returns Book|error {
        error? result = books.add(newBook);
        if result is error {
            return result;
        }
        return newBook;
    }

    // Update a book (PUT)
    resource function put book/[int id](@http:Payload Book updatedBook) returns Book|http:NotFound {
        Book? existingBook = books[id];
        if existingBook is () {
            return http:NOT_FOUND;
        }
        books.put(updatedBook);
        return updatedBook;
    }

    // Delete a book (DELETE)
    resource function delete book/[int id]() returns http:NoContent|http:NotFound {
        Book? existingBook = books[id];
        if existingBook is () {
            return http:NOT_FOUND;
        }
        _ = books.remove(id);
        return http:NO_CONTENT;
    }    
}