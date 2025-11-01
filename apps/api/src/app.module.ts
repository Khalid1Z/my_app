import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { CatalogModule } from './modules/catalog/catalog.module';
import { ProsModule } from './modules/pros/pros.module';
import { AvailabilityModule } from './modules/availability/availability.module';
import { BookingsModule } from './modules/bookings/bookings.module';
import { WalletModule } from './modules/wallet/wallet.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { ReviewsModule } from './modules/reviews/reviews.module';
import { TicketsModule } from './modules/tickets/tickets.module';
import { KycModule } from './modules/kyc/kyc.module';
import { FilesModule } from './modules/files/files.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { AdminModule } from './modules/admin/admin.module';
import { HealthModule } from './modules/health/health.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [
    PrismaModule,
    AuthModule,
    UsersModule,
    CatalogModule,
    ProsModule,
    AvailabilityModule,
    BookingsModule,
    WalletModule,
    PaymentsModule,
    ReviewsModule,
    TicketsModule,
    KycModule,
    FilesModule,
    NotificationsModule,
    AdminModule,
    HealthModule,
  ],
})
export class AppModule {}
