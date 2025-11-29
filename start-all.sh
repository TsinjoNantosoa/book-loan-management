#!/bin/bash

echo "🚀 Starting Book Loan Management System..."
echo ""

# Check if PostgreSQL is running
if ! systemctl is-active --quiet postgresql; then
    echo "❌ PostgreSQL is not running. Starting it..."
    sudo systemctl start postgresql
fi

echo "✅ PostgreSQL running"

# Start MailDev with Docker
echo "🐳 Starting MailDev container..."
cd book-borrow
sudo docker compose up -d || echo "⚠️ Docker not available or already running"
cd ..

# Start Backend in background
echo "☕ Starting Spring Boot backend..."
cd book-borrow
nohup ./mvnw spring-boot:run > /tmp/spring-boot-backend.log 2>&1 &
BACKEND_PID=$!
echo "Backend PID: $BACKEND_PID"
cd ..

# Wait for backend to start
echo "⏳ Waiting for backend to start (15 seconds)..."
sleep 15

# Start Frontend
echo "🎨 Starting Angular frontend..."
cd book-borrow-frontend
nohup npm start > /tmp/angular-frontend.log 2>&1 &
FRONTEND_PID=$!
echo "Frontend PID: $FRONTEND_PID"
cd ..

# Wait for frontend to compile
echo "⏳ Waiting for Angular compilation (15 seconds)..."
sleep 15

echo ""
echo "✅ ================================================"
echo "✅  Book Loan Management System is running!"
echo "✅ ================================================"
echo ""
echo "📡 Services available:"
echo "  - Frontend:  http://localhost:4200"
echo "  - Backend:   http://localhost:8088/api/v1"
echo "  - Swagger:   http://localhost:8088/swagger-ui/index.html"
echo "  - MailDev:   http://localhost:1080"
echo ""
echo "👤 Test account:"
echo "  - Email:    jean.dupont@test.com"
echo "  - Password: Password123!"
echo ""
echo "📋 Logs:"
echo "  - Backend:  tail -f /tmp/spring-boot-backend.log"
echo "  - Frontend: tail -f /tmp/angular-frontend.log"
echo ""
echo "🛑 To stop all services:"
echo "  - kill $BACKEND_PID $FRONTEND_PID"
echo "  - cd book-borrow && sudo docker compose down"
echo ""
