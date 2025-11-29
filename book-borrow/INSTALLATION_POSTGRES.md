# 🐘 Guide d'Installation PostgreSQL pour Book Loan Management API

## ✅ Installation Réussie !

PostgreSQL a été installé avec succès sur votre système avec la configuration suivante :

### 📋 Informations de Configuration

| Paramètre | Valeur |
|-----------|--------|
| **Version PostgreSQL** | 15.14 |
| **Nom de la base** | `bookdb` |
| **Utilisateur** | `tsinjo` |
| **Mot de passe** | `nantosoa` |
| **Hôte** | `localhost` |
| **Port** | `5432` |
| **URL JDBC** | `jdbc:postgresql://localhost:5432/bookdb` |

---

## 📝 Résumé des Commandes Exécutées

```bash
# 1. Mise à jour du système
sudo apt update

# 2. Installation de PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# 3. Création de l'utilisateur
sudo -u postgres psql -c "CREATE USER tsinjo WITH PASSWORD 'nantosoa';"

# 4. Création de la base de données
sudo -u postgres psql -c "CREATE DATABASE bookdb OWNER tsinjo;"

# 5. Attribution des privilèges
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE bookdb TO tsinjo;"
```

---

## 🔧 Commandes Utiles PostgreSQL

### Gestion du Service

```bash
# Démarrer PostgreSQL
sudo systemctl start postgresql

# Arrêter PostgreSQL
sudo systemctl stop postgresql

# Redémarrer PostgreSQL
sudo systemctl restart postgresql

# Vérifier le statut
sudo systemctl status postgresql

# Activer au démarrage
sudo systemctl enable postgresql
```

### Connexion à la Base de Données

```bash
# Se connecter en tant que postgres (super-utilisateur)
sudo -u postgres psql

# Se connecter avec l'utilisateur tsinjo
psql -U tsinjo -d bookdb -h localhost

# Ou avec le mot de passe en variable d'environnement
PGPASSWORD='nantosoa' psql -U tsinjo -d bookdb -h localhost
```

### Commandes SQL Utiles

```sql
-- Lister toutes les bases de données
\l

-- Lister tous les utilisateurs
\du

-- Se connecter à une base de données
\c bookdb

-- Lister toutes les tables
\dt

-- Voir la structure d'une table
\d nom_de_la_table

-- Quitter psql
\q
```

---

## 🧪 Test de Connexion

Pour tester que votre configuration fonctionne correctement :

```bash
# Test rapide
PGPASSWORD='nantosoa' psql -U tsinjo -d bookdb -h localhost -c "SELECT 'Connection successful!' as status;"
```

Résultat attendu :
```
       status        
--------------------
 Connection successful!
(1 row)
```

---

## 🚀 Démarrage de l'Application Spring Boot

Maintenant que PostgreSQL est configuré, vous pouvez démarrer votre application :

### Option 1 : Avec Maven

```bash
cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow
mvn spring-boot:run
```

### Option 2 : Avec le JAR compilé

```bash
# Compiler le projet
mvn clean package -DskipTests

# Lancer l'application
java -jar target/book-borrow-0.0.1-SNAPSHOT.jar
```

### Option 3 : Avec Docker Compose

```bash
# Démarrer tous les services (PostgreSQL, MailDev, etc.)
docker-compose up -d

# L'application se connectera automatiquement
mvn spring-boot:run
```

---

## 🔐 Configuration de Sécurité (Production)

### ⚠️ Important pour la Production

Pour un environnement de production, **changez ces paramètres** :

#### 1. Mot de passe PostgreSQL

```bash
# Se connecter en tant que postgres
sudo -u postgres psql

# Changer le mot de passe
ALTER USER tsinjo WITH PASSWORD 'nouveau_mot_de_passe_securise';
```

#### 2. Clé secrète JWT

Générez une nouvelle clé secrète sécurisée :

```bash
# Générer une clé Base64
openssl rand -base64 64
```

Puis remplacez dans `application-dev.yml` ou `application-prod.yml` :
```yaml
application:
  security:
    jwt:
      secret-key: VOTRE_NOUVELLE_CLE_GENEREE
```

#### 3. Configuration PostgreSQL pour Production

Éditez `/etc/postgresql/15/main/postgresql.conf` :

```bash
sudo nano /etc/postgresql/15/main/postgresql.conf
```

Paramètres recommandés :
```ini
# Connexions
max_connections = 100
shared_buffers = 256MB
effective_cache_size = 1GB
work_mem = 4MB

# Logging
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h '
log_min_duration_statement = 1000  # Log queries > 1s
```

