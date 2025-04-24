import { Component } from '@angular/core';
import { AuthenticationRequest } from '../../services/models';
import { AuthenticationService } from '../../services/services';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: false,
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent {
[x: string]: any;
  authRequest: AuthenticationRequest = {email: '', password: ''};
  errorMsg: Array<string> = [];

  constructor(
    private router: Router,
    private authService: AuthenticationService,
  ){}

  login(): void {
    this.errorMsg = [];
    this.authService.authenticate({
      body: this.authRequest
    }).subscribe({
      next: (res: any) => {
        //save the token 
        this.router.navigate(['books']);
      }
    })

  }

  register(): void {
    this.router.navigate(['/register']);
    
  }

}
function next(error: any): void {
  throw new Error('Function not implemented.');
}

