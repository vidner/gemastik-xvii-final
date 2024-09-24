import { Module } from '@nestjs/common';
import { ViewController } from './view.controller';

@Module({
  imports: [],
  controllers: [ViewController],
  providers: [],
})
export class ViewModule {}
