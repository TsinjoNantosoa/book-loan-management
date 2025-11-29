#!/bin/bash

echo "🚀 Création de tous les composants frontend..."

# 1. PAGE REGISTER
echo "📝 1. Création de Register..."
cat > src/app/pages/auth/register/register.component.ts << 'EOF'
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { AuthService } from '../../../services/auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './register.component.html',
  styleUrl: './register.component.css'
})
export class RegisterComponent {
  registerForm: FormGroup;
  errorMessage: string = '';
  successMessage: string = '';
  loading: boolean = false;

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {
    this.registerForm = this.fb.group({
      firstname: ['', [Validators.required, Validators.minLength(2)]],
      lastname: ['', [Validators.required, Validators.minLength(2)]],
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(8)]]
    });
  }

  onSubmit(): void {
    if (this.registerForm.valid) {
      this.loading = true;
      this.errorMessage = '';
      this.successMessage = '';
      
      this.authService.register(this.registerForm.value).subscribe({
        next: () => {
          this.loading = false;
          this.successMessage = 'Inscription réussie! Veuillez vérifier votre email pour activer votre compte.';
          setTimeout(() => {
            this.router.navigate(['/activate-account']);
          }, 3000);
        },
        error: (error) => {
          this.loading = false;
          this.errorMessage = 'Erreur lors de l\'inscription. Email peut-être déjà utilisé.';
          console.error('Register error:', error);
        }
      });
    }
  }
}
EOF

cat > src/app/pages/auth/register/register.component.html << 'EOF'
<div class="container-fluid vh-100">
  <div class="row h-100">
    <div class="col-md-6 d-none d-md-flex bg-success align-items-center justify-content-center text-white">
      <div class="text-center">
        <h1 class="display-3 mb-4">📚 Rejoignez-nous!</h1>
        <p class="lead">Créez un compte et commencez à partager vos livres</p>
      </div>
    </div>

    <div class="col-md-6 d-flex align-items-center justify-content-center">
      <div class="w-75" style="max-width: 500px;">
        <h2 class="mb-4">Inscription</h2>
        
        <div *ngIf="successMessage" class="alert alert-success" role="alert">
          {{ successMessage }}
        </div>
        
        <div *ngIf="errorMessage" class="alert alert-danger" role="alert">
          {{ errorMessage }}
        </div>

        <form [formGroup]="registerForm" (ngSubmit)="onSubmit()">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="firstname" class="form-label">Prénom</label>
              <input type="text" class="form-control" id="firstname" formControlName="firstname"
                [class.is-invalid]="registerForm.get('firstname')?.invalid && registerForm.get('firstname')?.touched">
              <div class="invalid-feedback">Prénom requis (min 2 caractères)</div>
            </div>
            <div class="col-md-6 mb-3">
              <label for="lastname" class="form-label">Nom</label>
              <input type="text" class="form-control" id="lastname" formControlName="lastname"
                [class.is-invalid]="registerForm.get('lastname')?.invalid && registerForm.get('lastname')?.touched">
              <div class="invalid-feedback">Nom requis (min 2 caractères)</div>
            </div>
          </div>

          <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" formControlName="email"
              [class.is-invalid]="registerForm.get('email')?.invalid && registerForm.get('email')?.touched">
            <div class="invalid-feedback">Email valide requis</div>
          </div>

          <div class="mb-3">
            <label for="password" class="form-label">Mot de passe</label>
            <input type="password" class="form-control" id="password" formControlName="password"
              [class.is-invalid]="registerForm.get('password')?.invalid && registerForm.get('password')?.touched">
            <div class="invalid-feedback">Mot de passe requis (min 8 caractères)</div>
          </div>

          <button type="submit" class="btn btn-success w-100 mb-3" [disabled]="registerForm.invalid || loading">
            <span *ngIf="loading" class="spinner-border spinner-border-sm me-2"></span>
            {{ loading ? 'Inscription...' : 'S\'inscrire' }}
          </button>
        </form>

        <div class="text-center mt-3">
          <p>Déjà un compte ? <a routerLink="/login" class="text-decoration-none">Se connecter</a></p>
        </div>
      </div>
    </div>
  </div>
