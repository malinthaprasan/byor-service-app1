import ballerina/uuid;
import ballerina/http;
import ballerina/log;


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
Book book1 = {book_id: "01ee2c40-6344-117e-963d-5b5fa299dfd4", ...bookitem1};
string bookId1 = uuid:createType1AsString();

BookItem bookitem2 = {author: "Frank Smith", status: read, title: "Dead Men"};
Book book2 = {book_id: "01ee2c40-6344-117e-a255-56730a9fb1a3", ...bookitem2};
string bookId2 = uuid:createType1AsString();

BookItem bookitem3 = {author: "Jude Silvester", status: to_read, title: "The Bucther"};
Book book3 = {book_id: "01ee2c40-6344-117e-9d1b-94058a6d95d7", ...bookitem3};
string bookId3 = uuid:createType1AsString();

map<Book> books = {
    bookId1: book1,
    bookId2: book2,
    bookId3: book3
};

service /readinglist on new http:Listener(9090) {

    resource function get books() returns Book[]|error? {
         log:printInfo("This is a test log");
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

