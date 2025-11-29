package com.tsinjo.book_borrow.handler;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<String> handleDataIntegrityViolation(DataIntegrityViolationException ex) {
        // Check if the exception message contains the specific constraint violation
        // You might want to make this check more robust based on your database and expected messages
        if (ex.getMessage() != null && ex.getMessage().contains("constraint [uk1j9d9a06i600gd43uu3km82jw]")) {
             return ResponseEntity
                .status(HttpStatus.CONFLICT) // 409 Conflict is suitable for duplicate data
                .body("Email address already exists.");
        }
        // For other data integrity violations, return a generic bad request or internal server error
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body("Data integrity violation: " + ex.getMostSpecificCause().getMessage());
    }

    // You can add more @ExceptionHandler methods here for other exception types
} 