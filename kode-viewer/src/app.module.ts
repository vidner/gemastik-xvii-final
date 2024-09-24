import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { KodeModule } from './kode/kode.module';
import { ViewModule } from './view/view.module';

@Module({
  imports: [AuthModule, KodeModule, ViewModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
