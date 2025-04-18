package com.tsinjo.book_borrow.feedback;

import com.tsinjo.book_borrow.book.Book;
import com.tsinjo.book_borrow.book.BookRepository;
import com.tsinjo.book_borrow.book.PageResponse;
import com.tsinjo.book_borrow.exception.OperationNotPermittedException;
import com.tsinjo.book_borrow.user.User;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class FeedBackService {
    private final BookRepository bookRepository;
    private final FeedBackMapper feedBackMapper;
    private  final FeedBackRepository feedBackRepository;
    public Integer save(FeedBackRequest request, Authentication connectedUser) {
        Book book = bookRepository.findById(request.bookId())
                .orElseThrow(()->new EntityNotFoundException("There is no book with this Id :" + request.bookId() + "please try another id!!"));
        if (book.isArchived() || book.isShareable()) {
            throw new OperationNotPermittedException("The feed back isn't available for you for the  archived or shareable book");
        }
        User user = ((User) connectedUser.getPrincipal());
        if (Objects.equals(book.getOwner().getId(), user.getId())){
            throw  new OperationNotPermittedException("Sorry!!, you can't give a feed back for your own book right !!");
        }
        Feedback feedback = feedBackMapper.toFeedBck(request);
        return feedBackRepository.save(feedback).getId();
    }

    public PageResponse<FeedBackResponse> findAllFeedBackByBook(Integer bookId, int page, int size, Authentication connectedUser) {
        Pageable pageable = PageRequest.of(page, size);
        User user= ((User) connectedUser.getPrincipal());
        Page<Feedback> feedbacks = feedBackRepository.findAllBookById(bookId, pageable);
        List<FeedBackResponse> feedBackResponses = feedbacks.stream()
                .map(f -> (FeedBackResponse) feedBackMapper.toFeedbackResponse(f, user.getId()))
                .toList();
        return new PageResponse<>(
                feedBackResponses,
                feedbacks.getNumber(),
                feedbacks.getSize(),
                (int) feedbacks.getTotalElements(),
                feedbacks.getTotalPages(),
                feedbacks.isFirst(),
                feedbacks.isLast()
        );
    }
}
