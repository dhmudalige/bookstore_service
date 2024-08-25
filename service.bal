import ballerina/http;

// Define a record to represent a book
type Book record {|
    // The key must be read-only
    readonly int id;
    string title;
    string author;
    int year;
|};

// // In-memory storage for books
// map<Book> books = {};

table<Book> key(id) books = table [
    {id: 1, title: "The Great Gatsby", author: "F. Scott Fitzgerald", year: 1925},
    {id: 2, title: "To Kill a Mockingbird", author: "Harper Lee", year: 1960},
    {id: 3, title: "1984", author: "George Orwell", year: 1949}
];

# A service representing a network-accessible API
# bound to port `9090`.
service /bookstore on new http:Listener(9090) {  
    // Create a new book (POST)
    // resource function post books(Book book) returns Book|error {
    //     // Add the book to the in-memory storage
    //     // books[book.id] = book;
    //     books.add(book);
    //     return book;
    // }
    
    // Get all books (GET)
    resource function get books() returns Book[] {
        return books.toArray();
    }
}