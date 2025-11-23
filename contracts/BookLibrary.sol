// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Decentralized Library / Book Exchange
/// @notice Minimal DApp contract with 5 core functions (3 write, 2 read)
/// @dev No external dependencies; designed for teaching + quick prototyping
contract BookLibrary {
    // ---------- Errors ----------
    error NotBookOwner();
    error BookDoesNotExist();
    error BookAlreadyBorrowed();
    error BookNotBorrowed();
    error NotBorrower();

    // ---------- Types ----------
    struct Book {
        uint256 id;
        string title;          // e.g., "Clean Code"
        string contentHash;    // e.g., IPFS CID or SHA-256 hex
        address owner;         // the user who listed the book
        address borrower;      // current borrower (0x0 if available)
        uint64  borrowedAt;    // timestamp when borrowed (0 if available)
        uint32  totalBorrows;  // simple stat
    }

    struct BorrowRecord {
        uint256 bookId;
        uint64  borrowedAt;
        uint64  returnedAt;    // 0 until returned
    }

    // ---------- Storage ----------
    uint256 private _nextBookId = 1;
    mapping(uint256 => Book) private _books;                // bookId => Book
    mapping(address => BorrowRecord[]) private _history;    // user => history

    // ---------- Events ----------
    event BookAdded(uint256 indexed bookId, address indexed owner, string title, string contentHash);
    event BookBorrowed(uint256 indexed bookId, address indexed borrower, uint64 borrowedAt);
    event BookReturned(uint256 indexed bookId, address indexed borrower, uint64 returnedAt);

    // =========================================================
    //                      WRITE FUNCTIONS
    // =========================================================

    /// @notice Add a new book to the library
    /// @param title Human-readable title
    /// @param hash  Content hash / IPFS CID / off-chain reference
    /// @return bookId The newly created book ID
    function addBook(string calldata title, string calldata hash) external returns (uint256 bookId) {
        bookId = _nextBookId++;
        _books[bookId] = Book({
            id: bookId,
            title: title,
            contentHash: hash,
            owner: msg.sender,
            borrower: address(0),
            borrowedAt: 0,
            totalBorrows: 0
        });

        emit BookAdded(bookId, msg.sender, title, hash);
    }

    /// @notice Borrow a book if available
    /// @param bookId The ID of the book to borrow
    function borrowBook(uint256 bookId) external {
        Book storage b = _books[bookId];
        if (b.id == 0) revert BookDoesNotExist();
        if (b.borrower != address(0)) revert BookAlreadyBorrowed();

        b.borrower = msg.sender;
        b.borrowedAt = uint64(block.timestamp);
        b.totalBorrows += 1;

        // record an open borrow (returnedAt = 0)
        _history[msg.sender].push(BorrowRecord({
            bookId: bookId,
            borrowedAt: uint64(block.timestamp),
            returnedAt: 0
        }));

        emit BookBorrowed(bookId, msg.sender, uint64(block.timestamp));
    }

    /// @notice Return a borrowed book
    /// @param bookId The ID of the book to return
    function returnBook(uint256 bookId) external {
        Book storage b = _books[bookId];
        if (b.id == 0) revert BookDoesNotExist();
        if (b.borrower == address(0)) revert BookNotBorrowed();
        if (b.borrower != msg.sender) revert NotBorrower();

        // close latest open borrow record for this user & bookId
        BorrowRecord[] storage recs = _history[msg.sender];
        for (uint256 i = recs.length; i > 0; i--) {
            BorrowRecord storage r = recs[i - 1];
            if (r.bookId == bookId && r.returnedAt == 0) {
                r.returnedAt = uint64(block.timestamp);
                break;
            }
        }

        b.borrower = address(0);
        b.borrowedAt = 0;

        emit BookReturned(bookId, msg.sender, uint64(block.timestamp));
    }

    // =========================================================
    //                      READ FUNCTIONS
    // =========================================================

    /// @notice Get the list of available (not currently borrowed) book IDs
    function getAvailableBooks() external view returns (uint256[] memory ids) {
        // First pass: count available
        uint256 count;
        for (uint256 id = 1; id < _nextBookId; id++) {
            if (_books[id].id != 0 && _books[id].borrower == address(0)) {
                count++;
            }
        }

        // Second pass: collect IDs
        ids = new uint256[](count);
        uint256 idx;
        for (uint256 id2 = 1; id2 < _nextBookId; id2++) {
            if (_books[id2].id != 0 && _books[id2].borrower == address(0)) {
                ids[idx++] = id2;
            }
        }
    }

    /// @notice Get a user's full borrow/return history
    /// @param user The address to query
    function getUserHistory(address user) external view returns (BorrowRecord[] memory) {
        return _history[user];
    }

    // =========================================================
    //                 OPTIONAL VIEW HELPERS (frontend)
    //            (not required by the 5 core functions)
    // =========================================================
    /// @notice Helper to fetch a book's full details (useful for UI)
    function getBook(uint256 bookId)
        external
        view
        returns (
            uint256 id,
            string memory title,
            string memory contentHash,
            address owner,
            address borrower,
            uint64 borrowedAt,
            uint32 totalBorrows
        )
    {
        Book storage b = _books[bookId];
        if (b.id == 0) revert BookDoesNotExist();
        return (b.id, b.title, b.contentHash, b.owner, b.borrower, b.borrowedAt, b.totalBorrows);
    }
}
