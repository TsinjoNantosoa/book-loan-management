#!/bin/bash

echo "📝 4. Création de Book Detail..."
cat > src/app/pages/books/book-detail/book-detail.component.ts << 'EOF'
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
EOF

cat > src/app/pages/books/book-detail/book-detail.component.html << 'EOF'
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" routerLink="/dashboard">📚 Book Borrow</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item"><a class="nav-link" routerLink="/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" routerLink="/books">Tous les livres</a></li>
        <li class="nav-item"><a class="nav-link" routerLink="/my-books">Mes livres</a></li>
      </ul>
      <button class="btn btn-outline-light" (click)="logout()">Déconnexion</button>
    </div>
  </div>
</nav>

<div class="container py-4">
  <button class="btn btn-outline-primary mb-3" routerLink="/books">← Retour</button>

  <div *ngIf="loading" class="text-center py-5">
    <div class="spinner-border text-primary" role="status"></div>
  </div>

  <div *ngIf="!loading && book" class="row">
    <div class="col-md-8">
      <div class="card">
        <div class="card-body">
          <h2 class="card-title">{{ book.title }}</h2>
          <p class="text-muted">Par {{ book.authorName }}</p>
          <hr>
          <p><strong>ISBN:</strong> {{ book.isbn }}</p>
          <p><strong>Propriétaire:</strong> {{ book.owner }}</p>
          <p><strong>Synopsis:</strong> {{ book.synopsis || 'Aucun synopsis disponible' }}</p>
          <div class="mt-3">
            <span class="badge me-2" [class.bg-success]="book.shareable" [class.bg-secondary]="!book.shareable">
              {{ book.shareable ? 'Partageable' : 'Non partageable' }}
            </span>
            <span class="badge bg-info">Note: {{ book.rate || 0 }}/5</span>
          </div>
          <button *ngIf="book.shareable" class="btn btn-primary mt-3" (click)="borrowBook()">
            📖 Emprunter ce livre
          </button>
        </div>
      </div>

      <div class="card mt-4">
        <div class="card-header">
          <h5 class="mb-0">💬 Commentaires ({{ feedbacks.length }})</h5>
        </div>
        <div class="card-body">
          <button class="btn btn-sm btn-success mb-3" (click)="showFeedbackForm = !showFeedbackForm">
            {{ showFeedbackForm ? 'Annuler' : '+ Ajouter un commentaire' }}
          </button>

          <div *ngIf="showFeedbackForm" class="mb-4 p-3 border rounded">
            <h6>Votre avis</h6>
            <div class="mb-3">
              <label class="form-label">Note</label>
              <select class="form-select" [(ngModel)]="newFeedback.note">
                <option [value]="1">1 - Très mauvais</option>
                <option [value]="2">2 - Mauvais</option>
                <option [value]="3">3 - Moyen</option>
                <option [value]="4">4 - Bon</option>
                <option [value]="5">5 - Excellent</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label">Commentaire</label>
              <textarea class="form-control" rows="3" [(ngModel)]="newFeedback.comment"></textarea>
            </div>
            <button class="btn btn-primary" (click)="submitFeedback()">Publier</button>
          </div>

          <div *ngIf="feedbacks.length === 0 && !showFeedbackForm" class="text-muted">
            Aucun commentaire pour le moment. Soyez le premier à donner votre avis!
          </div>

          <div *ngFor="let feedback of feedbacks" class="border-bottom pb-3 mb-3">
            <div class="d-flex justify-content-between">
              <strong>Note: {{ feedback.note }}/5 ⭐</strong>
              <small class="text-muted">{{ feedback.createdDate | date }}</small>
            </div>
            <p class="mb-0 mt-2">{{ feedback.comment }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
EOF

echo "✅ Book Detail créé!"

# 5. MY BOOKS
echo "📝 5. Création de My Books..."
cat > src/app/pages/books/my-books/my-books.component.ts << 'EOF'
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
EOF

cat > src/app/pages/books/my-books/my-books.component.html << 'EOF'
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" routerLink="/dashboard">📚 Book Borrow</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item"><a class="nav-link" routerLink="/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" routerLink="/books">Tous les livres</a></li>
        <li class="nav-item"><a class="nav-link active" routerLink="/my-books">Mes livres</a></li>
        <li class="nav-item"><a class="nav-link" routerLink="/add-book">Ajouter un livre</a></li>
      </ul>
      <button class="btn btn-outline-light" (click)="logout()">Déconnexion</button>
    </div>
  </div>
</nav>

<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2>📚 Mes livres</h2>
    <button class="btn btn-success" routerLink="/add-book">+ Ajouter un livre</button>
  </div>

  <div *ngIf="loading" class="text-center py-5">
    <div class="spinner-border text-primary" role="status"></div>
  </div>

  <div *ngIf="!loading && books.length === 0" class="text-center py-5">
    <p class="text-muted">Vous n'avez pas encore ajouté de livres</p>
    <button class="btn btn-primary" routerLink="/add-book">Ajouter mon premier livre</button>
  </div>

  <div class="row" *ngIf="!loading && books.length > 0">
    <div class="col-md-4 mb-4" *ngFor="let book of books">
      <div class="card h-100">
        <div class="card-body">
          <h5 class="card-title">{{ book.title }}</h5>
          <p class="card-text text-muted">{{ book.authorName }}</p>
          <p class="small text-muted">ISBN: {{ book.isbn }}</p>
          <div class="mb-2">
            <span class="badge me-1" [class.bg-success]="book.shareable" [class.bg-secondary]="!book.shareable">
              {{ book.shareable ? 'Partageable' : 'Non partageable' }}
            </span>
            <span class="badge" [class.bg-warning]="book.archived" [class.bg-info]="!book.archived">
              {{ book.archived ? 'Archivé' : 'Actif' }}
            </span>
          </div>
        </div>
        <div class="card-footer bg-white">
          <div class="btn-group w-100 mb-2">
            <button class="btn btn-sm btn-outline-primary" (click)="toggleShareable(book)">
              {{ book.shareable ? '🔒 Rendre privé' : '🌐 Rendre public' }}
            </button>
            <button class="btn btn-sm btn-outline-secondary" (click)="toggleArchived(book)">
              {{ book.archived ? '📂 Désarchiver' : '📥 Archiver' }}
            </button>
          </div>
          <label class="btn btn-sm btn-outline-success w-100">
            📷 Changer couverture
            <input type="file" accept="image/*" style="display: none;" (change)="uploadCover(book.id, $event)">
          </label>
        </div>
      </div>
    </div>
  </div>
</div>
EOF

echo "✅ My Books créé!"

# 6. ADD BOOK
echo "📝 6. Création de Add Book..."
cat > src/app/pages/books/add-book/add-book.component.ts << 'EOF'
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { BookService } from '../../../services/book.service';
import { AuthService } from '../../../services/auth.service';
import { BookRequest } from '../../../models/book.model';

@Component({
  selector: 'app-add-book',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './add-book.component.html',
  styleUrl: './add-book.component.css'
})
export class AddBookComponent {
  bookForm: FormGroup;
  loading: boolean = false;
  errorMessage: string = '';
  selectedFile: File | null = null;

  constructor(
    private fb: FormBuilder,
    private bookService: BookService,
    private authService: AuthService,
    private router: Router
  ) {
    this.bookForm = this.fb.group({
      title: ['', [Validators.required, Validators.minLength(3)]],
      authorName: ['', [Validators.required, Validators.minLength(3)]],
      isbn: ['', [Validators.required]],
      synopsis: ['', [Validators.required, Validators.minLength(10)]],
      shareable: [true]
    });
  }

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      this.selectedFile = input.files[0];
    }
  }

  onSubmit(): void {
    if (this.bookForm.valid) {
      this.loading = true;
      this.errorMessage = '';

      const bookRequest: BookRequest = this.bookForm.value;

      this.bookService.createBook(bookRequest).subscribe({
        next: (bookId) => {
          if (this.selectedFile) {
            this.bookService.uploadBookCover(bookId, this.selectedFile).subscribe({
              next: () => {
                alert('Livre créé avec succès!');
                this.router.navigate(['/my-books']);
              },
              error: () => {
                alert('Livre créé mais erreur lors de l\'upload de la couverture');
                this.router.navigate(['/my-books']);
              }
            });
          } else {
            alert('Livre créé avec succès!');
            this.router.navigate(['/my-books']);
          }
        },
        error: (error) => {
          this.loading = false;
          this.errorMessage = 'Erreur lors de la création du livre';
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
EOF

cat > src/app/pages/books/add-book/add-book.component.html << 'EOF'
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" routerLink="/dashboard">📚 Book Borrow</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item"><a class="nav-link" routerLink="/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" routerLink="/books">Tous les livres</a></li>
        <li class="nav-item"><a class="nav-link" routerLink="/my-books">Mes livres</a></li>
        <li class="nav-item"><a class="nav-link active" routerLink="/add-book">Ajouter un livre</a></li>
      </ul>
      <button class="btn btn-outline-light" (click)="logout()">Déconnexion</button>
    </div>
  </div>
</nav>

<div class="container py-4">
  <div class="row justify-content-center">
    <div class="col-md-8">
      <div class="card">
        <div class="card-body">
          <h2 class="card-title mb-4">📚 Ajouter un nouveau livre</h2>

          <div *ngIf="errorMessage" class="alert alert-danger" role="alert">
            {{ errorMessage }}
          </div>

          <form [formGroup]="bookForm" (ngSubmit)="onSubmit()">
            <div class="mb-3">
              <label for="title" class="form-label">Titre du livre *</label>
              <input type="text" class="form-control" id="title" formControlName="title"
                [class.is-invalid]="bookForm.get('title')?.invalid && bookForm.get('title')?.touched">
              <div class="invalid-feedback">Titre requis (min 3 caractères)</div>
            </div>

            <div class="mb-3">
              <label for="authorName" class="form-label">Auteur *</label>
              <input type="text" class="form-control" id="authorName" formControlName="authorName"
                [class.is-invalid]="bookForm.get('authorName')?.invalid && bookForm.get('authorName')?.touched">
              <div class="invalid-feedback">Nom de l'auteur requis (min 3 caractères)</div>
            </div>

            <div class="mb-3">
              <label for="isbn" class="form-label">ISBN *</label>
              <input type="text" class="form-control" id="isbn" formControlName="isbn"
                [class.is-invalid]="bookForm.get('isbn')?.invalid && bookForm.get('isbn')?.touched">
              <div class="invalid-feedback">ISBN requis</div>
            </div>

            <div class="mb-3">
              <label for="synopsis" class="form-label">Synopsis *</label>
              <textarea class="form-control" id="synopsis" rows="5" formControlName="synopsis"
                [class.is-invalid]="bookForm.get('synopsis')?.invalid && bookForm.get('synopsis')?.touched"></textarea>
              <div class="invalid-feedback">Synopsis requis (min 10 caractères)</div>
            </div>

            <div class="mb-3 form-check">
              <input type="checkbox" class="form-check-input" id="shareable" formControlName="shareable">
              <label class="form-check-label" for="shareable">
                Rendre ce livre partageable avec les autres utilisateurs
              </label>
            </div>

            <div class="mb-3">
              <label for="cover" class="form-label">Couverture du livre (optionnel)</label>
              <input type="file" class="form-control" id="cover" accept="image/*" (change)="onFileSelected($event)">
              <small class="text-muted">Format: JPG, PNG (max 5MB)</small>
            </div>

            <div class="d-flex justify-content-between">
              <button type="button" class="btn btn-outline-secondary" routerLink="/my-books">Annuler</button>
              <button type="submit" class="btn btn-success" [disabled]="bookForm.invalid || loading">
                <span *ngIf="loading" class="spinner-border spinner-border-sm me-2"></span>
                {{ loading ? 'Création...' : '✅ Créer le livre' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
EOF

echo "✅ Add Book créé!"
echo ""
echo "🎉 TOUS LES COMPOSANTS SONT CRÉÉS!"
echo ""
echo "Liste des composants créés:"
echo "1. ✅ Register (Inscription)"
echo "2. ✅ Activate Account (Activation de compte)"
echo "3. ✅ Book List (Liste de tous les livres)"
echo "4. ✅ Book Detail (Détails d'un livre + commentaires)"
echo "5. ✅ My Books (Gestion de mes livres)"
echo "6. ✅ Add Book (Ajouter un livre)"
echo ""
echo "Frontend est maintenant COMPLET avec tous les endpoints backend implémentés!"

