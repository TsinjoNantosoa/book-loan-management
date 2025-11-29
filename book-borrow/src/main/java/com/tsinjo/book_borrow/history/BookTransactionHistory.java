package com.tsinjo.book_borrow.history;

import com.tsinjo.book_borrow.book.Book;
import com.tsinjo.book_borrow.common.BasedEntity;
import com.tsinjo.book_borrow.user.User;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;


@Getter
@Entity
@Setter
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public class BookTransactionHistory extends BasedEntity {
    //this is the user relationship with book relationship

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "book_id")
    private Book book;

    private boolean returned;
    private boolean returnedApproved;

    public void setUser(User user) {
        this.user = user;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public void setReturned(boolean returned) {
        this.returned = returned;
    }

    public void setReturnedApproved(boolean returnedApproved) {
        this.returnedApproved = returnedApproved;
    }



}
