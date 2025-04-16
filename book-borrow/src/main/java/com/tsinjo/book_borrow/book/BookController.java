package com.tsinjo.book_borrow.book;

import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("books")
@RequiredArgsConstructor
@Tag(name = "Book")
public class BookController {

    private final BooService service;

    @PostMapping("")
    public ResponseEntity<Integer> saveBook(
            @Valid @RequestBody BookRequest request,
            Authentication connectedUser
    ){
        return ResponseEntity.ok(service.save(request, connectedUser));
    }

    @GetMapping("{book-id}")
    public  ResponseEntity<BookResponse> findById(
            @PathVariable("book-id") Integer bookId
    ){
        return ResponseEntity.ok(service.findById(bookId));
    }

}
