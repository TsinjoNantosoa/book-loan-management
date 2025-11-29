export interface Feedback {
  id: number;
  note: number;
  comment: string;
  ownFeedback: boolean;
  createdDate?: Date | string;
}

export interface FeedbackRequest {
  note: number;
  comment: string;
  bookId: number;
}
