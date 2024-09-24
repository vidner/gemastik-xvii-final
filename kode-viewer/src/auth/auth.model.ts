export class User {
  email: string;
  hashedPassword: string;
  isAdmin: boolean;
}

export class Session {
  email: string;
  isAdmin: boolean;
}
