import { ConflictException, Injectable, UnauthorizedException } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { Prisma, UserRole } from "@prisma/client";
import * as bcrypt from "bcrypt";

import { PrismaService } from "../../prisma/prisma.service";
import { UsersService } from "../users/users.service";
import { LoginDto } from "./dto/login.dto";
import { RegisterDto } from "./dto/register.dto";

interface AuthResult {
  accessToken: string;
  user: Record<string, unknown>;
}

@Injectable()
export class AuthService {
  private readonly saltRounds = 12;

  constructor(
    private readonly prisma: PrismaService,
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto): Promise<AuthResult> {
    const existing = await this.usersService.findByEmail(dto.email.toLowerCase());
    if (existing) {
      throw new ConflictException("Email already in use");
    }

    const passwordHash = await bcrypt.hash(dto.password, this.saltRounds);

    const user = await this.prisma.user.create({
      data: {
        name: dto.name ?? null,
        email: dto.email.toLowerCase(),
        phone: dto.phone ?? null,
        passwordHash,
        role: UserRole.USER,
        wallet: {
          create: {},
        },
      },
      include: {
        wallet: true,
        proProfile: true,
      },
    });

    return this.buildAuthResult(user);
  }

  async login(dto: LoginDto): Promise<AuthResult> {
    const user = await this.usersService.findByEmail(dto.email.toLowerCase());
    if (!user) {
      throw new UnauthorizedException("Invalid credentials");
    }

    const passwordMatch = await bcrypt.compare(dto.password, user.passwordHash);
    if (!passwordMatch) {
      throw new UnauthorizedException("Invalid credentials");
    }

    return this.buildAuthResult(user);
  }

  async getCurrentUser(userId: string) {
    const user = await this.usersService.findById(userId);
    if (!user) {
      throw new UnauthorizedException();
    }
    return this.usersService.sanitize(user);
  }

  private async buildAuthResult(user: Prisma.UserGetPayload<{ include: { wallet: true; proProfile: true } }>): Promise<AuthResult> {
    const sanitized = this.usersService.sanitize(user as any) as Record<string, unknown> & { id: string; role: UserRole };
    const accessToken = await this.jwtService.signAsync({
      sub: sanitized.id as string,
      role: sanitized.role,
    });
    return {
      accessToken,
      user: sanitized,
    };
  }

}


