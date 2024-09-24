import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
  ForbiddenException,
} from '@nestjs/common';
import { AuthService } from './auth.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private authService: AuthService) {}
  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const session = request.cookies['session'];
    if (!session) {
      throw new UnauthorizedException();
    }

    const user = await this.authService.getUser(session);
    if (!user) {
      throw new UnauthorizedException();
    }

    request.user = user;

    return true;
  }
}
