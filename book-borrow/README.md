# Book Loan Management API

[![Java CI with Maven](https://github.com/TsinjoNantosoa/book-loan-management/actions/workflows/maven.yml/badge.svg)](https://github.com/TsinjoNantosoa/book-loan-management/actions/workflows/maven.yml)

## Screenshots

*(Add your screenshots here after placing them in the repository, e.g., in a `docs/images` folder)*

```markdown
![Swagger UI Overview](docs/images/swagger_overview.png)

![Swagger UI Schemas](docs/images/swagger_schemas.png)
```

## Description

This project is a Spring Boot REST API backend for managing a book borrowing system. It allows users to register, log in, manage their books, share them, borrow books from others, return them, and provide feedback.

## Features

*   **User Management:** Registration, Activation, Authentication (JWT).
*   **Book Management:** Add, list, view details, update shareable/archived status.
*   **Book Covers:** Upload book cover images.
*   **Borrowing System:** Borrow books, return borrowed books, approve returns.
*   **Feedback:** Leave ratings and comments for borrowed books.
*   **API Documentation:** OpenAPI (Swagger) documentation for all endpoints.

## Technologies Used

*   **Java:** 21
*   **Spring Boot:** 3.3.4
*   **Spring Security:** 6.x (JWT Authentication)
*   **Spring Data JPA:** Database interaction
*   **PostgreSQL:** Relational Database
*   **Maven:** Build Tool
*   **Lombok:** Boilerplate code reduction
*   **SpringDoc OpenAPI (Swagger):** API Documentation
*   **Thymeleaf:** Email templating (for activation emails)
*   **JJwt:** JWT token handling

## Prerequisites

Before you begin, ensure you have met the following requirements:

*   **Java JDK 21** or later installed.
*   **Maven** installed.
*   **PostgreSQL** database server installed and running.
*   **(Optional) MailDev** or another SMTP server for testing email sending (MailDev is configured by default in `application-dev.yml`). You can get MailDev via Docker: `docker run -p 1080:1080 -p 1025:1025 maildev/maildev`

## Getting Started

Follow these steps to get the project up and running locally:

### 1. Clone the Repository

```bash
git clone https://github.com/TsinjoNantosoa/book-loan-management.git
cd book-loan-management
```

### 2. Database Setup

*   Ensure your PostgreSQL server is running.
*   Create a database user and a database. The default development configuration (`application-dev.yml`) uses:
    *   Database Name: `bookdb`
    *   Username: `tsinjo`
    *   Password: `nantosoa`
*   You can create these using `psql` or a database management tool:
    ```sql
    -- Example using psql
    CREATE USER tsinjo WITH PASSWORD 'nantosoa';
    CREATE DATABASE bookdb OWNER tsinjo;
    ```
*   If you use different credentials or database name, update the `spring.datasource` properties in `src/main/resources/application-dev.yml`.

### 3. Configuration

The main configuration is done via YAML files in `src/main/resources/`:

*   `application.yml`: Base configuration, sets the active profile to `dev`.
*   `application-dev.yml`: Development-specific configurations (datasource, mail server, JWT secret, etc.).

**Important configurations in `application-dev.yml`:**

*   **Datasource:**
    ```yaml
    spring:
      datasource:
        url: jdbc:postgresql://localhost:5432/bookdb # Adjust host/port/db if needed
        username: tsinjo
        password: nantosoa
    ```
*   **JWT Secret Key:**
    ```yaml
    application:
      security:
        jwt:
          secret-key: //jOUAXkClvCrd4iFrqA4Noi/8wOTpLXTuPdoow0Fngr253NM2V51DiI0c2Afns7KUCtLqbuPCSFJGuOk0tPKw== # Replace with a strong, Base64 encoded key for production!
          expiration: 86400000 # Token expiration time in ms (default: 24 hours)
    ```
    **Note:** Generate a strong, secure Base64 encoded key (min 32 bytes) for production environments using `openssl rand -base64 32` or `openssl rand -base64 64`.
*   **Mail Server (for Development with MailDev):**
    ```yaml
    spring:
      mail:
        host: localhost
        port: 1025 # Default MailDev SMTP port
        username: tsinjo # Not required by MailDev
        password: nantosoa # Not required by MailDev
        properties:
          mail:
            smtp:
              trust: "*"
              auth: true # Should likely be false for MailDev if no auth needed
              starttls:
                enable: true # Should likely be false for MailDev
    ```
    Adjust `auth` and `starttls.enable` based on your MailDev setup (often `false`).
*   **File Upload Path:**
    ```yaml
    application:
      file:
        upload:
          photos-output-path: ./uploads # Directory where uploaded book covers are stored relative to the running application
    ```
    Ensure this directory exists or the application has permissions to create it.

### 4. Build the Project

Use Maven to compile the code and package it into an executable JAR:

```bash
mvn clean package -U
```

### 5. Run the Application

Execute the generated JAR file:

```bash
java -jar target/book-borrow-0.0.1-SNAPSHOT.jar
```

The application will start, usually on port `8080`. You should see Spring Boot logs in the console.

## API Documentation (Swagger UI)

Once the application is running, you can access the interactive API documentation (Swagger UI) in your browser:

**URL:** [http://localhost:8080/api/v1/swagger-ui.html](http://localhost:8080/api/v1/swagger-ui.html)

*(Note: The base path `/api/v1` is configured in `application.yml`)*

## API Endpoints Overview

The API provides endpoints for:

*   **Authentication (`/api/v1/auth`):** User registration, login, account activation.
*   **Books (`/api/v1/books`):** CRUD operations for books, managing sharing/archiving, borrowing, returning, approving returns, uploading covers.
*   **Feedbacks (`/api/v1/feedbacks`):** Adding and retrieving feedback for books.

Refer to the Swagger UI for detailed information about each endpoint, request/response models, and parameters.

## Security

*   Most endpoints require authentication via JWT (JSON Web Tokens).
*   Obtain a token by calling the `/api/v1/auth/authenticate` endpoint with valid user credentials.
*   Include the obtained token in the `Authorization` header for subsequent requests:
    `Authorization: Bearer <YOUR_JWT_TOKEN>`
*   Swagger UI provides an "Authorize" button to easily set the token for testing.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.


## Contact

**Author:** TsinjoNantosoa
*   **GitHub:** [https://github.com/TsinjoNantosoa](https://github.com/TsinjoNantosoa)
*   **Email:** (tsinjonantosoa@gmail.com) 