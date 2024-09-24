import {
  Controller,
  Render,
  Get,
  Post,
  Body,
  Res,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthDTO } from './auth.dto';
import { AuthGuard } from './auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('login')
  @Render('login')
  async loginPage() {}

  @Post('login')
  async login(@Res({ passthrough: true }) res, @Body() dto: AuthDTO) {
    const { sessionId } = await this.authService.login(dto);
    if (sessionId) {
      res.cookie('session', sessionId, { httpOnly: true });
    }
    return res.redirect('/kode');
  }

  @Get('register')
  @Render('register')
  async registerPage() {}

  @Post('register')
  async register(@Res() res, @Body() dto: AuthDTO) {
    await this.authService.register(dto);
    return res.redirect('/auth/login');
  }

  @Get('logout')
  @UseGuards(AuthGuard)
  async logout(@Res() res) {
    const sessionId = res.req.cookies['session'];
    res.clearCookie('session');
    await this.authService.logout(sessionId);
    return res.redirect('/auth/login');
  }
}
