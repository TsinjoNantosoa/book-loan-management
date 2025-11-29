#!/bin/bash

echo "🚀 Configuration du frontend Angular..."

# Créer le fichier app.component principal avec navigation
cat > src/app/app.component.html << 'EOF'
<router-outlet></router-outlet>
EOF

cat > src/app/app.component.ts << 'EOF'
import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'book-borrow-frontend';
}
EOF

echo "✅ Fichiers principaux créés"
echo "✅ Le frontend est configuré!"
echo ""
echo "📝 Pour démarrer le frontend:"
echo "   cd /home/sandaniaina/Téléchargements/book-loan-management-main/book-borrow-frontend"
echo "   npm start"
echo ""
echo "🌐 L'application sera accessible sur: http://localhost:4200"

