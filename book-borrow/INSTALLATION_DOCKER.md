# 🐳 Guide d'Installation Docker pour Book Loan Management API

## ✅ Installation Réussie !

Docker et Docker Compose ont été installés avec succès sur votre système.

### 📋 Versions Installées

| Composant | Version |
|-----------|---------|
| **Docker Engine** | 29.1.1 |
| **Docker Compose** | v2.40.3 |
| **Containerd** | 2.2.0 |

---

## 🎯 Services Docker Configurés

### 1. MailDev (Serveur Email de Développement)

MailDev est un serveur SMTP pour le développement qui capture tous les emails envoyés par l'application.

**Configuration :**
- **Conteneur** : `mail-dev-bsn`
- **Image** : `maildev/maildev`
- **Interface Web** : http://localhost:1080
- **Port SMTP** : 1025
- **Statut** : ✅ **EN COURS D'EXÉCUTION**

**Accès :**
```bash
# Ouvrez votre navigateur
http://localhost:1080
```

### 2. PostgreSQL

PostgreSQL est **installé localement** sur votre système (pas dans Docker) pour éviter les conflits de ports.

**Configuration :**
- **Service** : PostgreSQL 15.14
- **Port** : 5432
- **Base de données** : bookdb
- **Utilisateur** : tsinjo
- **Statut** : ✅ **EN COURS D'EXÉCUTION**

---

## 🚀 Commandes Docker Utiles

### Gestion des Services

```bash
# Démarrer tous les services (dans le dossier du projet)
cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow
docker compose up -d

# Arrêter tous les services
docker compose down

# Voir les logs des services
docker compose logs -f

# Voir les logs d'un service spécifique
docker compose logs -f mail-dev

# Redémarrer les services
docker compose restart

# Voir le statut des services
docker compose ps
```

### Gestion des Conteneurs

```bash
# Lister tous les conteneurs en cours d'exécution
docker ps

# Lister tous les conteneurs (y compris arrêtés)
docker ps -a

# Arrêter un conteneur
docker stop mail-dev-bsn

# Démarrer un conteneur
docker start mail-dev-bsn

# Redémarrer un conteneur
docker restart mail-dev-bsn

# Voir les logs d'un conteneur
docker logs mail-dev-bsn

# Suivre les logs en temps réel
docker logs -f mail-dev-bsn

# Supprimer un conteneur
docker rm mail-dev-bsn

# Forcer la suppression d'un conteneur en cours d'exécution
docker rm -f mail-dev-bsn
```

### Gestion des Images

```bash
# Lister les images Docker
docker images

# Supprimer une image
docker rmi maildev/maildev

# Télécharger une image
docker pull maildev/maildev

# Nettoyer les images inutilisées
docker image prune

# Nettoyer tout (images, conteneurs, volumes)
docker system prune -a
```

### Gestion des Volumes

```bash
# Lister les volumes
docker volume ls

# Supprimer un volume
docker volume rm book-borrow_postgres

# Nettoyer les volumes non utilisés
docker volume prune
```

---

## 🔧 Fichier docker-compose.yml

Voici la configuration actuelle :

```yaml
services:
  # PostgreSQL est installé localement
  # postgres:
  #   container_name: postgrs-sql-bsn
  #   image: postgres
  #   ... (commenté)
  
  mail-dev:
    container_name: mail-dev-bsn
    image: maildev/maildev
    ports:
      - 1080:1080  # Interface Web
      - 1025:1025  # Port SMTP
    networks:
      - spring-demo

networks:
  spring-demo:
    driver: bridge
```

---

## 📧 Test de MailDev

### Vérifier que MailDev fonctionne

```bash
# Test 1 : Vérifier que le conteneur est en cours d'exécution
docker ps | grep mail-dev

# Test 2 : Accéder à l'interface web
curl -I http://localhost:1080

# Test 3 : Tester le port SMTP
telnet localhost 1025
# (Tapez QUIT pour sortir)
```

### Envoyer un Email de Test

```bash
# Utiliser swaks (si installé)
swaks --to test@example.com --from app@bookapi.com --server localhost:1025 --body "Test depuis Book API"

# Ou avec Python
python3 << EOF
import smtplib
from email.message import EmailMessage

msg = EmailMessage()
msg.set_content("Test email depuis Book Loan API")
msg['Subject'] = "Test MailDev"
msg['From'] = "app@bookapi.com"
msg['To'] = "test@example.com"

s = smtplib.SMTP('localhost', 1025)
s.send_message(msg)
s.quit()
print("Email envoyé ! Vérifiez http://localhost:1080")
EOF
```

---

## 🎨 Interface MailDev

Une fois l'application démarrée, tous les emails seront capturés dans MailDev :

1. **Ouvrez votre navigateur** : http://localhost:1080
2. **Vous verrez** :
   - Liste des emails reçus
   - Contenu HTML et texte
   - En-têtes des emails
   - Pièces jointes

### Fonctionnalités de MailDev

- ✅ Capture tous les emails SMTP
- ✅ Interface Web moderne
- ✅ Prévisualisation HTML et texte
- ✅ Téléchargement des emails en .eml
- ✅ API REST pour l'intégration
- ✅ Support des pièces jointes
- ✅ Pas de configuration nécessaire

---

## ⚙️ Configuration de l'Application

L'application Spring Boot est configurée pour utiliser MailDev dans `application-dev.yml` :

