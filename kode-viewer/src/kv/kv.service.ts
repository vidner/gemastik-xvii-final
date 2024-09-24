import { Injectable } from '@nestjs/common';
import { Redis } from 'ioredis';

@Injectable()
export class KVService {
  private readonly redisClient: Redis;

  constructor() {
    this.redisClient = new Redis(
      `redis://${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`,
    );
  }

  async find(pattern: string): Promise<string[]> {
    return this.redisClient.keys(pattern);
  }

  async get(key: string): Promise<any> {
    return JSON.parse(await this.redisClient.get(key));
  }

  async set(key: string, value: any, ttl: number = 0): Promise<void> {
    value = JSON.stringify(value);

    await this.redisClient.set(key, value);

    if (ttl) {
      await this.redisClient.expire(key, ttl);
    }
  }

  async del(key: string): Promise<void> {
    await this.redisClient.del(key);
  }
}
