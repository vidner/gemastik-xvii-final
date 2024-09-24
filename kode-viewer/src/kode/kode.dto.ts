import { IsNotEmpty, MaxLength } from 'class-validator';

export class KodeDTO {
  @IsNotEmpty()
  @MaxLength(128)
  name: string;

  @IsNotEmpty()
  @MaxLength(4096)
  kode: string;

  kind?: string;

  @IsNotEmpty()
  lang: string;
}

export class SearchKodeDTO {
  @IsNotEmpty()
  pattern: string;
}
