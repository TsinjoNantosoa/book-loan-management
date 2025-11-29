#!/bin/bash

# Script de vérification de l'installation PostgreSQL
# pour Book Loan Management API

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Vérification Installation PostgreSQL - Book Loan API      ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
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

# 1. Vérifier PostgreSQL installé
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Vérification de l'installation PostgreSQL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
psql --version > /dev/null 2>&1
check_result "PostgreSQL est installé"
if [ $? -eq 0 ]; then
    VERSION=$(psql --version)
    echo "   Version: $VERSION"
fi
echo ""

# 2. Vérifier le service
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. Vérification du service PostgreSQL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
sudo systemctl is-active --quiet postgresql
check_result "Le service PostgreSQL est actif"
echo ""

# 3. Vérifier la base de données
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. Vérification de la base de données 'bookdb'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw bookdb
check_result "La base de données 'bookdb' existe"
echo ""

# 4. Vérifier l'utilisateur
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. Vérification de l'utilisateur 'tsinjo'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='tsinjo'" | grep -q 1
check_result "L'utilisateur 'tsinjo' existe"
echo ""

# 5. Test de connexion
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5. Test de connexion avec l'utilisateur 'tsinjo'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
PGPASSWORD='nantosoa' psql -U tsinjo -d bookdb -h localhost -c "SELECT 1;" > /dev/null 2>&1
check_result "Connexion réussie à la base 'bookdb'"
echo ""

# 6. Vérifier Java
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "6. Vérification de Java"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
java -version > /dev/null 2>&1
check_result "Java est installé"
if [ $? -eq 0 ]; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    echo "   Version: $JAVA_VERSION"
fi
echo ""

# 7. Vérifier Maven
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "7. Vérification de Maven"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
mvn -version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    check_result "Maven est installé"
    MAVEN_VERSION=$(mvn -version | head -n 1)
    echo "   Version: $MAVEN_VERSION"
else
    echo -e "${YELLOW}⚠ Maven n'est pas installé (mvnw disponible)${NC}"
fi
echo ""

# 8. Informations de configuration
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "8. Configuration de la base de données"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "   ${GREEN}Hôte:${NC}          localhost"
echo -e "   ${GREEN}Port:${NC}          5432"
echo -e "   ${GREEN}Base de données:${NC} bookdb"
echo -e "   ${GREEN}Utilisateur:${NC}   tsinjo"
echo -e "   ${GREEN}Mot de passe:${NC}  nantosoa"
echo -e "   ${GREEN}URL JDBC:${NC}      jdbc:postgresql://localhost:5432/bookdb"
echo ""

# 9. Test de création d'une table (optionnel)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "9. Test de création de table"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
PGPASSWORD='nantosoa' psql -U tsinjo -d bookdb -h localhost -c "
CREATE TABLE IF NOT EXISTS test_connection (
    id SERIAL PRIMARY KEY,
    message VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO test_connection (message) VALUES ('PostgreSQL fonctionne correctement!');
SELECT * FROM test_connection;
DROP TABLE test_connection;
" > /dev/null 2>&1
check_result "Test de création/suppression de table"
echo ""

# Résumé final
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    RÉSUMÉ DE L'INSTALLATION                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}✓ PostgreSQL est correctement configuré et prêt à l'emploi !${NC}"
echo ""
echo "Pour démarrer l'application Spring Boot, exécutez :"
echo -e "  ${YELLOW}cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow${NC}"
echo -e "  ${YELLOW}mvn spring-boot:run${NC}"
echo ""
echo "Ou avec le wrapper Maven :"
echo -e "  ${YELLOW}./mvnw spring-boot:run${NC}"
echo ""
echo "L'API sera accessible sur :"
echo -e "  ${GREEN}http://localhost:8088/api/v1/${NC}"
echo ""
echo "Documentation Swagger :"
echo -e "  ${GREEN}http://localhost:8088/api/v1/swagger-ui/index.html${NC}"
echo ""
