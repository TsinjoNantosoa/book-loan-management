package com.tsinjo.book_borrow.book;

import java.util.List;

public class PageResponse<T> {
    private List<T> content;
    private int number;
    private int size;
    private int totalElements;
    private int totalPages;
    private boolean first;
    private boolean last;

    public PageResponse(List<T> content, int number, int size, int totalElements, int totalPages, boolean first, boolean last) {
        this.content = content;
        this.number = number;
        this.size = size;
        this.totalElements = totalElements;
        this.totalPages = totalPages;
        this.first = first;
        this.last = last;
    }
}
