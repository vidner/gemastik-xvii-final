import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { KVService } from 'src/kv/kv.service';
@Module({
  imports: [],
  controllers: [AuthController],
  providers: [AuthService, KVService],
})
export class AuthModule {}
