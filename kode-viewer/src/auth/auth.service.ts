import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';

import { KVService } from 'src/kv/kv.service';
import { AuthDTO } from './auth.dto';
import { User } from './auth.model';

@Injectable()
export class AuthService {
  constructor(private kv: KVService) {}

  async login(payload: AuthDTO) {
    const user: User = await this.kv.get(payload.email);
    if (!user) {
      return { message: 'User not found', sessionId: null };
    }

    if (!(await bcrypt.compare(payload.password, user.hashedPassword))) {
      return { message: 'Invalid password', sessionId: null };
    }

    delete user.hashedPassword;

    const sessionId = uuidv4();
    await this.kv.set(sessionId, user, 1800);

    return { message: 'Login successful', sessionId };
  }

  async register(payload: AuthDTO) {
    const userExists = await this.kv.get(payload.email);
    if (userExists) {
      return { message: 'User already exists' };
    }

    const hashedPassword = await bcrypt.hash(payload.password, 10);
    const data = { email: payload.email, hashedPassword, isAdmin: false };
    await this.kv.set(payload.email, data, 0);
    return { message: 'User registered' };
  }

  async logout(sessionId: string) {
    await this.kv.del(sessionId);
    return { message: 'Logged out' };
  }

  async getUser(sessionId: string) {
    return this.kv.get(sessionId);
  }
}
