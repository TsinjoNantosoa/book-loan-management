package com.tsinjo.book_borrow.book;

import com.tsinjo.book_borrow.exception.OperationNotPermittedException;
import com.tsinjo.book_borrow.file.FileStorageService;
import com.tsinjo.book_borrow.history.BookTransactionHistory;
import com.tsinjo.book_borrow.history.BookTransactionHistoryRepository;
import com.tsinjo.book_borrow.user.User;
import jakarta.persistence.EntityNotFoundException;
//import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Objects;
import static com.tsinjo.book_borrow.book.BookSpecification.withOwnerId;

@Service
public class BookService {
    private  final BookRepository bookRepository;
    private final BookMapper bookMapper;
    private final BookTransactionHistoryRepository bookTransactionHistoryRepository;
    private BookTransactionHistoryRepository transactionHistoryRepository;
    private final FileStorageService fileStorageService;

    public BookService(BookRepository bookRepository, BookMapper bookMapper, BookTransactionHistoryRepository bookTransactionHistoryRepository, FileStorageService fileStorageService) {
        this.bookRepository = bookRepository;
        this.bookMapper = bookMapper;
        this.bookTransactionHistoryRepository = bookTransactionHistoryRepository;
        this.fileStorageService = fileStorageService;
    }


    public Integer save(BookRequest request, Authentication connectedUser) {
        User user = ((User) connectedUser.getPrincipal());
        Book book = bookMapper.tobook(request);
        book.setOwner(user);
        return bookRepository.save(book).getId();
    }

    public BookResponse findById(Integer bookId) {
        return bookRepository.findById(bookId)
                .map(bookMapper::toBookResponse)
                .orElseThrow(() -> new EntityNotFoundException("The book isn´t food with this id ::" + bookId));

    }

    public PageResponse<BookResponse> findAllBooks(int page, int size, Authentication connectedUser) {
        User user = ((User) connectedUser.getPrincipal());
        Pageable pageable = PageRequest.of(page, size, Sort.by("created date").descending());
        Page<Book> books = bookRepository.findAllDisplayableBooks(pageable, user.getId());
        List<BookResponse> bookResponse = books.stream()
                .map(bookMapper::toBookResponse)
                .toList();
        return new PageResponse<>(
                bookResponse,
                books.getNumber(),
                books.getSize(),
                (int) books.getTotalElements(),
                books.getTotalPages(),
                books.isFirst(),
                books.isLast()
        );

    }

    public PageResponse<BookResponse> findAllBooksByOwner(int page, int size, Authentication connectedUser) {
        User user = ((User) connectedUser.getPrincipal());
        Pageable pageable = PageRequest.of(page, size, Sort.by("created date").descending());
        Page<Book> books = bookRepository.findAll(withOwnerId(user.getId()), pageable);
        return null;
    }

    public PageResponse<BorrowedBookResponse> findAllBorrowedBooks(int page, int size, Authentication connectedUser) {
        User user = ((User) connectedUser.getPrincipal());
        Pageable pageable = PageRequest.of(page, size, Sort.by("created date").descending());
        Page<BookTransactionHistory> allBorrowedBooks = bookTransactionHistoryRepository.findAllBorrowedBooks(pageable, user.getId());
        List<BorrowedBookResponse> bookResponse = (List<BorrowedBookResponse>) allBorrowedBooks.stream()
                .map((java.util.function.Function<? super BookTransactionHistory, ? extends BorrowedBookResponse>) bookMapper::toBorrowedBookResponse)
                .toList();

        return new PageResponse<>(
                bookResponse,
                allBorrowedBooks.getNumber(),
                allBorrowedBooks.getSize(),
                (int) allBorrowedBooks.getTotalElements(),
                allBorrowedBooks.getTotalPages(),
                allBorrowedBooks.isFirst(),
                allBorrowedBooks.isLast()
        );


    }

    public PageResponse<BorrowedBookResponse> findAllReturnedBooks(int page, int size, Authentication connectedUser) {
        User user = ((User) connectedUser.getPrincipal());
        Pageable pageable = PageRequest.of(page, size, Sort.by("created date").descending());
        Page<BookTransactionHistory> allBorrowedBooks = bookTransactionHistoryRepository.findAllReturnedBooks(pageable, user.getId());
        List<BorrowedBookResponse> bookResponse = (List<BorrowedBookResponse>) allBorrowedBooks.stream()
                .map((java.util.function.Function<? super BookTransactionHistory, ? extends BorrowedBookResponse>) bookMapper::toBorrowedBookResponse)
                .toList();

        return new PageResponse<>(
                bookResponse,
                allBorrowedBooks.getNumber(),
                allBorrowedBooks.getSize(),
                (int) allBorrowedBooks.getTotalElements(),
                allBorrowedBooks.getTotalPages(),
                allBorrowedBooks.isFirst(),
                allBorrowedBooks.isLast()
        );
    }

