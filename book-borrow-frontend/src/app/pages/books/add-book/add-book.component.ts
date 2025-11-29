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
