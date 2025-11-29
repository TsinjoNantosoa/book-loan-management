import { Routes } from '@angular/router';
import { LoginComponent } from './pages/auth/login/login.component';
import { RegisterComponent } from './pages/auth/register/register.component';
import { ActivateAccountComponent } from './pages/auth/activate-account/activate-account.component';
import { DashboardComponent } from './pages/dashboard/dashboard/dashboard.component';
import { BookListComponent } from './pages/books/book-list/book-list.component';
import { BookDetailComponent } from './pages/books/book-detail/book-detail.component';
import { MyBooksComponent } from './pages/books/my-books/my-books.component';
import { AddBookComponent } from './pages/books/add-book/add-book.component';
import { authGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'activate-account', component: ActivateAccountComponent },
  { 
    path: 'dashboard', 
    component: DashboardComponent,
    canActivate: [authGuard]
  },
  { 
    path: 'books', 
    component: BookListComponent,
    canActivate: [authGuard]
  },
  { 
    path: 'books/:id', 
    component: BookDetailComponent,
    canActivate: [authGuard]
  },
  { 
    path: 'my-books', 
    component: MyBooksComponent,
    canActivate: [authGuard]
  },
  { 
    path: 'add-book', 
    component: AddBookComponent,
    canActivate: [authGuard]
  },
  { path: '**', redirectTo: '/login' }
];
