import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { NestExpressApplication } from '@nestjs/platform-express';

import { join } from 'path';
import * as cookieParser from 'cookie-parser';
import * as hbs from 'hbs';

import { AppModule } from './app.module';
import { AuthFilter } from './auth/auth.filter';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.useStaticAssets(join(__dirname, '..', 'public'));
  app.setBaseViewsDir(join(__dirname, '..', 'views'));
  hbs.registerPartials(join(__dirname, '..', 'views/partials'));
  app.setViewEngine('hbs');

  app.useGlobalPipes(new ValidationPipe());
  app.useGlobalFilters(new AuthFilter());
  app.use(cookieParser());

  await app.listen(3000);
}
bootstrap();
