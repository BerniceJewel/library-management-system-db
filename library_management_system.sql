-- Database: Library Management System

-- 1. Create the 'books' table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    published_date DATE,
    genre VARCHAR(50),
    quantity INT NOT NULL CHECK (quantity >= 0)
);

-- 2. Create the 'members' table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    join_date DATE NOT NULL
);

-- 3. Create the 'loans' table to track book loans
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    return_date DATE,
    status ENUM('loaned', 'returned', 'overdue') NOT NULL DEFAULT 'loaned',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT chk_return_date CHECK (return_date >= loan_date) -- Ensure return date is not before loan date
);

-- 4. Create the 'reservations' table to manage book reservations
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    status ENUM('pending', 'available', 'cancelled') NOT NULL DEFAULT 'pending',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 5. Create the 'book_reviews' table to store reviews for books
CREATE TABLE book_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5), -- Rating between 1 and 5
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 6. Create the 'authors' table
CREATE TABLE authors (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  biography TEXT,
  date_of_birth DATE,
  date_of_death DATE,
  --  Add a constraint to ensure date_of_death is after date_of_birth
  CONSTRAINT chk_death_date CHECK (date_of_death IS NULL OR date_of_birth IS NULL OR date_of_death > date_of_birth)
);

-- 7. Create a junction table for a many-to-many relationship between books and authors
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);
