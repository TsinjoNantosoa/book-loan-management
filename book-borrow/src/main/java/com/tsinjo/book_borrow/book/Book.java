// src/main/java/com/tsinjo/book_borrow/book/book.java
package com.tsinjo.book_borrow.book;

// ... other imports
import com.tsinjo.book_borrow.common.BasedEntity;
import com.tsinjo.book_borrow.feedback.Feedback;
import com.tsinjo.book_borrow.history.BookTransactionHistory;
import com.tsinjo.book_borrow.user.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

import java.util.List;

@Entity
@Getter
@Setter
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public class Book extends BasedEntity {


    @Getter
    private String title;
    @Getter
    private String authorName;
    @Getter
    private String isbn;
    @Getter
    private String synopsis;
    @Getter
    private String bookCover;
    @Getter
    private boolean archived;
    @Getter
    private boolean shareable;


    @Getter
    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;

    @Getter
    @OneToMany(mappedBy = "book")
    private List<Feedback> feedbacks;

    @OneToMany(mappedBy = "book")
    private List<BookTransactionHistory> histories;


    public void setTitle(String title) {
        this.title = title;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public void setSynopsis(String synopsis) {
        this.synopsis = synopsis;
    }

    public void setBookCover(String bookCover) {
        this.bookCover = bookCover;
    }

    public void setArchived(boolean archived) {
        this.archived = archived;
    }

    public void setShareable(boolean shareable) {
        this.shareable = shareable;
    }

    public void setOwner(User owner) {
        this.owner = owner;
    }

    public void setFeedbacks(List<Feedback> feedbacks) {
        this.feedbacks = feedbacks;
    }

    public void setHistories(List<BookTransactionHistory> histories) {
        this.histories = histories;
    }

    @Transient
    double getRate(){
        if (feedbacks == null || feedbacks.isEmpty()) {
            return  0.0;
        }
        var rate = this.feedbacks.stream()
                .mapToDouble(Feedback::getNote)
                .average()
                .orElse(0.0);
        double roundedRate = Math.round(rate * 10.0 / 10.0);
        return roundedRate;
    }


}