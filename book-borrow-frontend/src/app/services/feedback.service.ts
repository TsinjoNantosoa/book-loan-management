import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Feedback, FeedbackRequest } from '../models/feedback.model';
import { PageResponse } from '../models/book.model';

@Injectable({
  providedIn: 'root'
})
export class FeedbackService {
  private apiUrl = 'http://localhost:8088/api/v1/feedbacks';

  constructor(private http: HttpClient) {}

  createFeedback(request: FeedbackRequest): Observable<number> {
    return this.http.post<number>(this.apiUrl, request);
  }

  getBookFeedbacks(bookId: number, page: number = 0, size: number = 10): Observable<PageResponse<Feedback>> {
    const params = new HttpParams()
      .set('page', page.toString())
      .set('size', size.toString());
    return this.http.get<PageResponse<Feedback>>(`${this.apiUrl}/book/${bookId}`, { params });
  }
}
