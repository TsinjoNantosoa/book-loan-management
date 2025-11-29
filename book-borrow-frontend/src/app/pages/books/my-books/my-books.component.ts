import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { BookService } from '../../../services/book.service';
import { AuthService } from '../../../services/auth.service';
import { Book } from '../../../models/book.model';

@Component({
  selector: 'app-my-books',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './my-books.component.html',
  styleUrl: './my-books.component.css'
})
export class MyBooksComponent implements OnInit {
  books: Book[] = [];
  loading: boolean = true;

  constructor(
    private bookService: BookService,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.loadMyBooks();
  }

  loadMyBooks(): void {
    this.loading = true;
    this.bookService.getMyBooks(0, 50).subscribe({
      next: (response) => {
        this.books = response.content;
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading books:', error);
        this.loading = false;
      }
    });
  }

  toggleShareable(book: Book): void {
    this.bookService.toggleShareable(book.id).subscribe({
      next: () => {
        book.shareable = !book.shareable;
      },
      error: (error) => {
        alert('Erreur lors de la modification');
        console.error(error);
      }
    });
  }

  toggleArchived(book: Book): void {
    this.bookService.toggleArchived(book.id).subscribe({
      next: () => {
        book.archived = !book.archived;
      },
      error: (error) => {
        alert('Erreur lors de l\'archivage');
        console.error(error);
      }
    });
  }

  uploadCover(bookId: number, event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      this.bookService.uploadBookCover(bookId, file).subscribe({
        next: () => {
          alert('Couverture mise à jour!');
          this.loadMyBooks();
        },
        error: (error) => {
          alert('Erreur lors de l\'upload');
          console.error(error);
        }
      });
    }
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/login']);
  }
}
