package com.tsinjo.book_borrow.authentication;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;

public class AuthenticationRequest {
    @Email(message = "the email is not formated")
    @NotEmpty(message = "email is mandatory")
    @NotBlank(message = "the email is not blank")
    private String email;

    @Size(min = 8, message = "the password should compose at least 8 characters.")
    @NotEmpty(message = "password is mandatory")
    @NotBlank(message = "the password is not blank")
    private String password;

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }




}