```yaml
spring:
  mail:
    host: localhost
    port: 1025
    username: tsinjo
    password: nantosoa
    properties:
      mail:
        smtp:
          trust: "*"
          auth: true
          starttls:
            enable: true
```

---

## 🔄 Workflow de Développement

### 1. Démarrer les Services Docker

```bash
cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow
docker compose up -d
```

### 2. Vérifier que PostgreSQL est démarré

```bash
sudo systemctl status postgresql
```

### 3. Démarrer l'Application Spring Boot

```bash
./mvnw spring-boot:run
```

### 4. Accéder aux Services

- **API Backend** : http://localhost:8088/api/v1/
- **Swagger UI** : http://localhost:8088/api/v1/swagger-ui/index.html
- **MailDev** : http://localhost:1080

### 5. Tester l'Inscription

1. Inscrivez-vous via Swagger : `/auth/register`
2. Vérifiez l'email d'activation dans MailDev : http://localhost:1080
3. Copiez le token d'activation
4. Activez votre compte : `/auth/activate-account`

---

## 🛠️ Dépannage Docker

### Problème : Permission Denied

Si vous obtenez une erreur "permission denied" :

```bash
# Option 1 : Utilisez sudo
sudo docker ps

# Option 2 : Ajoutez votre utilisateur au groupe docker
sudo usermod -aG docker $USER

# Puis déconnectez-vous et reconnectez-vous
# Ou appliquez les changements immédiatement :
newgrp docker

# Vérifiez
docker ps
```

### Problème : Port Déjà Utilisé

```bash
# Vérifier quel processus utilise le port 1080
sudo lsof -i :1080

# Ou pour le port 1025
sudo lsof -i :1025

# Arrêter le conteneur en conflit
docker stop mail-dev-bsn

# Ou changer le port dans docker-compose.yml
ports:
  - "1081:1080"  # Nouvelle interface web sur 1081
  - "1026:1025"  # Nouveau port SMTP sur 1026
```

### Problème : Conteneur qui ne Démarre Pas

```bash
# Voir les logs détaillés
docker logs mail-dev-bsn

# Redémarrer le conteneur
docker restart mail-dev-bsn

# Recréer le conteneur
docker compose down
docker compose up -d

# Vérifier l'état du conteneur
docker inspect mail-dev-bsn
```

### Problème : Docker ne Démarre Pas

```bash
# Vérifier le statut du service Docker
sudo systemctl status docker

# Démarrer Docker
sudo systemctl start docker

# Activer Docker au démarrage
sudo systemctl enable docker

# Redémarrer Docker
sudo systemctl restart docker
```

---

## 📊 Monitoring des Conteneurs

### Voir l'Utilisation des Ressources

```bash
# Statistiques en temps réel
docker stats

# Statistiques d'un conteneur spécifique
docker stats mail-dev-bsn

# Informations détaillées
docker inspect mail-dev-bsn
```

### Voir les Processus dans un Conteneur

```bash
# Lister les processus
docker top mail-dev-bsn

# Exécuter une commande dans le conteneur
docker exec mail-dev-bsn ls -la

# Ouvrir un shell dans le conteneur
docker exec -it mail-dev-bsn sh
```

---

## 🔐 Sécurité Docker

### Bonnes Pratiques

1. **Ne jamais utiliser** `sudo` pour les commandes Docker en production
2. **Limiter les ressources** des conteneurs :
   ```yaml
   services:
     mail-dev:
       deploy:
         resources:
           limits:
             cpus: '0.5'
             memory: 512M
   ```
3. **Utiliser des variables d'environnement** pour les secrets
4. **Mettre à jour régulièrement** les images Docker

---

## 🧹 Nettoyage

### Nettoyer les Ressources Inutilisées

```bash
# Nettoyer tout (ATTENTION : supprime les conteneurs arrêtés, images, etc.)
docker system prune -a

# Nettoyer seulement les conteneurs arrêtés
docker container prune

# Nettoyer seulement les images non utilisées
docker image prune

# Nettoyer seulement les volumes non utilisés
docker volume prune

# Nettoyer seulement les réseaux non utilisés
docker network prune
```

---

## 📚 Ressources Utiles

- [Documentation Docker](https://docs.docker.com/)
- [Documentation Docker Compose](https://docs.docker.com/compose/)
- [MailDev sur GitHub](https://github.com/maildev/maildev)
- [Docker Hub](https://hub.docker.com/)

---

## ✅ Checklist de Vérification

- [x] Docker Engine installé (v29.1.1)
- [x] Docker Compose installé (v2.40.3)
- [x] Utilisateur ajouté au groupe docker
- [x] MailDev démarré et accessible (http://localhost:1080)
- [x] PostgreSQL installé localement (pas dans Docker)
- [x] Configuration docker-compose.yml adaptée
- [ ] Application Spring Boot testée avec MailDev

---

## 🎉 Résumé

**Services Docker Actifs :**
```bash
docker ps
```

**Services à Démarrer Manuellement :**
```bash
# PostgreSQL (local, pas Docker)
sudo systemctl start postgresql

# MailDev (Docker)
docker compose up -d
```

**Services Disponibles :**
- ✅ MailDev : http://localhost:1080
- ✅ PostgreSQL : localhost:5432
- 🚀 API : http://localhost:8088/api/v1/ (après démarrage)

---

**🎯 Prochaine Étape : Démarrer l'application Spring Boot !**

```bash
cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow
./mvnw spring-boot:run
```
