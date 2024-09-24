import {
  Controller,
  Post,
  Body,
  UseGuards,
  Req,
  Render,
  Get,
  Param,
  Res,
  Query,
} from '@nestjs/common';
import { KodeService } from './kode.service';
import { KodeDTO, SearchKodeDTO } from './kode.dto';
import { AuthGuard } from 'src/auth/auth.guard';

@Controller('kode')
export class KodeController {
  constructor(private readonly kodeService: KodeService) {}

  @Post()
  @UseGuards(AuthGuard)
  async create(@Req() req, @Res() res, @Body() dto: KodeDTO) {
    await this.kodeService.create(req.user.email, dto);
    res.redirect('/kode');
  }

  @Get()
  @UseGuards(AuthGuard)
  async list(@Req() req, @Res() res, @Query() query) {
    const kodes = query.pattern
      ? await this.kodeService.find(query.pattern)
      : await this.kodeService.list(req.user);
    return res.render('search', { kodes });
  }

  @Get('create')
  @UseGuards(AuthGuard)
  @Render('create')
  async createPage() {}

  @Post('find')
  @UseGuards(AuthGuard)
  async find(@Res() res, @Body() dto: SearchKodeDTO) {
    return res.redirect(`/kode?pattern=${dto.pattern}`);
  }

  @Get(':id')
  @UseGuards(AuthGuard)
  async get(@Res() res, @Param() params) {
    const kode = await this.kodeService.show(params.id);
    return kode
      ? res.render('kode', { kode })
      : res.redirect(`/error?message=Kode Not Found`);
  }
}
