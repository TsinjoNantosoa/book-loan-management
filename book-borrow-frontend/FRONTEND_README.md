# 🎨 Frontend Angular - Book Borrow Management

## 📋 Vue d'Ensemble

Application Angular 19 standalone avec Bootstrap 5 pour gérer une bibliothèque de prêt de livres.

**Date de création :** 29 novembre 2025  
**Framework :** Angular 19.2  
**UI Framework :** Bootstrap 5  
**Backend API :** http://localhost:8088/api/v1

---

## 🗂️ Structure du Projet

```
src/app/
├── models/              # Interfaces TypeScript
│   ├── user.model.ts
│   ├── book.model.ts
│   └── feedback.model.ts
│
├── services/            # Services API
│   ├── auth.service.ts
│   ├── book.service.ts
│   └── feedback.service.ts
│
├── guards/              # Route Guards
│   └── auth.guard.ts
│
├── interceptors/        # HTTP Interceptors
│   └── auth.interceptor.ts
│
└── pages/               # Composants de pages
    ├── auth/
    │   ├── login/
    │   ├── register/
    │   └── activate-account/
    ├── dashboard/
    └── books/
        ├── book-list/
        ├── book-detail/
        ├── my-books/
        └── add-book/
```

---

## ✅ Fonctionnalités Implémentées

### 🔐 Authentification
- ✅ Inscription utilisateur
- ✅ Activation de compte par token
- ✅ Connexion avec JWT
- ✅ Déconnexion
- ✅ Guard de protection des routes
- ✅ Intercepteur HTTP pour ajouter le token

### 📚 Gestion des Livres
- ✅ Lister tous les livres disponibles (paginé)
- ✅ Voir les détails d'un livre
- ✅ Créer un nouveau livre
- ✅ Upload de couverture de livre
- ✅ Mes livres (propriétaire)
- ✅ Basculer statut partageable
- ✅ Archiver/Désarchiver un livre

### 📖 Système d'Emprunt
- ✅ Emprunter un livre
- ✅ Retourner un livre
- ✅ Approuver un retour (propriétaire)
- ✅ Voir mes livres empruntés
- ✅ Voir les retours en attente

### ⭐ Feedbacks
- ✅ Ajouter un feedback (note + commentaire)
- ✅ Voir les feedbacks d'un livre

---

## 🛠️ Configuration

### API Backend

L'URL du backend est configurée dans chaque service :

```typescript
// services/auth.service.ts
private apiUrl = 'http://localhost:8088/api/v1/auth';

// services/book.service.ts
private apiUrl = 'http://localhost:8088/api/v1/books';

// services/feedback.service.ts
private apiUrl = 'http://localhost:8088/api/v1/feedbacks';
```

### Intercepteur JWT

L'intercepteur ajoute automatiquement le token JWT à toutes les requêtes sauf celles vers `/auth/` :

```typescript
// interceptors/auth.interceptor.ts
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(AuthService);
  const token = authService.getToken();

  if (token && !req.url.includes('/auth/')) {
    const clonedReq = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`
      }
    });
    return next(clonedReq);
  }

  return next(req);
};
```

---

## 🚀 Démarrage

### Installation

```bash
cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow-frontend
npm install
```

### Développement

```bash
npm start
# ou
ng serve
```

L'application sera accessible sur : **http://localhost:4200**

### Production

```bash
npm run build
```

Les fichiers de production seront générés dans `dist/book-borrow-frontend/`

---

## 📱 Routes

| Route | Composant | Guard | Description |
|-------|-----------|-------|-------------|
| `/` | - | - | Redirige vers `/login` |
| `/login` | LoginComponent | - | Page de connexion |
| `/register` | RegisterComponent | - | Page d'inscription |
| `/activate-account` | ActivateAccountComponent | - | Activation par token |
| `/dashboard` | DashboardComponent | ✅ | Tableau de bord |
| `/books` | BookListComponent | ✅ | Liste des livres |
| `/books/:id` | BookDetailComponent | ✅ | Détails d'un livre |
| `/my-books` | MyBooksComponent | ✅ | Mes livres |
| `/add-book` | AddBookComponent | ✅ | Ajouter un livre |

---

## 🎨 Design

### Bootstrap 5

Bootstrap est configuré dans `angular.json` :

```json
"styles": [
  "node_modules/bootstrap/dist/css/bootstrap.min.css",
  "src/styles.css"
],
"scripts": [
  "node_modules/bootstrap/dist/js/bootstrap.bundle.min.js"
]
```

### Composants Utilisés

- **Forms** : Reactive Forms avec validation
- **Cards** : Pour afficher les livres
- **Modals** : Pour les confirmations
- **Alerts** : Messages d'erreur/succès
- **Spinners** : Indicateurs de chargement
- **Pagination** : Navigation entre les pages

---

## 📦 Dépendances

### Dependencies

```json
{
  "@angular/common": "^19.2.0",
  "@angular/core": "^19.2.0",
  "@angular/forms": "^19.2.0",
  "@angular/router": "^19.2.0",
  "bootstrap": "^5.3.x",
  "rxjs": "~7.8.0"
}
```

### Dev Dependencies

```json
{
  "@angular/cli": "^19.2.8",
  "@angular/compiler-cli": "^19.2.0",
  "typescript": "~5.7.2"
}
```

---

## 🔧 Services API

### AuthService

```typescript
register(request: RegistrationRequest): Observable<void>
activateAccount(token: string): Observable<void>
login(request: AuthenticationRequest): Observable<AuthenticationResponse>
logout(): void
getToken(): string | null
isAuthenticated(): boolean
```

### BookService

```typescript
getAllBooks(page, size): Observable<PageResponse<Book>>
getBookById(id): Observable<Book>
getMyBooks(page, size): Observable<PageResponse<Book>>
createBook(request): Observable<number>
uploadBookCover(bookId, file): Observable<void>
toggleShareable(bookId): Observable<number>
toggleArchived(bookId): Observable<number>
borrowBook(bookId): Observable<number>
returnBook(bookId): Observable<number>
approveReturn(bookId): Observable<number>
getBorrowedBooks(page, size): Observable<PageResponse<BorrowedBook>>
getReturnedBooks(page, size): Observable<PageResponse<BorrowedBook>>
```

### FeedbackService

```typescript
createFeedback(request): Observable<number>
getBookFeedbacks(bookId, page, size): Observable<PageResponse<Feedback>>
```

---

## 🧪 Tests

### Tests Unitaires

```bash
npm test
```

### Tests E2E

À configurer selon les besoins.

---

## 📝 Exemple d'Utilisation

### 1. Inscription

```typescript
const request: RegistrationRequest = {
  firstname: 'Jean',
  lastname: 'Dupont',
  email: 'jean.dupont@example.com',
  password: 'SecurePass123!'
};

