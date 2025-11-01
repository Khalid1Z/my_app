import { PrismaClient, Prisma, UserRole, WalletTransactionType } from "@prisma/client";

const prisma = new PrismaClient();

const catalogSeed = [
  {
    name: "Beauty",
    services: [
      { title: "Waxing - Full Legs", durationMin: 90, basePrice: "65.00" },
      { title: "Facial Glow Treatment", durationMin: 60, basePrice: "80.00" },
      { title: "Relax Massage", durationMin: 75, basePrice: "70.00" },
    ],
  },
  {
    name: "Hair",
    services: [
      { title: "Keratin Treatment", durationMin: 120, basePrice: "150.00" },
      { title: "Creative Haircut", durationMin: 60, basePrice: "55.00" },
      { title: "Event Styling", durationMin: 90, basePrice: "95.00" },
    ],
  },
  {
    name: "Professional",
    services: [
      { title: "Salon Audit", durationMin: 180, basePrice: "220.00" },
      { title: "Brand Photoshoot", durationMin: 150, basePrice: "180.00" },
      { title: "Finance Coaching", durationMin: 120, basePrice: "160.00" },
    ],
  },
];

async function main() {
  await prisma.$transaction([
    prisma.review.deleteMany(),
    prisma.ticket.deleteMany(),
    prisma.availabilitySlot.deleteMany(),
    prisma.booking.deleteMany(),
    prisma.walletTransaction.deleteMany(),
    prisma.walletAccount.deleteMany(),
    prisma.proSkill.deleteMany(),
    prisma.proProfile.deleteMany(),
    prisma.kycDocument.deleteMany(),
    prisma.service.deleteMany(),
    prisma.serviceCategory.deleteMany(),
    prisma.user.deleteMany(),
  ]);

  const servicesByTitle: Record<string, string> = {};

  for (const category of catalogSeed) {
    const createdCategory = await prisma.serviceCategory.create({
      data: {
        name: category.name,
        services: {
          create: category.services.map((svc) => ({
            title: svc.title,
            durationMin: svc.durationMin,
            basePrice: new Prisma.Decimal(svc.basePrice),
          })),
        },
      },
      include: { services: true },
    });

    createdCategory.services.forEach((svc) => {
      servicesByTitle[svc.title] = svc.id;
    });
  }

  const client = await prisma.user.create({
    data: {
      name: "Amelia Client",
      email: "client@example.com",
      phone: "+212600000001",
      passwordHash: "hashed-client-password",
      role: UserRole.USER,
    },
  });

  const proUser = await prisma.user.create({
    data: {
      name: "Nadia Pro",
      email: "pro@example.com",
      phone: "+212600000002",
      passwordHash: "hashed-pro-password",
      role: UserRole.PRO,
    },
  });

  await prisma.user.create({
    data: {
      name: "Admin User",
      email: "admin@example.com",
      phone: "+212600000003",
      passwordHash: "hashed-admin-password",
      role: UserRole.ADMIN,
    },
  });

  await prisma.walletAccount.create({
    data: {
      userId: client.id,
      balance: new Prisma.Decimal("120.00"),
      transactions: {
        create: [
          {
            type: WalletTransactionType.TOPUP,
            amount: new Prisma.Decimal("120.00"),
          },
        ],
      },
    },
  });

  const proProfile = await prisma.proProfile.create({
    data: {
      userId: proUser.id,
      bio: "Certified esthetician and stylist serving Casablanca.",
      baseLat: 33.589886,
      baseLng: -7.603869,
      approvedAt: new Date(),
    },
  });

  const skillTitles = [
    "Waxing - Full Legs",
    "Facial Glow Treatment",
    "Relax Massage",
    "Keratin Treatment",
  ];

  await prisma.proSkill.createMany({
    data: skillTitles.map((title) => ({
      proId: proProfile.id,
      serviceId: servicesByTitle[title],
    })),
  });

  const availabilitySlots: { proId: string; start: Date; end: Date; isOpen: boolean }[] = [];
  const baseDate = new Date();
  baseDate.setHours(9, 0, 0, 0);

  for (let offset = 0; offset < 7; offset++) {
    for (const startHour of [9, 11, 14, 16]) {
      const start = new Date(baseDate);
      start.setDate(baseDate.getDate() + offset);
      start.setHours(startHour, 0, 0, 0);
      const end = new Date(start);
      end.setHours(startHour + 1);
      end.setMinutes(30);

      availabilitySlots.push({
        proId: proProfile.id,
        start,
        end,
        isOpen: true,
      });
    }
  }

  await prisma.availabilitySlot.createMany({ data: availabilitySlots });

  console.log("Database seeded with demo data.");
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
