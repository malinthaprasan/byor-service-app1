import ballerina/uuid;
import ballerina/http;

enum Status {
    reading = "reading",
    read = "read",
    to_read = "to_read"
}

type BookItem record {|
    string title;
    string author;
    string status;
|};

type Book record {|
    *BookItem;
    string book_id;
|};

BookItem bookitem1 = {author: "John Carter", status: reading, title: "A Tour To Mars"};
Book book1 = {book_id: uuid:createType1AsString(), ...bookitem1};
string bookId1 = uuid:createType1AsString();

BookItem bookitem2 = {author: "Frank Smith", status: read, title: "Dead Men"};
Book book2 = {book_id: uuid:createType1AsString(), ...bookitem2};
string bookId2 = uuid:createType1AsString();

BookItem bookitem3 = {author: "Jude Silvester", status: to_read, title: "The Bucther"};
Book book3 = {book_id: uuid:createType1AsString(), ...bookitem3};
string bookId3 = uuid:createType1AsString();

map<Book> books = {
    bookId1: book1,
    bookId2: book2,
    bookId3: book3
};

service /readinglist on new http:Listener(9090) {

    resource function get books() returns Book[]|error? {
        return books.toArray();
    }

    resource function post books(@http:Payload BookItem newBook) returns record {|*http:Ok;|}|error? {
        string bookId = uuid:createType1AsString();
        books[bookId] = {...newBook, book_id: bookId};
        return {};
    }

    resource function delete books(string id) returns record {|*http:Ok;|}|error? {
        _ = books.remove(id);
        return {};
    }
}

//hi isuru
