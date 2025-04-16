package com.tsinjo.book_borrow.book;

import com.tsinjo.book_borrow.user.User;
import jakarta.persistence.EntityNotFoundException;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;

public class BooService {
    private  final BookRepository bookRepository;
    private final  BookMapper bookMapper;

    public BooService(BookRepository bookRepository, BookMapper bookMapper) {
        this.bookRepository = bookRepository;
        this.bookMapper = bookMapper;
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
}