</div>
EOF

# 2. PAGE ACTIVATE ACCOUNT
echo "📝 2. Création de Activate Account..."
cat > src/app/pages/auth/activate-account/activate-account.component.ts << 'EOF'
import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router, RouterModule, ActivatedRoute } from '@angular/router';
import { AuthService } from '../../../services/auth.service';

@Component({
  selector: 'app-activate-account',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './activate-account.component.html',
  styleUrl: './activate-account.component.css'
})
export class ActivateAccountComponent implements OnInit {
  activateForm: FormGroup;
  errorMessage: string = '';
  successMessage: string = '';
  loading: boolean = false;

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router,
    private route: ActivatedRoute
  ) {
    this.activateForm = this.fb.group({
      token: ['', [Validators.required, Validators.pattern(/^\d{6}$/)]]
    });
  }

  ngOnInit(): void {
    // Vérifier si un token est passé en paramètre
    this.route.queryParams.subscribe(params => {
      if (params['token']) {
        this.activateForm.patchValue({ token: params['token'] });
        this.onSubmit();
      }
    });
  }

  onSubmit(): void {
    if (this.activateForm.valid) {
      this.loading = true;
      this.errorMessage = '';
      this.successMessage = '';
      
      const token = this.activateForm.value.token;
      
      this.authService.activateAccount(token).subscribe({
        next: () => {
          this.loading = false;
          this.successMessage = 'Compte activé avec succès! Redirection vers la page de connexion...';
          setTimeout(() => {
            this.router.navigate(['/login']);
          }, 2000);
        },
        error: (error) => {
          this.loading = false;
          this.errorMessage = 'Token invalide ou expiré. Veuillez vérifier votre email.';
          console.error('Activation error:', error);
        }
      });
    }
  }
}
EOF

cat > src/app/pages/auth/activate-account/activate-account.component.html << 'EOF'
<div class="container-fluid vh-100">
  <div class="row h-100 align-items-center justify-content-center">
    <div class="col-md-5">
      <div class="card shadow">
        <div class="card-body p-5">
          <div class="text-center mb-4">
            <h2>🔐 Activation du compte</h2>
            <p class="text-muted">Entrez le code reçu par email</p>
          </div>
          
          <div *ngIf="successMessage" class="alert alert-success" role="alert">
            {{ successMessage }}
          </div>
          
          <div *ngIf="errorMessage" class="alert alert-danger" role="alert">
            {{ errorMessage }}
          </div>

          <form [formGroup]="activateForm" (ngSubmit)="onSubmit()">
            <div class="mb-3">
              <label for="token" class="form-label">Code d'activation (6 chiffres)</label>
              <input type="text" class="form-control form-control-lg text-center" id="token" 
                formControlName="token" placeholder="000000" maxlength="6"
                [class.is-invalid]="activateForm.get('token')?.invalid && activateForm.get('token')?.touched">
              <div class="invalid-feedback">Code à 6 chiffres requis</div>
            </div>

            <button type="submit" class="btn btn-primary w-100 btn-lg mb-3" 
              [disabled]="activateForm.invalid || loading">
              <span *ngIf="loading" class="spinner-border spinner-border-sm me-2"></span>
              {{ loading ? 'Activation...' : 'Activer mon compte' }}
            </button>
          </form>

          <div class="text-center">
            <a routerLink="/login" class="text-decoration-none">Retour à la connexion</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
EOF

echo "✅ Tous les composants d'authentification créés!"

# 3. PAGE BOOK LIST
echo "📝 3. Création de Book List..."
cat > src/app/pages/books/book-list/book-list.component.ts << 'EOF'
import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { BookService } from '../../../services/book.service';
import { AuthService } from '../../../services/auth.service';
import { Book } from '../../../models/book.model';

