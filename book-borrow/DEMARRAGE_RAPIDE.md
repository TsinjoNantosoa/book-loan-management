# 🚀 Guide de Démarrage Rapide - Book Loan Management API

## ✅ Installation Terminée !

Félicitations ! Votre environnement de développement est maintenant configuré avec :

- ✅ **PostgreSQL 15.14** - Base de données (installée localement)
- ✅ **Docker 29.1.1** - Conteneurisation
- ✅ **Docker Compose v2.40.3** - Orchestration
- ✅ **MailDev** - Serveur email de développement (Docker)
- ✅ **Java 21** - Runtime
- ✅ **Maven Wrapper** - Build tool

---

## 🎯 Démarrage Rapide (3 étapes)

### 1. Vérifier l'Installation

```bash
cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow
./check-postgres.sh
```

### 2. Démarrer les Services

```bash
./start-services.sh
```

Ce script démarre automatiquement :
- PostgreSQL (si non démarré)
- Docker (si non démarré)
- MailDev (serveur email)

### 3. Démarrer l'Application

**Option A : Avec Maven Wrapper (Recommandé)**
```bash
./mvnw spring-boot:run
```

**Option B : Avec Maven**
```bash
mvn spring-boot:run
```

**Option C : Compiler puis exécuter le JAR**
```bash
./mvnw clean package -DskipTests
java -jar target/book-borrow-0.0.1-SNAPSHOT.jar
```

---

## 🌐 Accès aux Services

Une fois l'application démarrée :

| Service | URL | Description |
|---------|-----|-------------|
| **API Backend** | http://localhost:8088/api/v1/ | Point d'entrée de l'API REST |
| **Swagger UI** | http://localhost:8088/api/v1/swagger-ui/index.html | Documentation interactive |
| **MailDev Web** | http://localhost:1080 | Interface pour voir les emails |
| **PostgreSQL** | localhost:5432 | Base de données (bookdb) |

---

## 📁 Structure du Projet

```
book-borrow/
├── 📄 README.md                    # Ce fichier
├── 📄 INSTALLATION_POSTGRES.md     # Guide PostgreSQL
├── 📄 INSTALLATION_DOCKER.md       # Guide Docker
├── 🔧 start-services.sh            # Script de démarrage
├── 🔧 check-postgres.sh            # Script de vérification
├── 🐳 docker-compose.yml           # Configuration Docker
├── 📦 pom.xml                      # Configuration Maven
├── ⚙️ mvnw & mvnw.cmd              # Maven Wrapper
└── src/
    ├── main/
    │   ├── java/com/tsinjo/book_borrow/
    │   │   ├── authentication/     # Authentification JWT
    │   │   ├── book/               # Gestion des livres
    │   │   ├── user/               # Gestion des utilisateurs
    │   │   ├── feedback/           # Système de feedback
    │   │   ├── history/            # Historique des emprunts
    │   │   └── security/           # Configuration sécurité
    │   └── resources/
    │       ├── application.yml
    │       └── application-dev.yml  # Configuration actuelle
    └── test/
```

---

## 🔧 Configuration Actuelle

### Base de Données (PostgreSQL)

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/bookdb
    username: tsinjo
    password: nantosoa
```

### Serveur Email (MailDev)

```yaml
spring:
  mail:
    host: localhost
    port: 1025
```

### JWT (Sécurité)

```yaml
application:
  security:
    jwt:
      secret-key: //jOUAXkClvCrd4iFrqA4Noi/8wOTpLXTuPdoow0Fngr253NM2V51DiI0c2Afns7KUCtLqbuPCSFJGuOk0tPKw==
      expiration: 86400000  # 24 heures
```

⚠️ **Important** : Changez la clé secrète JWT en production !

---

## 🧪 Tester l'Application

### 1. Ouvrir Swagger UI

http://localhost:8088/api/v1/swagger-ui/index.html

### 2. Créer un Compte

**Endpoint** : `POST /auth/register`

```json
{
  "firstname": "John",
  "lastname": "Doe",
  "email": "john.doe@example.com",
  "password": "Password123!"
}
```

### 3. Vérifier l'Email dans MailDev

1. Ouvrez : http://localhost:1080
2. Trouvez l'email d'activation
3. Copiez le token (6 chiffres)

### 4. Activer le Compte

**Endpoint** : `GET /auth/activate-account?token=123456`

### 5. Se Connecter

**Endpoint** : `POST /auth/authenticate`

```json
{
  "email": "john.doe@example.com",
  "password": "Password123!"
}
```

**Réponse** :
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 6. Utiliser le Token

1. Copiez le token reçu
2. Dans Swagger UI, cliquez sur **"Authorize"**
3. Entrez : `Bearer VOTRE_TOKEN`
4. Testez les autres endpoints !

---

## 🔨 Commandes Utiles

### Gestion de l'Application

```bash
# Démarrer l'application
./mvnw spring-boot:run

# Compiler le projet
./mvnw clean compile

# Packager en JAR
./mvnw clean package

# Exécuter les tests
./mvnw test

