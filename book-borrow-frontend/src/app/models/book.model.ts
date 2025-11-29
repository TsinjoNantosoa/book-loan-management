export interface Book {
  id: number;
  title: string;
  authorName: string;
  isbn: string;
  synopsis: string;
  bookCover?: string;
  shareable: boolean;
  archived: boolean;
  owner: string;
  rate: number;
}

export interface BookRequest {
  title: string;
  authorName: string;
  isbn: string;
  synopsis: string;
  shareable: boolean;
}

export interface BorrowedBook {
  id: number;
  title: string;
  authorName: string;
  isbn: string;
  rate: number;
  returned: boolean;
  returnApproved: boolean;
}

export interface PageResponse<T> {
  content: T[];
  number: number;
  size: number;
  totalElements: number;
  totalPages: number;
  first: boolean;
  last: boolean;
}