    public Integer updateShareableStatus(Integer bookId, Authentication connectedUser) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new EntityNotFoundException("The book isn't find with this id:" + bookId));
        User user = ((User) connectedUser.getPrincipal());
        if (!Objects.equals(book.getOwner().getId(), user.getId())){
            throw  new OperationNotPermittedException("Sorry!!, you can't update books shareable status");
        }
        book.setShareable(!book.isShareable());
        bookRepository.save(book);
        return  bookId;

    }

    public Integer updateArchivedStatus(Integer bookId, Authentication connectedUser) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new EntityNotFoundException("The book isn't find with this id:" + bookId));
        User user = ((User) connectedUser.getPrincipal());
        if (!Objects.equals(book.getOwner().getId(), user.getId())){
            throw  new OperationNotPermittedException("Sorry!!, you can't update books archive status");
        }
        book.setShareable(!book.isShareable());
        bookRepository.save(book);
        return  bookId;
    }

    public Integer borrowedBook(Integer bookId, Authentication connectedUser) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(()->new EntityNotFoundException("There is no book with this Id :" + bookId + "please try another id!!"));
        if (book.isArchived() || book.isShareable()) {
            throw new OperationNotPermittedException("The request book can't borrowed since it is archived or not shareable");
        }
        User user = ((User) connectedUser.getPrincipal());
        if (Objects.equals(book.getOwner().getId(), user.getId())){
            throw  new OperationNotPermittedException("Sorry!!, you can't borrow your own book");
        }
        final  boolean isAlreadyBorrowed = transactionHistoryRepository.isAlreadyBorrowedByUser(bookId, user.getId());
        if (isAlreadyBorrowed) {
            throw new OperationNotPermittedException("The request book is already borrowed");
        }
        BookTransactionHistory bookTransactionHistory =  BookTransactionHistory.builder()
                .user(user)
                .book(book)
                .returned(false)
                .returnedApproved(false)
                .build();
        return  transactionHistoryRepository.save(bookTransactionHistory).getId();

    }

    public Integer returnBorrowBook(Integer bookId, Authentication connectedUser) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(()->new EntityNotFoundException("There is no book with this Id :" + bookId + "please try another id!!"));
        if (book.isArchived() || book.isShareable()) {
            throw new OperationNotPermittedException("The request book can't borrowed since it is archived or not shareable");
        }
        User user = ((User) connectedUser.getPrincipal());
        if (Objects.equals(book.getOwner().getId(), user.getId())){
            throw  new OperationNotPermittedException("Sorry!!, you can't neither borrow nor return your own book");
        }
        BookTransactionHistory bookTransactionHistory = transactionHistoryRepository.findByBookIdAndUserId(bookId, user.getId())
                .orElseThrow(() ->new OperationNotPermittedException("You can't Borrowed this book right now !!"));
        bookTransactionHistory.setReturned(true);
        return  transactionHistoryRepository.save(bookTransactionHistory).getId();

    }

    public Integer approveReturnBorrowBook(Integer bookId, Authentication connectedUser) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(()->new EntityNotFoundException("There is no book with this Id :" + bookId + "please try another id!!"));
        if (book.isArchived() || book.isShareable()) {
            throw new OperationNotPermittedException("The request book can't borrowed since it is archived or not shareable");
        }
        User user = ((User) connectedUser.getPrincipal());
        if (Objects.equals(book.getOwner().getId(), user.getId())){
            throw  new OperationNotPermittedException("Sorry!!, you can't neither borrow nor return your own book");
        }
        BookTransactionHistory bookTransactionHistory = transactionHistoryRepository.findByBookIdAndOwnerId(bookId, user.getId())
                .orElseThrow(() ->new OperationNotPermittedException("The book isn't returned ,You can't approved this return  !!"));
        bookTransactionHistory.setReturned(true);
        return  transactionHistoryRepository.save(bookTransactionHistory).getId();
    }

    public void uploadBookCoverPicture(Integer bookId, MultipartFile file, Authentication connectedUser) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(()->new EntityNotFoundException("There is no book with this Id :" + bookId + "please try another id!!"));
        User user = ((User) connectedUser.getPrincipal());

        var bookCover = fileStorageService.saveFile(file,user.getId());
        book.setBookCover(bookCover);
        bookRepository.save(book);
    }
}
