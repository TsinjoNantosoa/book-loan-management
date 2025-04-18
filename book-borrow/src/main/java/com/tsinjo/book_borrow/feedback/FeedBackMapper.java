package com.tsinjo.book_borrow.feedback;

import com.tsinjo.book_borrow.book.Book;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
public class FeedBackMapper {
    public Feedback toFeedBck(FeedBackRequest request) {
        return Feedback.builder()
                .note(request.note())
                .comment(request.comment())
                .book(Book.builder()
                        .id(request.bookId())
                        .archived(false) // pas de requirement et il n'y pas des effets juste satisfee loombok
                        .shareable(false)
                        .build()
                )
                .build();
    }

    public Object toFeedbackResponse(Feedback feedback, Integer id) {
        return FeedBackResponse.builder()
                .note(feedback.getNote())
                .comment(feedback.getComment())
                .ownFeedBack(Objects.equals(feedback.getCreateBy(), id))
                .build();
    }
}