@Component({
  selector: 'app-book-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './book-list.component.html',
  styleUrl: './book-list.component.css'
})
export class BookListComponent implements OnInit {
  books: Book[] = [];
  loading: boolean = true;
  currentPage: number = 0;
  totalPages: number = 0;
  pageSize: number = 12;

  constructor(
    private bookService: BookService,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.loadBooks();
  }

  loadBooks(): void {
    this.loading = true;
    this.bookService.getAllBooks(this.currentPage, this.pageSize).subscribe({
      next: (response) => {
        this.books = response.content;
        this.totalPages = response.totalPages;
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading books:', error);
        this.loading = false;
      }
    });
  }

  borrowBook(bookId: number): void {
    this.bookService.borrowBook(bookId).subscribe({
      next: () => {
        alert('Livre emprunté avec succès!');
        this.loadBooks();
      },
      error: (error) => {
        alert('Erreur lors de l\'emprunt');
        console.error(error);
      }
    });
  }

  nextPage(): void {
    if (this.currentPage < this.totalPages - 1) {
      this.currentPage++;
      this.loadBooks();
    }
  }

  previousPage(): void {
    if (this.currentPage > 0) {
      this.currentPage--;
      this.loadBooks();
    }
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/login']);
  }
}
EOF

cat > src/app/pages/books/book-list/book-list.component.html << 'EOF'
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" routerLink="/dashboard">📚 Book Borrow</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item"><a class="nav-link" routerLink="/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link active" routerLink="/books">Tous les livres</a></li>
        <li class="nav-item"><a class="nav-link" routerLink="/my-books">Mes livres</a></li>
        <li class="nav-item"><a class="nav-link" routerLink="/add-book">Ajouter un livre</a></li>
      </ul>
      <button class="btn btn-outline-light" (click)="logout()">Déconnexion</button>
    </div>
  </div>
</nav>

<div class="container py-4">
  <h2 class="mb-4">📚 Tous les livres disponibles</h2>

  <div *ngIf="loading" class="text-center py-5">
    <div class="spinner-border text-primary" role="status"></div>
  </div>

  <div *ngIf="!loading && books.length === 0" class="text-center py-5">
    <p class="text-muted">Aucun livre disponible</p>
  </div>

  <div class="row" *ngIf="!loading && books.length > 0">
    <div class="col-md-3 mb-4" *ngFor="let book of books">
      <div class="card h-100">
        <div class="card-body">
          <h5 class="card-title">{{ book.title }}</h5>
          <p class="card-text text-muted">{{ book.authorName }}</p>
          <p class="small text-muted">ISBN: {{ book.isbn }}</p>
          <span class="badge" [class.bg-success]="book.shareable" [class.bg-secondary]="!book.shareable">
            {{ book.shareable ? 'Partageable' : 'Non partageable' }}
          </span>
        </div>
        <div class="card-footer bg-white">
          <button class="btn btn-sm btn-outline-primary me-2" [routerLink]="['/books', book.id]">Détails</button>
          <button *ngIf="book.shareable" class="btn btn-sm btn-primary" (click)="borrowBook(book.id)">Emprunter</button>
        </div>
      </div>
    </div>
  </div>

  <nav *ngIf="totalPages > 1" class="mt-4">
    <ul class="pagination justify-content-center">
      <li class="page-item" [class.disabled]="currentPage === 0">
        <button class="page-link" (click)="previousPage()">Précédent</button>
      </li>
      <li class="page-item disabled">
        <span class="page-link">Page {{ currentPage + 1 }} / {{ totalPages }}</span>
      </li>
      <li class="page-item" [class.disabled]="currentPage >= totalPages - 1">
        <button class="page-link" (click)="nextPage()">Suivant</button>
      </li>
    </ul>
  </nav>
</div>
EOF

echo "✅ Book List créé!"
echo "🎉 TERMINÉ! Tous les composants principaux sont créés."