---

## 🗃️ Sauvegarde et Restauration

### Créer une Sauvegarde

```bash
# Sauvegarde complète de la base
pg_dump -U tsinjo -h localhost bookdb > bookdb_backup_$(date +%Y%m%d).sql

# Ou avec mot de passe
PGPASSWORD='nantosoa' pg_dump -U tsinjo -h localhost bookdb > bookdb_backup.sql
```

### Restaurer une Sauvegarde

```bash
# Restaurer la base
psql -U tsinjo -h localhost bookdb < bookdb_backup.sql

# Ou avec mot de passe
PGPASSWORD='nantosoa' psql -U tsinjo -h localhost bookdb < bookdb_backup.sql
```

---

## 🔍 Dépannage

### Problème : Impossible de se connecter

```bash
# Vérifier que PostgreSQL est démarré
sudo systemctl status postgresql

# Vérifier les logs
sudo tail -f /var/log/postgresql/postgresql-15-main.log

# Tester la connexion locale
psql -U tsinjo -d bookdb -h localhost
```

### Problème : Erreur d'authentification

Vérifiez le fichier `pg_hba.conf` :

```bash
sudo nano /etc/postgresql/15/main/pg_hba.conf
```

Assurez-vous d'avoir cette ligne :
```
host    all             all             127.0.0.1/32            scram-sha-256
```

Puis redémarrez PostgreSQL :
```bash
sudo systemctl restart postgresql
```

### Problème : Port 5432 déjà utilisé

```bash
# Vérifier quel processus utilise le port
sudo lsof -i :5432

# Ou
sudo netstat -tlnp | grep 5432
```

### Problème : Base de données déjà existante

```bash
# Supprimer et recréer la base
sudo -u postgres psql -c "DROP DATABASE IF EXISTS bookdb;"
sudo -u postgres psql -c "CREATE DATABASE bookdb OWNER tsinjo;"
```

---

## 📊 Vérification de l'Installation

Exécutez ce script pour vérifier que tout fonctionne :

```bash
#!/bin/bash
echo "=== Vérification de l'Installation PostgreSQL ==="
echo ""

echo "1. Version PostgreSQL :"
psql --version

echo ""
echo "2. Statut du service :"
sudo systemctl is-active postgresql

echo ""
echo "3. Test de connexion :"
PGPASSWORD='nantosoa' psql -U tsinjo -d bookdb -h localhost -c "SELECT 'OK' as status;"

echo ""
echo "4. Liste des bases de données :"
sudo -u postgres psql -c "\l" | grep bookdb

echo ""
echo "5. Informations sur l'utilisateur :"
sudo -u postgres psql -c "\du" | grep tsinjo

echo ""
echo "=== Installation vérifiée avec succès ! ==="
```

---

## 📱 Accès à l'Application

Une fois l'application démarrée :

- **API Backend** : http://localhost:8088/api/v1/
- **Swagger UI** : http://localhost:8088/api/v1/swagger-ui/index.html
- **MailDev** (emails) : http://localhost:1080
- **Base de données** : localhost:5432/bookdb

---

## 📚 Ressources Supplémentaires

- [Documentation officielle PostgreSQL](https://www.postgresql.org/docs/)
- [PostgreSQL sur Debian](https://wiki.debian.org/PostgreSql)
- [Spring Boot avec PostgreSQL](https://spring.io/guides/gs/accessing-data-postgresql/)
- [Best Practices PostgreSQL](https://wiki.postgresql.org/wiki/Don%27t_Do_This)

---

## 💡 Conseils

1. **Sauvegardez régulièrement** votre base de données en production
2. **Changez les mots de passe par défaut** avant de déployer
3. **Surveillez les performances** avec `pg_stat_statements`
4. **Configurez le firewall** pour limiter l'accès au port 5432
5. **Utilisez SSL/TLS** pour les connexions en production

---

## ✅ Checklist de Déploiement

- [ ] PostgreSQL installé et démarré
- [ ] Base de données `bookdb` créée
- [ ] Utilisateur `tsinjo` créé avec les bons privilèges
- [ ] Test de connexion réussi
- [ ] Application Spring Boot connectée
- [ ] Sauvegarde automatique configurée (production)
- [ ] Mots de passe changés (production)
- [ ] Firewall configuré (production)

---

**🎉 Félicitations ! Votre base de données PostgreSQL est maintenant configurée et prête à l'emploi !**
