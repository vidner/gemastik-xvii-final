import { Module } from '@nestjs/common';
import { KodeController } from './kode.controller';
import { KodeService } from './kode.service';
import { KVService } from 'src/kv/kv.service';
import { AuthService } from 'src/auth/auth.service';

@Module({
  imports: [],
  controllers: [KodeController],
  providers: [AuthService, KodeService, KVService],
})
export class KodeModule {}
