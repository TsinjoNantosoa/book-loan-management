import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { BookService } from '../../../services/book.service';
import { FeedbackService } from '../../../services/feedback.service';
import { AuthService } from '../../../services/auth.service';
import { Book } from '../../../models/book.model';
import { Feedback, FeedbackRequest } from '../../../models/feedback.model';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-book-detail',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './book-detail.component.html',
  styleUrl: './book-detail.component.css'
})
export class BookDetailComponent implements OnInit {
  book: Book | null = null;
  feedbacks: Feedback[] = [];
  loading: boolean = true;
  newFeedback: FeedbackRequest = { bookId: 0, note: 5, comment: '' };
  showFeedbackForm: boolean = false;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private bookService: BookService,
    private feedbackService: FeedbackService,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    const bookId = Number(this.route.snapshot.paramMap.get('id'));
    this.loadBook(bookId);
    this.loadFeedbacks(bookId);
    this.newFeedback.bookId = bookId;
  }

  loadBook(bookId: number): void {
    this.bookService.getBookById(bookId).subscribe({
      next: (book) => {
        this.book = book;
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading book:', error);
        this.loading = false;
      }
    });
  }

  loadFeedbacks(bookId: number): void {
    this.feedbackService.getBookFeedbacks(bookId, 0, 20).subscribe({
      next: (response) => {
        this.feedbacks = response.content;
      },
      error: (error) => {
        console.error('Error loading feedbacks:', error);
      }
    });
  }

  borrowBook(): void {
    if (this.book) {
      this.bookService.borrowBook(this.book.id).subscribe({
        next: () => {
          alert('Livre emprunté avec succès!');
          this.router.navigate(['/dashboard']);
        },
        error: (error) => {
          alert('Erreur lors de l\'emprunt');
          console.error(error);
        }
      });
    }
  }

  submitFeedback(): void {
    this.feedbackService.createFeedback(this.newFeedback).subscribe({
      next: () => {
        alert('Feedback ajouté avec succès!');
        this.showFeedbackForm = false;
        this.newFeedback = { bookId: this.book!.id, note: 5, comment: '' };
        this.loadFeedbacks(this.book!.id);
      },
      error: (error) => {
        alert('Erreur lors de l\'ajout du feedback');
        console.error(error);
      }
    });
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/login']);
  }
}
