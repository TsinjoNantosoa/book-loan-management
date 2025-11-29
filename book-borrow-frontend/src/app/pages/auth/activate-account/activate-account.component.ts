import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router, RouterModule, ActivatedRoute } from '@angular/router';
import { AuthService } from '../../../services/auth.service';

@Component({
  selector: 'app-activate-account',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterModule],
  templateUrl: './activate-account.component.html',
  styleUrl: './activate-account.component.css'
})
export class ActivateAccountComponent implements OnInit {
  activateForm: FormGroup;
  errorMessage: string = '';
  successMessage: string = '';
  loading: boolean = false;

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router,
    private route: ActivatedRoute
  ) {
    this.activateForm = this.fb.group({
      token: ['', [Validators.required, Validators.pattern(/^\d{6}$/)]]
    });
  }

  ngOnInit(): void {
    // Vérifier si un token est passé en paramètre
    this.route.queryParams.subscribe(params => {
      if (params['token']) {
        this.activateForm.patchValue({ token: params['token'] });
        this.onSubmit();
      }
    });
  }

  onSubmit(): void {
    if (this.activateForm.valid) {
      this.loading = true;
      this.errorMessage = '';
      this.successMessage = '';
      
      const token = this.activateForm.value.token;
      
      this.authService.activateAccount(token).subscribe({
        next: () => {
          this.loading = false;
          this.successMessage = 'Compte activé avec succès! Redirection vers la page de connexion...';
          setTimeout(() => {
            this.router.navigate(['/login']);
          }, 2000);
        },
        error: (error) => {
          this.loading = false;
          this.errorMessage = 'Token invalide ou expiré. Veuillez vérifier votre email.';
          console.error('Activation error:', error);
        }
      });
    }
  }
}
