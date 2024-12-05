# Here created the Book class with constructor and string method

class Book:
    #Initializes a book object in constructure
    def __init__(self, title: str, author: str):
        self.title = title
        self.author = author
        self.is_available = True
    #Returns a string and tell the availability
    def __str__(self):
        status = "Available" if self.is_available else "Unavailable"
        return f"'{self.title}' by {self.author} - {status}"

# Here created the Library class(Contains a collection of books)  with methods to add and list books 
class Library:
    # constructor
    def __init__(self):
        self.books = []
    # to add the books 1 by 1
    def add_book(self, title: str, author: str):
        book = Book(title, author)
        self.books.append(book)
    #Returns a list of strings showing details of books
    def list_books(self) -> list:
        return [str(book) for book in self.books]
    #Lends a book to a student if it’s available and returns True
    def lend_book(self, book_title: str, student) -> bool:
        for book in self.books:
            if book.title == book_title:
                if book.is_available:
                    if book_title in student.borrowed_books:
                        print(f"'{book_title}' is already borrowed by you.")
                        return False
                    book.is_available = False
                    return True
                else:
                    print(f"'{book_title}' is currently unavailable.")
                    return False
        print(f"'{book_title}' not found in the library.")
        return False
    #Accepts a book being returned by a student and updates its availability.
    def accept_return(self, book_title: str, student):
        for book in self.books:
            if book.title == book_title:
                book.is_available = True
                return
        print(f"'{book_title}' not found in the library.")
    #Returns a list of books matching the search query in title or author.
    def search_books(self, query: str) -> list:
        return [str(book) for book in self.books if query.lower() in book.title.lower() or query.lower() in book.author.lower()]
    #Writes all books and their availability to a file.
    def save_books(self, file_path: str):
        with open(file_path, 'w') as file:
            for book in self.books:
                availability = "1" if book.is_available else "0"
                file.write(f"{book.title},{book.author},{availability}\n")
    #Reads a file and populates the library with books and their availability.
    def load_books(self, file_path: str):
        try:
            with open(file_path, 'r') as file:
                for line in file:
                    title, author, availability = line.strip().split(',')
                    book = Book(title.strip(), author.strip())
                    book.is_available = availability.strip() == "1"
                    self.books.append(book)
        except FileNotFoundError:
            print("File not found. Starting with an empty library.")

# Here created the Student class with methods to borrow the book and return book to the library

class Student:
    def __init__(self, name: str):
        self.name = name
        self.borrowed_books = []
    # method to borrow the book with limit maximum 3
    def borrow_book(self, book_title: str, library: Library):
        if len(self.borrowed_books) >= 3:
            print("Borrowing limit reached (3 books).")
            return
        if library.lend_book(book_title, self):
            self.borrowed_books.append(book_title)
        else:
            print(f"Cannot borrow '{book_title}'.")

    def return_book(self, book_title: str, library: Library):
        if book_title in self.borrowed_books:
            library.accept_return(book_title, self)
            self.borrowed_books.remove(book_title)
        else:
            print(f"You do not have '{book_title}' borrowed.")

# Method provides a menu interface for users to: 
# View all books, Search for a book, Add a new book, Borrow a book, Return a book,     
def run_library_system():
    library = Library()
    library.load_books("library_data.txt")

    while True:
        print("\nLibrary Menu:")
        print("1. View all books")
        print("2. Search for a book")
        print("3. Add a new book")
        print("4. Borrow a book")
        print("5. Return a book")
        print("6. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            for book in library.list_books():
                print(book)

        elif choice == "2":
            query = input("Enter a title or author to search: ")
            results = library.search_books(query)
            if results:
                print("\nSearch Results:")
                for result in results:
                    print(result)
            else:
                print("No matching books found.")

        elif choice == "3":
            title = input("Enter book title: ")
            author = input("Enter book author: ")
            library.add_book(title, author)

        elif choice == "4":
            student_name = input("Enter your name: ")
            book_title = input("Enter the book title to borrow: ")
            student = Student(student_name)
            student.borrow_book(book_title, library)

        elif choice == "5":
            student_name = input("Enter your name: ")
            book_title = input("Enter the book title to return: ")
            student = Student(student_name)
            student.return_book(book_title, library)

        elif choice == "6":
            library.save_books("library_data.txt")
            print("Library data saved. Goodbye!")
            break

        else:
            print("Invalid choice. Please try again.")

run_library_system()

