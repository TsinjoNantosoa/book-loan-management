import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { BookService } from '../../../services/book.service';
import { AuthService } from '../../../services/auth.service';
import { Book, BorrowedBook } from '../../../models/book.model';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class DashboardComponent implements OnInit {
  totalBooks: number = 0;
  myBooksCount: number = 0;
  borrowedBooksCount: number = 0;
  recentBooks: Book[] = [];
  myBorrowedBooks: BorrowedBook[] = [];
  loading: boolean = true;

  constructor(
    private bookService: BookService,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.loadDashboardData();
  }

  loadDashboardData(): void {
    this.loading = true;

    // Charger tous les livres
    this.bookService.getAllBooks(0, 4).subscribe({
      next: (response) => {
        this.totalBooks = response.totalElements;
        this.recentBooks = response.content;
      },
      error: (error) => console.error('Error loading books:', error)
    });

    // Charger mes livres
    this.bookService.getMyBooks(0, 1).subscribe({
      next: (response) => {
        this.myBooksCount = response.totalElements;
      },
      error: (error) => console.error('Error loading my books:', error)
    });

    // Charger mes emprunts
    this.bookService.getBorrowedBooks(0, 3).subscribe({
      next: (response) => {
        this.borrowedBooksCount = response.totalElements;
        this.myBorrowedBooks = response.content;
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading borrowed books:', error);
        this.loading = false;
      }
    });
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/login']);
  }

  borrowBook(bookId: number): void {
    this.bookService.borrowBook(bookId).subscribe({
      next: () => {
        alert('Livre emprunté avec succès!');
        this.loadDashboardData();
      },
      error: (error) => {
        alert('Erreur lors de l\'emprunt du livre');
        console.error(error);
      }
    });
  }

  returnBook(bookId: number): void {
    this.bookService.returnBook(bookId).subscribe({
      next: () => {
        alert('Livre retourné avec succès! En attente d\'approbation.');
        this.loadDashboardData();
      },
      error: (error) => {
        alert('Erreur lors du retour du livre');
        console.error(error);
      }
    });
  }
}
