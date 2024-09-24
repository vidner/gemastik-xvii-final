import { Controller, Get, Render, Query, Res } from '@nestjs/common';

@Controller()
export class ViewController {
  constructor() {}

  @Get()
  @Render('index')
  async indexPage() {}

  @Get('error')
  async errorPage(@Res() res, @Query('message') message: string) {
    return res.render('error', { message });
  }
}

