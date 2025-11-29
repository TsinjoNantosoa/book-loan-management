package com.tsinjo.book_borrow.email;

public enum EmailTemplate {
 ACTIVATE_ACCOUNT("activate-account");
    private final String name;

    EmailTemplate(String name) {
        this.name = name;
    }

    public String getTemplateName() {
        return name;
    }
}
