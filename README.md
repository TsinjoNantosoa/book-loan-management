# 📚 Book Loan Management System

> Système complet de gestion de prêt de livres avec authentification JWT, partage de livres entre utilisateurs, système d'emprunt/retour et feedbacks.

[![Java](https://img.shields.io/badge/Java-21-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3.4-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Angular](https://img.shields.io/badge/Angular-19-red.svg)](https://angular.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 📋 Table des matières

- [Aperçu du projet](#-aperçu-du-projet)
- [Fonctionnalités](#-fonctionnalités)
- [Architecture](#-architecture)
- [Technologies](#-technologies)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Démarrage rapide](#-démarrage-rapide)
- [Configuration](#-configuration)
- [API Endpoints](#-api-endpoints)
- [Tests](#-tests)
- [Captures d'écran](#-captures-décran)
- [Contribution](#-contribution)
- [Licence](#-licence)

## 🎯 Aperçu du projet

Book Loan Management est une application full-stack permettant aux utilisateurs de :
- 📖 Gérer leur bibliothèque personnelle de livres
- 🤝 Partager leurs livres avec d'autres utilisateurs
- 📥 Emprunter des livres disponibles
- ✅ Retourner les livres empruntés avec validation du propriétaire
- ⭐ Laisser des feedbacks et notes sur les livres
- 📧 Recevoir des notifications par email

### Stack technique :
- **Backend** : Spring Boot 3.3.4 + PostgreSQL 15
- **Frontend** : Angular 19 + Bootstrap 5
- **Infrastructure** : Docker (MailDev), Maven, npm

## ✨ Fonctionnalités

### 🔐 Authentification & Sécurité
- ✅ Inscription avec validation par email
- ✅ Authentification JWT (JSON Web Token)
- ✅ Activation de compte via code à 6 chiffres
- ✅ Protection des routes avec guards Angular
- ✅ Intercepteur HTTP pour injection automatique du token

### 📚 Gestion des livres
- ✅ CRUD complet (Créer, Lire, Modifier, Supprimer)
- ✅ Upload de couverture de livre (images)
- ✅ Basculer le statut partageable/privé
- ✅ Archiver/Désarchiver des livres
- ✅ Pagination sur toutes les listes
- ✅ Filtrage par propriétaire

### 🔄 Système d'emprunt
- ✅ Emprunter un livre disponible
- ✅ Retourner un livre emprunté
- ✅ Validation du retour par le propriétaire
- ✅ Historique des emprunts (actifs, retournés)
- ✅ Prévention des emprunts multiples

### 💬 Feedbacks & Notes
- ✅ Système de notation (1-5 étoiles)
- ✅ Commentaires détaillés
- ✅ Affichage des feedbacks avec dates
- ✅ Calcul de la note moyenne par livre

### 🎨 Interface utilisateur
- ✅ Dashboard avec statistiques
- ✅ Navigation intuitive
- ✅ Design responsive (Bootstrap 5)
- ✅ Composants réutilisables
- ✅ Gestion d'erreurs avec messages clairs

## 🏗 Architecture

```
book-loan-management/
├── book-borrow/                    # Backend Spring Boot
│   ├── src/main/java/
│   │   └── com/tsinjo/book_borrow/
│   │       ├── auth/               # Authentification (register, login, activate)
│   │       ├── book/               # Gestion des livres
│   │       ├── feedback/           # Système de feedbacks
│   │       ├── history/            # Historique des emprunts
│   │       ├── security/           # Configuration JWT
│   │       └── config/             # Configuration Spring
│   ├── src/main/resources/
│   │   ├── application.yml         # Config principale
│   │   ├── application-dev.yml     # Config développement
│   │   └── templates/              # Templates email (Thymeleaf)
│   ├── pom.xml                     # Dépendances Maven
│   └── docker-compose.yml          # MailDev container
│
├── book-borrow-frontend/           # Frontend Angular
│   ├── src/app/
│   │   ├── guards/                 # Auth guard
│   │   ├── interceptors/           # JWT interceptor
│   │   ├── models/                 # Interfaces TypeScript
│   │   ├── services/               # Services HTTP
│   │   │   ├── auth.service.ts     # 3 endpoints auth
│   │   │   ├── book.service.ts     # 11 endpoints books
│   │   │   └── feedback.service.ts # 2 endpoints feedbacks
│   │   └── pages/
│   │       ├── auth/               # Login, Register, Activate
│   │       ├── dashboard/          # Tableau de bord
│   │       └── books/              # Gestion livres
│   ├── angular.json
│   └── package.json
│
└── README.md                       # Ce fichier
```

### Flux de données

```
┌─────────────┐      HTTP/REST      ┌──────────────┐      JPA/Hibernate      ┌──────────────┐
│   Angular   │ ◄──────────────────► │  Spring Boot │ ◄─────────────────────► │  PostgreSQL  │
│  Frontend   │   JSON + JWT Token   │   Backend    │     SQL Queries         │   Database   │
└─────────────┘                      └──────────────┘                         └──────────────┘
      │                                      │
      │                                      │
      ▼                                      ▼
┌─────────────┐                      ┌──────────────┐
│  Bootstrap  │                      │   MailDev    │
│     UI      │                      │ (Docker SMTP)│
└─────────────┘                      └──────────────┘
```

## 🛠 Technologies

### Backend
| Technologie | Version | Rôle |
|------------|---------|------|
| Java | 21 (LTS) | Langage principal |
| Spring Boot | 3.3.4 | Framework backend |
| Spring Security | 6.x | Authentification & autorisation |
| Spring Data JPA | 3.x | ORM / Accès données |
| PostgreSQL | 15.14 | Base de données |
| JWT (jjwt) | 0.11.5 | Token authentication |
| Lombok | Latest | Réduction boilerplate |
| SpringDoc OpenAPI | 2.5.0 | Documentation API (Swagger) |
| Thymeleaf | 3.1.2 | Templates emails |
| Maven | 3.9.9 | Build tool |
| Docker | 29.1.1 | Conteneurisation (MailDev) |

### Frontend
| Technologie | Version | Rôle |
|------------|---------|------|
| Angular | 19.2.0 | Framework frontend |
| TypeScript | 5.7.2 | Langage typé |
| Bootstrap | 5.3.x | Framework CSS |
| RxJS | 7.8 | Programmation réactive |
| Angular Router | 19 | Navigation |
| HttpClient | 19 | Requêtes HTTP |
| npm | 10.x | Gestionnaire de paquets |

## 📦 Prérequis

### Logiciels requis
- ☑️ **Java JDK 21** ou supérieur ([télécharger](https://www.oracle.com/java/technologies/downloads/))
- ☑️ **Node.js 20+** et **npm 10+** ([télécharger](https://nodejs.org/))
- ☑️ **PostgreSQL 15+** ([télécharger](https://www.postgresql.org/download/))
- ☑️ **Maven 3.9+** (inclus avec le wrapper `./mvnw`)
- ☑️ **Docker** (optionnel, pour MailDev) ([télécharger](https://www.docker.com/))
- ☑️ **Git** ([télécharger](https://git-scm.com/))

### Vérification des versions

```bash
java -version        # Doit afficher "21" ou supérieur
node -v              # Doit afficher "v20" ou supérieur
npm -v               # Doit afficher "10" ou supérieur
psql --version       # Doit afficher "15" ou supérieur
docker --version     # (optionnel) pour MailDev
mvn -v               # Maven 3.9+
```

## 🚀 Installation

### 1. Cloner le repository

```bash
git clone https://github.com/TsinjoNantosoa/book-loan-management.git
cd book-loan-management
```

### 2. Configuration de PostgreSQL

**Créer la base de données :**

```bash
# Se connecter à PostgreSQL
sudo -u postgres psql

# Créer un utilisateur et une base de données
CREATE USER tsinjo WITH PASSWORD 'nantosoa';
CREATE DATABASE bookdb OWNER tsinjo;
GRANT ALL PRIVILEGES ON DATABASE bookdb TO tsinjo;
\q
```

**Vérifier la connexion :**

```bash
psql -U tsinjo -d bookdb -h localhost
# Mot de passe : nantosoa
```

### 3. Configuration Backend

**Fichier `book-borrow/src/main/resources/application-dev.yml` :**

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/bookdb
    username: tsinjo
    password: nantosoa
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true

  mail:
    host: localhost
    port: 1025
    username: tsinjo
    password: nantosoa

application:
  security:
    jwt:
      secret-key: 404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970
      expiration: 86400000  # 24 heures
  file:
    upload:
      photos-output-path: ./uploads
```

### 4. Installation Frontend

```bash
cd book-borrow-frontend
npm install
```

## 🎬 Démarrage rapide

### Démarrage complet avec script (recommandé)

```bash
# Depuis la racine du projet
chmod +x start-all.sh
./start-all.sh
```

### Démarrage manuel

#### 1. Démarrer MailDev (optionnel)

```bash
cd book-borrow
sudo docker compose up -d
```

Accessible sur : http://localhost:1080

#### 2. Démarrer le Backend

```bash
cd book-borrow
./mvnw clean install
./mvnw spring-boot:run
```

Le backend démarre sur : **http://localhost:8088/api/v1**

Swagger UI : **http://localhost:8088/swagger-ui/index.html**

#### 3. Démarrer le Frontend

```bash
cd book-borrow-frontend
npm start
```

Le frontend démarre sur : **http://localhost:4200**

## ⚙️ Configuration

### Variables d'environnement

Créez un fichier `.env` à la racine pour personnaliser :

```bash
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=bookdb
DB_USER=tsinjo
DB_PASSWORD=nantosoa

# JWT
JWT_SECRET=404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970
JWT_EXPIRATION=86400000

# Mail
MAIL_HOST=localhost
MAIL_PORT=1025

# Upload
UPLOAD_PATH=./uploads
```

### Profils Spring

- **dev** : Développement (par défaut, affiche les requêtes SQL)
- **prod** : Production (logs minimaux, HTTPS recommandé)

Lancer avec un profil :
```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=prod
```

## 📡 API Endpoints

### Authentication (3 endpoints)

| Méthode | Endpoint | Description | Auth requise |
|---------|----------|-------------|--------------|
| POST | `/auth/register` | Inscription utilisateur | ❌ |
| GET | `/auth/activate-account?token=` | Activer compte | ❌ |
| POST | `/auth/authenticate` | Connexion (JWT) | ❌ |

### Books (11 endpoints)

| Méthode | Endpoint | Description | Auth requise |
|---------|----------|-------------|--------------|
| GET | `/books?page=0&size=10` | Liste tous les livres | ✅ |
| GET | `/books/{id}` | Détails d'un livre | ✅ |
| GET | `/books/owner?page=0&size=10` | Mes livres | ✅ |
| POST | `/books` | Créer un livre | ✅ |
| POST | `/books/cover/{id}` | Upload couverture | ✅ |
| PATCH | `/books/shareable/{id}` | Toggle partage | ✅ |
| PATCH | `/books/archived/{id}` | Toggle archivage | ✅ |
| POST | `/books/borrow/{id}` | Emprunter | ✅ |
| PATCH | `/books/borrow/return/{id}` | Retourner | ✅ |
| PATCH | `/books/borrow/return/approved/{id}` | Valider retour | ✅ |
| GET | `/books/borrowed?page=0&size=10` | Livres empruntés | ✅ |
| GET | `/books/returned?page=0&size=10` | Livres retournés | ✅ |

### Feedbacks (2 endpoints)

| Méthode | Endpoint | Description | Auth requise |
|---------|----------|-------------|--------------|
| POST | `/feedbacks` | Créer feedback | ✅ |
| GET | `/feedbacks/book/{book-id}?page=0&size=10` | Feedbacks d'un livre | ✅ |

### Exemples de requêtes

**Inscription :**
```bash
curl -X POST http://localhost:8088/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "Jean",
    "lastname": "Dupont",
    "email": "jean.dupont@example.com",
    "password": "Password123!"
  }'
```

**Connexion :**
```bash
curl -X POST http://localhost:8088/api/v1/auth/authenticate \
  -H "Content-Type: application/json" \
  -d '{
    "email": "jean.dupont@test.com",
    "password": "Password123!"
  }'
```

**Liste des livres (avec token) :**
```bash
curl -X GET "http://localhost:8088/api/v1/books?page=0&size=10" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

## 🧪 Tests

### Tests Backend

```bash
cd book-borrow
./mvnw test
```

### Tests Frontend

```bash
cd book-borrow-frontend
npm test
```

### Tests d'intégration

Un compte de test est disponible :
- **Email** : `jean.dupont@test.com`
- **Mot de passe** : `Password123!`

## 📸 Captures d'écran

### Page de connexion
![Login](docs/images/login.png)

### Dashboard
![Dashboard](docs/images/dashboard.png)

### Liste des livres
![Book List](docs/images/book-list.png)

### Détails d'un livre
![Book Detail](docs/images/book-detail.png)

### Swagger UI
![Swagger](docs/images/swagger.png)

## 🗂 Structure de la base de données

### Tables principales

- **app_user** : Utilisateurs (id, firstname, lastname, email, password, accountLocked, enabled)
- **app_user_roles** : Relation utilisateurs-rôles
- **role** : Rôles (USER, ADMIN)
- **book** : Livres (id, title, authorName, isbn, synopsis, bookCover, shareable, archived, owner_id)
- **book_transaction_history** : Historique emprunts (id, book_id, user_id, returned, returnedApproved)
- **feedback** : Feedbacks (id, note, comment, book_id)
- **token** : Tokens d'activation (token, validatedAt, expiresAt, user_id)

### Schéma relationnel

```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│  app_user   │ 1     n │     book     │ 1     n │  feedback   │
│             ├─────────┤              ├─────────┤             │
│  - id       │ owner   │  - id        │ book    │  - id       │
│  - email    │         │  - title     │         │  - note     │
│  - password │         │  - isbn      │         │  - comment  │
└─────────────┘         └──────────────┘         └─────────────┘
       │                        │
       │                        │
       │ 1:n                    │ 1:n
       │                        │
       ▼                        ▼
┌─────────────────────────────────────┐
│   book_transaction_history          │
│                                     │
│  - id                               │
│  - user_id (borrower)               │
│  - book_id                          │
│  - returned                         │
│  - returnedApproved                 │
└─────────────────────────────────────┘
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment contribuer :

1. **Fork** le projet
2. **Créer** une branche feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Push** vers la branche (`git push origin feature/AmazingFeature`)
5. **Ouvrir** une Pull Request

### Standards de code

- **Java** : Suivre les conventions Java (Google Style Guide)
- **TypeScript/Angular** : Suivre les conventions Angular (Angular Style Guide)
- **Commits** : Utiliser Conventional Commits (feat:, fix:, docs:, etc.)

## 📝 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👤 Auteur

**Tsinjo Nantosoa**
- GitHub : [@TsinjoNantosoa](https://github.com/TsinjoNantosoa)
- Repository : [book-loan-management](https://github.com/TsinjoNantosoa/book-loan-management)

## 🙏 Remerciements

- Spring Boot Team pour l'excellent framework
- Angular Team pour le framework frontend
- Communauté open-source pour les libraries utilisées

## 📞 Support

Pour toute question ou problème :
- Ouvrir une [issue](https://github.com/TsinjoNantosoa/book-loan-management/issues)
- Consulter la [documentation Swagger](http://localhost:8088/swagger-ui/index.html) (backend lancé)

---

⭐ **Si ce projet vous aide, n'hésitez pas à lui donner une étoile !** ⭐