authService.register(request).subscribe({
  next: () => console.log('Inscription réussie'),
  error: (err) => console.error(err)
});
```

### 2. Connexion

```typescript
const request: AuthenticationRequest = {
  email: 'jean.dupont@example.com',
  password: 'SecurePass123!'
};

authService.login(request).subscribe({
  next: (response) => {
    // Token automatiquement sauvegardé
    router.navigate(['/dashboard']);
  },
  error: (err) => console.error(err)
});
```

### 3. Créer un Livre

```typescript
const book: BookRequest = {
  title: 'Le Petit Prince',
  authorName: 'Antoine de Saint-Exupéry',
  isbn: '978-2070408504',
  synopsis: 'Un conte philosophique...',
  shareable: true
};

bookService.createBook(book).subscribe({
  next: (bookId) => console.log('Livre créé:', bookId),
  error: (err) => console.error(err)
});
```

---

## 🚨 Gestion des Erreurs

Les erreurs API sont gérées dans chaque composant :

```typescript
this.authService.login(credentials).subscribe({
  next: (response) => {
    // Succès
  },
  error: (error) => {
    if (error.status === 401) {
      this.errorMessage = 'Identifiants incorrects';
    } else if (error.status === 403) {
      this.errorMessage = 'Compte non activé';
    } else {
      this.errorMessage = 'Une erreur est survenue';
    }
  }
});
```

---

## 🎯 Prochaines Étapes

### À Implémenter

- [ ] Composants HTML complets pour tous les pages
- [ ] Système de notifications (Toastr)
- [ ] Pagination avancée
- [ ] Filtres et recherche
- [ ] Upload d'images avec prévisualisation
- [ ] Mode sombre
- [ ] Responsive design complet
- [ ] Animations (Angular Animations)
- [ ] Lazy loading des modules
- [ ] PWA (Progressive Web App)

### Optimisations

- [ ] OnPush Change Detection
- [ ] TrackBy dans les ngFor
- [ ] Caching des données
- [ ] Optimisation des images
- [ ] Service Worker

---

## 📞 Support

### Liens Utiles

- **Frontend** : http://localhost:4200
- **Backend API** : http://localhost:8088/api/v1
- **Swagger UI** : http://localhost:8088/api/v1/swagger-ui/index.html

### Documentation

- [Angular Documentation](https://angular.dev)
- [Bootstrap Documentation](https://getbootstrap.com/docs)
- [RxJS Documentation](https://rxjs.dev)

---

## 🎉 Conclusion

Le frontend Angular est **configuré et prêt** avec :

✅ Services API complets  
✅ Routing avec guards  
✅ HTTP Interceptor pour JWT  
✅ Models TypeScript  
✅ Bootstrap 5 intégré  
✅ Architecture modulaire  
✅ Composants standalone (Angular 19)  

**Prêt pour le développement !** 🚀

---

*Dernière mise à jour : 29 novembre 2025*
