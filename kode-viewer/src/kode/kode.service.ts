import { Injectable } from '@nestjs/common';

import { Session } from 'src/auth/auth.model';
import { KVService } from 'src/kv/kv.service';
import { KodeDTO } from './kode.dto';

@Injectable()
export class KodeService {
  constructor(private kv: KVService) {}

  async create(email: string, payload: KodeDTO) {
    payload.kind = payload.kind ? 'private' : 'public';
    const key = `kode-${email}-${payload.name}-${payload.lang}-${payload.kind}`;
    return this.kv.set(key, { email, ...payload }, 1200);
  }

  async list(user: Session) {
    const kodes = user.isAdmin
      ? await this.kv.find('kode-*')
      : await this.kv.find(`kode-${user.email}-*`);
    return this.parse(kodes);
  }

  async show(key) {
    return this.kv.get(key);
  }

  async find(pattern: string) {
    const kodes = await this.kv.find(`*${pattern}*-public`);
    return this.parse(kodes);
  }

  parse(keys: string[]) {
    return keys.map((key) => {
      const [_, email, name, lang, kind] = key.split('-');
      return { id: key, email, name, lang, kind };
    });
  }
}
