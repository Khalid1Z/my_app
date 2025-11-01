import { Injectable } from '@nestjs/common';
import { Prisma, User } from '@prisma/client';

import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  findByEmail(email: string) {
    return this.prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      include: {
        wallet: true,
        proProfile: true,
      },
    });
  }

  findById(id: string) {
    return this.prisma.user.findUnique({
      where: { id },
      include: {
        wallet: true,
        proProfile: true,
      },
    });
  }

  create(data: Prisma.UserCreateInput) {
    return this.prisma.user.create({
      data,
      include: {
        wallet: true,
        proProfile: true,
      },
    });
  }

  sanitize(user: User & { passwordHash?: string } & Record<string, any>) {
    if (!user) {
      return user;
    }
    const { passwordHash, ...rest } = user;
    const wallet = rest.wallet
      ? {
          ...rest.wallet,
          balance:
            rest.wallet.balance && typeof rest.wallet.balance === "object" && "toString" in rest.wallet.balance
              ? rest.wallet.balance.toString()
              : rest.wallet.balance,
        }
      : rest.wallet;

    return {
      ...rest,
      wallet,
    };
  }

}