# Nettoyer le projet
./mvnw clean
```

### Gestion de PostgreSQL

```bash
# Démarrer PostgreSQL
sudo systemctl start postgresql

# Arrêter PostgreSQL
sudo systemctl stop postgresql

# Redémarrer PostgreSQL
sudo systemctl restart postgresql

# Voir le statut
sudo systemctl status postgresql

# Se connecter à la base
PGPASSWORD='nantosoa' psql -U tsinjo -d bookdb -h localhost
```

### Gestion de Docker

```bash
# Démarrer MailDev
cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow
docker compose up -d

# Arrêter MailDev
docker compose down

# Voir les logs
docker compose logs -f mail-dev

# Voir les conteneurs
docker ps

# Redémarrer MailDev
docker compose restart mail-dev
```

---

## 🐛 Dépannage

### L'application ne démarre pas

```bash
# Vérifier que PostgreSQL est démarré
sudo systemctl status postgresql

# Vérifier que le port 8088 est libre
sudo lsof -i :8088

# Voir les logs de l'application
# (Les logs s'affichent dans le terminal où vous avez lancé l'app)
```

### Erreur de connexion à PostgreSQL

```bash
# Vérifier que PostgreSQL écoute sur localhost
sudo netstat -tlnp | grep 5432

# Tester la connexion
PGPASSWORD='nantosoa' psql -U tsinjo -d bookdb -h localhost -c "SELECT 1;"

# Si erreur, redémarrer PostgreSQL
sudo systemctl restart postgresql
```

### MailDev ne fonctionne pas

```bash
# Vérifier que le conteneur est démarré
docker ps | grep mail-dev

# Voir les logs
docker logs mail-dev-bsn

# Redémarrer MailDev
docker compose restart mail-dev

# Tester l'accès
curl http://localhost:1080
```

### Port déjà utilisé

```bash
# Vérifier quel processus utilise le port 8088
sudo lsof -i :8088

# Tuer le processus (remplacez PID)
kill -9 PID

# Ou changez le port dans application-dev.yml
server:
  port: 8089
```

---

## 📚 Documentation Complète

- 📖 **[README Backend Complet](README.md)** - Documentation complète de l'API
- 🐘 **[Installation PostgreSQL](INSTALLATION_POSTGRES.md)** - Guide détaillé PostgreSQL
- 🐳 **[Installation Docker](INSTALLATION_DOCKER.md)** - Guide détaillé Docker

---

## 🔒 Sécurité pour la Production

Avant de déployer en production, **changez impérativement** :

### 1. Clé Secrète JWT

```bash
# Générer une nouvelle clé
openssl rand -base64 64

# Copier le résultat dans application.yml
application:
  security:
    jwt:
      secret-key: VOTRE_NOUVELLE_CLE_GENEREE
```

### 2. Mot de Passe PostgreSQL

```bash
# Se connecter à PostgreSQL
sudo -u postgres psql

# Changer le mot de passe
ALTER USER tsinjo WITH PASSWORD 'nouveau_mot_de_passe_securise';
```

### 3. Configuration Email

Remplacez MailDev par un vrai serveur SMTP (Gmail, SendGrid, etc.)

---

## 🎯 Checklist de Déploiement

- [ ] PostgreSQL installé et configuré
- [ ] Docker et Docker Compose installés
- [ ] MailDev accessible sur http://localhost:1080
- [ ] Application démarre sans erreur
- [ ] Test d'inscription réussi
- [ ] Email d'activation reçu dans MailDev
- [ ] Test de connexion réussi
- [ ] Token JWT fonctionnel
- [ ] Endpoints protégés testés avec Swagger

---

## 💡 Conseils de Développement

1. **Utilisez Swagger UI** pour tester rapidement les endpoints
2. **MailDev capture tous les emails** - vérifiez-y les emails d'activation
3. **Les logs sont dans le terminal** où vous avez lancé l'application
4. **Hot reload** : Utilisez Spring DevTools pour le rechargement automatique
5. **Base de données** : Utilisez `ddl-auto: update` en dev, `validate` en prod

---

## 🤝 Contribuer

Pour contribuer au projet :

1. Fork le repository
2. Créez une branche : `git checkout -b feature/ma-fonctionnalite`
3. Committez : `git commit -m 'Ajout de ma fonctionnalité'`
4. Push : `git push origin feature/ma-fonctionnalite`
5. Ouvrez une Pull Request

---

## 📧 Support

Pour toute question ou problème :

- 📧 Email : tsinjonantosoa@gmail.com
- 🐙 GitHub : [@TsinjoNantosoa](https://github.com/TsinjoNantosoa)
- 🐛 Issues : [Ouvrir une issue](https://github.com/TsinjoNantosoa/book-loan-management/issues)

---

## 🎉 Prêt à Commencer !

Tous les services sont configurés et prêts. Pour démarrer :

```bash
# Terminal 1 : Démarrer les services
./start-services.sh

# Terminal 2 : Ou démarrer manuellement
./mvnw spring-boot:run
```

Puis ouvrez : **http://localhost:8088/api/v1/swagger-ui/index.html**

**Bon développement ! 🚀**
