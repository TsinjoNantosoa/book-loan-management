import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Book, BookRequest, BorrowedBook, PageResponse } from '../models/book.model';

@Injectable({
  providedIn: 'root'
})
export class BookService {
  private apiUrl = 'http://localhost:8088/api/v1/books';

  constructor(private http: HttpClient) {}

  getAllBooks(page: number = 0, size: number = 10): Observable<PageResponse<Book>> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('size', size.toString());
    return this.http.get<PageResponse<Book>>(this.apiUrl, { params });
  }

  getBookById(id: number): Observable<Book> {
    return this.http.get<Book>(`${this.apiUrl}/${id}`);
  }

  getMyBooks(page: number = 0, size: number = 10): Observable<PageResponse<Book>> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('size', size.toString());
    return this.http.get<PageResponse<Book>>(`${this.apiUrl}/owner`, { params });
  }

  createBook(request: BookRequest): Observable<number> {
    return this.http.post<number>(this.apiUrl, request);
  }

  uploadBookCover(bookId: number, file: File): Observable<void> {
    const formData = new FormData();
    formData.append('file', file);
    return this.http.post<void>(`${this.apiUrl}/cover/${bookId}`, formData);
  }

  toggleShareable(bookId: number): Observable<number> {
    return this.http.patch<number>(`${this.apiUrl}/shareable/${bookId}`, {});
  }

  toggleArchived(bookId: number): Observable<number> {
    return this.http.patch<number>(`${this.apiUrl}/archived/${bookId}`, {});
  }

  borrowBook(bookId: number): Observable<number> {
    return this.http.post<number>(`${this.apiUrl}/borrow/${bookId}`, {});
  }

  returnBook(bookId: number): Observable<number> {
    return this.http.patch<number>(`${this.apiUrl}/borrow/return/${bookId}`, {});
  }

  approveReturn(bookId: number): Observable<number> {
    return this.http.patch<number>(`${this.apiUrl}/borrow/return/approve/${bookId}`, {});
  }

  getBorrowedBooks(page: number = 0, size: number = 10): Observable<PageResponse<BorrowedBook>> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('size', size.toString());
    return this.http.get<PageResponse<BorrowedBook>>(`${this.apiUrl}/borrowed`, { params });
  }

  getReturnedBooks(page: number = 0, size: number = 10): Observable<PageResponse<BorrowedBook>> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('size', size.toString());
    return this.http.get<PageResponse<BorrowedBook>>(`${this.apiUrl}/returned`, { params });
  }
}
