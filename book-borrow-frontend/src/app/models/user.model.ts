export interface User {
  id: number;
  firstname: string;
  lastname: string;
  email: string;
  accountLocked: boolean;
  enabled: boolean;
  dateOfBirth?: Date;
  createdDate: Date;
  lastModifiedDate?: Date;
}

export interface RegistrationRequest {
  firstname: string;
  lastname: string;
  email: string;
  password: string;
}

export interface AuthenticationRequest {
  email: string;
  password: string;
}

export interface AuthenticationResponse {
  token: string;
}
