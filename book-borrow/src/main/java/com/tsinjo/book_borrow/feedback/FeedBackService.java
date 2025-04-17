package com.tsinjo.book_borrow.feedback;

import com.tsinjo.book_borrow.book.Book;
import com.tsinjo.book_borrow.book.BookRepository;
import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FeedBackService {
    private final BookRepository bookRepository;
    public Integer save(FeedBackRequest request, Authentication connectedUser) {
        Book book = bookRepository.findById()
        return  null;
    }
}
