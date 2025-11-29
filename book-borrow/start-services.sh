#!/bin/bash

# Script de démarrage complet pour Book Loan Management API
# Ce script démarre tous les services nécessaires

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║    Démarrage Book Loan Management API - Tous les Services   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher le résultat
check_result() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $1${NC}"
        return 0
    else
        echo -e "${RED}✗ $1${NC}"
        return 1
    fi
}

# Fonction pour afficher une étape
step() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Vérifier si on est dans le bon dossier
if [ ! -f "pom.xml" ]; then
    echo -e "${RED}Erreur: Ce script doit être exécuté depuis le dossier book-borrow${NC}"
    echo "Changez de dossier avec :"
    echo "cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow"
    exit 1
fi

# 1. Vérifier PostgreSQL
step "1. Vérification de PostgreSQL"
sudo systemctl is-active --quiet postgresql
if [ $? -eq 0 ]; then
    check_result "PostgreSQL est déjà démarré"
else
    echo -e "${YELLOW}PostgreSQL n'est pas démarré. Démarrage...${NC}"
    sudo systemctl start postgresql
    check_result "PostgreSQL démarré"
fi

# Test de connexion
PGPASSWORD='nantosoa' psql -U tsinjo -d bookdb -h localhost -c "SELECT 1;" > /dev/null 2>&1
check_result "Connexion à la base de données OK"

# 2. Vérifier Docker
step "2. Vérification de Docker"
sudo systemctl is-active --quiet docker
if [ $? -eq 0 ]; then
    check_result "Docker est déjà démarré"
else
    echo -e "${YELLOW}Docker n'est pas démarré. Démarrage...${NC}"
    sudo systemctl start docker
    check_result "Docker démarré"
fi

# 3. Démarrer MailDev
step "3. Démarrage de MailDev (Serveur Email)"
sudo docker ps | grep -q mail-dev-bsn
if [ $? -eq 0 ]; then
    check_result "MailDev est déjà en cours d'exécution"
else
    echo -e "${YELLOW}MailDev n'est pas démarré. Démarrage...${NC}"
    sudo docker compose up -d mail-dev 2>&1 | grep -v "Warning"
    sleep 3
    check_result "MailDev démarré"
fi

# Test MailDev
curl -s http://localhost:1080 > /dev/null 2>&1
check_result "MailDev accessible sur http://localhost:1080"

# 4. Vérifier Java
step "4. Vérification de Java"
java -version > /dev/null 2>&1
check_result "Java est installé"
JAVA_VERSION=$(java -version 2>&1 | head -n 1)
echo "   ${JAVA_VERSION}"

# 5. Informations des services
step "5. Résumé des Services"
echo ""
echo -e "${GREEN}✓ PostgreSQL${NC}"
echo "   - Hôte: localhost"
echo "   - Port: 5432"
echo "   - Base: bookdb"
echo "   - User: tsinjo"
echo "   - URL: jdbc:postgresql://localhost:5432/bookdb"
echo ""
echo -e "${GREEN}✓ MailDev${NC}"
echo "   - Interface Web: http://localhost:1080"
echo "   - SMTP: localhost:1025"
echo ""
echo -e "${YELLOW}⚠ Application Spring Boot${NC}"
echo "   - Statut: Non démarrée"
echo "   - URL: http://localhost:8088/api/v1/"
echo "   - Swagger: http://localhost:8088/api/v1/swagger-ui/index.html"
echo ""

# 6. Options de démarrage de l'application
step "6. Démarrage de l'Application"
echo ""
echo "Choisissez comment démarrer l'application :"
echo ""
echo "  1) Démarrer maintenant avec Maven Wrapper (recommandé)"
echo "  2) Démarrer maintenant avec Maven"
echo "  3) Compiler et créer le JAR (sans démarrer)"
echo "  4) Ne pas démarrer maintenant (je le ferai manuellement)"
echo ""
read -p "Votre choix [1-4] : " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}Démarrage de l'application avec Maven Wrapper...${NC}"
        echo -e "${YELLOW}Cela peut prendre quelques minutes...${NC}"
        echo ""
        ./mvnw spring-boot:run
        ;;
    2)
        echo ""
        echo -e "${YELLOW}Démarrage de l'application avec Maven...${NC}"
        echo -e "${YELLOW}Cela peut prendre quelques minutes...${NC}"
        echo ""
        mvn spring-boot:run
        ;;
    3)
        echo ""
        echo -e "${YELLOW}Compilation du projet...${NC}"
        ./mvnw clean package -DskipTests
        check_result "Compilation terminée"
        echo ""
        echo "Pour démarrer l'application, exécutez :"
        echo -e "${GREEN}java -jar target/book-borrow-0.0.1-SNAPSHOT.jar${NC}"
        ;;
    4)
        echo ""
        echo -e "${GREEN}Tous les services sont prêts !${NC}"
        echo ""
        echo "Pour démarrer l'application plus tard :"
        echo -e "${YELLOW}./mvnw spring-boot:run${NC}"
        echo ""
        echo "Ou compilez d'abord :"
        echo -e "${YELLOW}./mvnw clean package${NC}"
        echo -e "${YELLOW}java -jar target/book-borrow-0.0.1-SNAPSHOT.jar${NC}"
        ;;
    *)
        echo -e "${RED}Choix invalide. Aucune action effectuée.${NC}"
        ;;
esac

echo ""
step "✅ Configuration Terminée"
echo ""
echo "📌 Services Disponibles :"
echo "   • PostgreSQL : localhost:5432"
echo "   • MailDev Web : http://localhost:1080"
echo "   • API Backend : http://localhost:8088/api/v1/"
echo "   • Swagger UI : http://localhost:8088/api/v1/swagger-ui/index.html"
echo ""
echo "📚 Documentation :"
echo "   • Installation PostgreSQL : INSTALLATION_POSTGRES.md"
echo "   • Installation Docker : INSTALLATION_DOCKER.md"
echo "   • README Backend : README.md"
echo ""
echo "🔧 Commandes Utiles :"
echo "   • Arrêter MailDev : docker compose down"
echo "   • Voir les logs : docker compose logs -f mail-dev"
echo "   • Arrêter PostgreSQL : sudo systemctl stop postgresql"
echo ""
echo -e "${GREEN}🚀 Bon développement !${NC}"
echo ""
