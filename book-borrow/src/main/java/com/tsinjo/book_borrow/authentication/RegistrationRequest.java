package com.tsinjo.book_borrow.authentication;

import jakarta.persistence.Column;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class RegistrationRequest {

    @NotEmpty(message = "FirstName is mandatory")
    @NotBlank(message = "the FirstName is not blank")
    private String firstname;

    @NotEmpty(message = "lastname is mandatory")
    @NotBlank(message = "the lastname is not blank")
    private String lastname;

    @Email(message = "the email is not formated")
    @NotEmpty(message = "email is mandatory")
    @NotBlank(message = "the email is not blank")
    private String email;

    public RegistrationRequest(String firstname, String lastname, String email, String password) {
        this.firstname = firstname;
        this.lastname = lastname;
        this.email = email;
        this.password = password;
    }

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

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

}
