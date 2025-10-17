import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/bookings/models/booking.dart';
import 'package:my_app/bookings/providers.dart';
import 'package:my_app/pros/models/pro.dart';
import 'package:my_app/pros/providers.dart';
import 'package:my_app/services/models/service.dart';
import 'package:my_app/services/providers.dart';
import 'package:my_app/ui/ui.dart';
import 'package:my_app/wallet/models/wallet.dart';
import 'package:my_app/wallet/providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final AppRouter _appRouter = AppRouter();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Service Flow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _appRouter.router,
    );
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter()
    : router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: '/home',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) =>
                AppNavigationShell(navigationShell: navigationShell),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/home',
                    name: HomePage.routeName,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: HomePage()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/services',
                    name: ServicesPage.routeName,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: ServicesPage()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/bookings',
                    name: BookingsPage.routeName,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: BookingsPage()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/wallet',
                    name: WalletPage.routeName,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: WalletPage()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/profile',
                    name: ProfilePage.routeName,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: ProfilePage()),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/services/details/:id',
            name: ServiceDetailsPage.routeName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return ServiceDetailsPage(serviceId: id);
            },
          ),
          GoRoute(
            path: '/services/pros/:serviceId',
            name: ProListPage.routeName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final serviceId = state.pathParameters['serviceId'] ?? '';
              return ProListPage(serviceId: serviceId);
            },
          ),
          GoRoute(
            path: '/services/slot-picker/:serviceId/:proId',
            name: SlotPickerPage.routeName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final serviceId = state.pathParameters['serviceId'] ?? '';
              final proId = state.pathParameters['proId'] ?? '';
              return SlotPickerPage(serviceId: serviceId, proId: proId);
            },
          ),
          GoRoute(
            path: '/checkout',
            name: CheckoutPage.routeName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final params = state.uri.queryParameters;
              return CheckoutPage(
                serviceId: params['serviceId'] ?? '',
                proId: params['proId'] ?? '',
                slotIso: params['slot'],
              );
            },
          ),
          GoRoute(
            path: '/bookings/details/:bookingId',
            name: BookingDetailsPage.routeName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final bookingId = state.pathParameters['bookingId'] ?? '';
              return BookingDetailsPage(bookingId: bookingId);
            },
          ),
          GoRoute(
            path: '/kyc',
            name: KycPage.routeName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const KycPage(),
          ),
          GoRoute(
            path: '/admin-approval',
            name: AdminApprovalPendingPage.routeName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const AdminApprovalPendingPage(),
          ),
        ],
      );
  final GoRouter router;
}

class AppNavigationShell extends StatelessWidget {
  const AppNavigationShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.design_services_outlined),
            selectedIcon: Icon(Icons.design_services),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = 'home';
  @override
  Widget build(BuildContext context) {
    return _PageShowcase(
      title: 'Home',
      description: 'Overview of activity, recommendations, and quick actions.',
      icon: Icons.home,
      children: [
        AppCard(
          title: 'Quick Booking',
          subtitle: 'Showcase primary and ghost button styles.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Use the primary button for the main action and the ghost variant for secondary choices.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Book now',
                      expand: true,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: AppButton(
                      label: 'See options',
                      variant: AppButtonVariant.ghost,
                      expand: true,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AppCard(
          title: 'Featured Professional',
          subtitle: 'Ready to accept bookings today.',
          trailing: const PillTag(label: 'New'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AvatarWithBadge(initials: 'RM', isOnline: true),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rene Marshall',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.small / 2),
                    const RatingStars(rating: 4.8),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      'Specialist in all-inclusive home cleaning and organisation.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppCard(
          title: 'Upcoming Payment',
          subtitle: 'Here is how price rows align totals to the right.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PriceRow(
                label: 'Premium cleaning session',
                amount: '\$85.00',
              ),
              const SizedBox(height: AppSpacing.small),
              const PriceRow(label: 'Service fee', amount: '\$5.00'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.small),
                child: Divider(),
              ),
              PriceRow(
                label: 'Total due',
                amount: '\$90.00',
                trailing: Icon(
                  Icons.lock_clock,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});
  static const String routeName = 'services';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1200
        ? 4
        : width >= 900
        ? 3
        : width >= 650
        ? 2
        : 1;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.design_services,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Services',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.small),
                      Text(
                        'Browse available services. Navigate to details, pros, and scheduling.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            Expanded(
              child: servicesAsync.when(
                data: (services) {
                  if (services.isEmpty) {
                    return Center(
                      child: Text(
                        'No services available yet.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: services.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.medium,
                      mainAxisSpacing: AppSpacing.medium,
                      childAspectRatio: switch (crossAxisCount) {
                        1 => 1.4,
                        2 => 0.9,
                        _ => 0.7,
                      },
                    ),
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return _ServiceGridCard(
                        service: service,
                        onTap: () => context.goNamed(
                          ServiceDetailsPage.routeName,
                          pathParameters: {'id': service.id},
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Text(
                    'Unable to load services.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingsPage extends ConsumerWidget {
  const BookingsPage({super.key});
  static const String routeName = 'bookings';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingsProvider);
    final now = DateTime.now();
    final upcoming =
        bookings.where((booking) => booking.slot.isAfter(now)).toList()
          ..sort((a, b) => a.slot.compareTo(b.slot));
    final past =
        bookings.where((booking) => !booking.slot.isAfter(now)).toList()
          ..sort((a, b) => b.slot.compareTo(a.slot));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bookings',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          'Keep track of upcoming visits and review completed ones.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
              TabBar(
                labelStyle: Theme.of(context).textTheme.titleSmall,
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past'),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Expanded(
                child: TabBarView(
                  children: [
                    _BookingList(
                      bookings: upcoming,
                      emptyMessage: 'No upcoming bookings yet.',
                    ),
                    _BookingList(
                      bookings: past,
                      emptyMessage: 'Completed bookings will appear here.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  static const String routeName = 'wallet';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final walletNotifier = ref.read(walletProvider.notifier);
    final theme = Theme.of(context);
    final balanceText = '\$${wallet.balance.toStringAsFixed(2)}';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wallet', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      'Manage balance and review recent wallet activity.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          AppCard(
            title: 'Available balance',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  balanceText,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  'Updated ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.now(), alwaysUse24HourFormat: true)}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.medium),
                AppButton(
                  label: 'Top-up +100',
                  expand: true,
                  onPressed: () =>
                      walletNotifier.topUp(100, description: 'Manual top-up'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          AppCard(
            title: 'Recent transactions',
            child: wallet.transactions.isEmpty
                ? Text(
                    'No wallet activity yet.',
                    style: theme.textTheme.bodyMedium,
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: wallet.transactions.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: AppSpacing.large),
                    itemBuilder: (context, index) {
                      final txn = wallet.transactions[index];
                      final amountLabel =
                          '${txn.isCredit ? '+' : ''}\$${txn.amount.toStringAsFixed(2)}';
                      final timestamp = MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(txn.timestamp);
                      final time = MaterialLocalizations.of(context)
                          .formatTimeOfDay(
                            TimeOfDay.fromDateTime(txn.timestamp),
                            alwaysUse24HourFormat: true,
                          );
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            txn.isCredit
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: txn.isCredit
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                          ),
                          const SizedBox(width: AppSpacing.small),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  txn.description,
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: AppSpacing.small / 2),
                                Text(
                                  '$timestamp • $time',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            amountLabel,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: txn.isCredit
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.error,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const String routeName = 'profile';
  @override
  Widget build(BuildContext context) {
    return _PageShowcase(
      title: 'Profile',
      description:
          'Profile settings, KYC progress, and preferences will live on this tab.',
      icon: Icons.person,
      children: [
        AppCard(
          title: 'Account owner',
          child: Row(
            children: [
              const AvatarWithBadge(initials: 'AR', isOnline: true),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amelia Rogers',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.small / 2),
                    Text(
                      'Tap edit to update personal information.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              AppButton(
                label: 'Edit',
                variant: AppButtonVariant.ghost,
                onPressed: () {},
              ),
            ],
          ),
        ),
        AppCard(
          title: 'Verification',
          subtitle: 'Use pill tags to show status states.',
          child: Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: const [
              PillTag(label: 'Email verified'),
              PillTag(label: 'Phone verified'),
              PillTag(label: 'KYC pending'),
            ],
          ),
        ),
      ],
    );
  }
}

class ServiceDetailsPage extends ConsumerWidget {
  const ServiceDetailsPage({super.key, required this.serviceId});
  static const String routeName = 'serviceDetails';
  final String serviceId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(serviceByIdProvider(serviceId));
    return serviceAsync.when(
      data: (service) {
        if (service == null) {
          return const _ServiceDetailMessageView(
            title: 'Service',
            message: 'We could not find details for this service.',
          );
        }
        final textTheme = Theme.of(context).textTheme;
        final colorScheme = Theme.of(context).colorScheme;
        return Scaffold(
          appBar: AppBar(title: Text(service.title)),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    service.thumbUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.design_services,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PillTag(label: service.category),
                    const SizedBox(height: AppSpacing.small),
                    Text(service.title, style: textTheme.headlineSmall),
                    const SizedBox(height: AppSpacing.medium),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Text(
                          '${service.durationMin} min',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(width: AppSpacing.large),
                        Icon(
                          Icons.attach_money,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Text(
                          '\$${service.basePrice.toStringAsFixed(2)}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    const Divider(),
                    const SizedBox(height: AppSpacing.medium),
                    Text(
                      'Trusted professionals bring their own supplies, confirm details before arrival, and ensure the space is left spotless.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    AppButton(
                      label: 'Book this service',
                      expand: true,
                      onPressed: () {},
                    ),
                    const SizedBox(height: AppSpacing.small),
                    AppButton(
                      label: 'View professionals',
                      variant: AppButtonVariant.ghost,
                      expand: true,
                      onPressed: () => context.goNamed(
                        ProListPage.routeName,
                        pathParameters: {'serviceId': service.id},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Service')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => const _ServiceDetailMessageView(
        title: 'Service',
        message: 'Unable to load service details.',
      ),
    );
  }
}

class ProListPage extends StatelessWidget {
  const ProListPage({super.key, required this.serviceId});
  static const String routeName = 'proList';
  final String serviceId;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final servicesAsync = ref.watch(servicesProvider);
        return servicesAsync.when(
          data: (services) {
            final serviceMap = {for (final s in services) s.id: s};
            final selectedService = serviceMap[serviceId];
            final prosAsync = ref.watch(prosForServiceProvider(serviceId));
            return Scaffold(
              appBar: AppBar(
                title: Text(selectedService?.title ?? 'Professionals'),
              ),
              body: prosAsync.when(
                data: (pros) {
                  if (pros.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.large),
                        child: Text(
                          'No professionals currently offer this service. Check back soon!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    itemCount: pros.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.medium),
                    itemBuilder: (context, index) {
                      final pro = pros[index];
                      final primarySkill = pro.skills.contains(serviceId)
                          ? serviceMap[serviceId]?.title
                          : null;
                      final additionalSkillNames = pro.skills
                          .where((skillId) => skillId != serviceId)
                          .map((skillId) => serviceMap[skillId]?.title)
                          .whereType<String>()
                          .toList();
                      final distanceKm = _mockDistanceForPro(pro.id, serviceId);
                      return _ProListItem(
                        pro: pro,
                        primarySkill: primarySkill,
                        additionalSkillNames: additionalSkillNames,
                        distanceKm: distanceKm,
                        onBook: serviceId.isEmpty
                            ? null
                            : () => context.goNamed(
                                SlotPickerPage.routeName,
                                pathParameters: {
                                  'serviceId': serviceId,
                                  'proId': pro.id,
                                },
                              ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.large),
                    child: Text(
                      'Unable to load professionals right now.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => Scaffold(
            appBar: AppBar(title: const Text('Professionals')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Text(
                  'Unable to load services right now.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SlotPickerPage extends ConsumerStatefulWidget {
  const SlotPickerPage({
    super.key,
    required this.serviceId,
    required this.proId,
  });
  static const String routeName = 'slotPicker';
  final String serviceId;
  final String proId;
  @override
  ConsumerState<SlotPickerPage> createState() => _SlotPickerPageState();
}

class _SlotPickerPageState extends ConsumerState<SlotPickerPage> {
  late DateTime _startDay;
  late DateTime _selectedDay;
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _startDay;
  }

  List<DateTime> get _days =>
      List.generate(7, (index) => _startDay.add(Duration(days: index)));
  List<DateTime> _slotsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day, 9);
    final end = DateTime(day.year, day.month, day.day, 19);
    final slots = <DateTime>[];
    var current = start;
    while (!current.isAfter(end)) {
      slots.add(current);
      current = current.add(const Duration(minutes: 30));
    }
    return slots;
  }

  void _goToCheckout({
    required Service service,
    required Pro pro,
    required DateTime slot,
  }) {
    final params = <String, String>{
      'serviceId': service.id,
      'proId': pro.id,
      'slot': slot.toIso8601String(),
    };
    if (!mounted) {
      return;
    }
    context.goNamed(CheckoutPage.routeName, queryParameters: params);
  }

  @override
  Widget build(BuildContext context) {
    final serviceAsync = widget.serviceId.isEmpty
        ? const AsyncValue<Service?>.data(null)
        : ref.watch(serviceByIdProvider(widget.serviceId));
    final proAsync = widget.proId.isEmpty
        ? const AsyncValue<Pro?>.data(null)
        : ref.watch(proByIdProvider(widget.proId));
    return serviceAsync.when(
      data: (service) {
        return proAsync.when(
          data: (pro) {
            if (service == null || pro == null) {
              return const _ServiceDetailMessageView(
                title: 'Select slot',
                message:
                    'We could not load the professional or service details. Please try again.',
              );
            }
            final localizations = MaterialLocalizations.of(context);
            final theme = Theme.of(context);
            final slots = _slotsForDay(_selectedDay);
            final now = DateTime.now();
            return Scaffold(
              appBar: AppBar(title: Text('Choose a slot for ${service.title}')),
              body: ListView(
                padding: const EdgeInsets.all(AppSpacing.medium),
                children: [
                  AppCard(
                    title: pro.name,
                    subtitle: service.title,
                    child: Row(
                      children: [
                        AvatarWithBadge(
                          image: pro.photoUrl.isNotEmpty
                              ? NetworkImage(pro.photoUrl)
                              : null,
                          initials: _initialsForName(pro.name),
                          isOnline: true,
                          size: 60,
                        ),
                        const SizedBox(width: AppSpacing.medium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  RatingStars(rating: pro.rating),
                                  const SizedBox(width: AppSpacing.small),
                                  Text(
                                    pro.rating.toStringAsFixed(1),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.small),
                              Text(
                                '${pro.baseLocation.lat.toStringAsFixed(2)}, ${pro.baseLocation.lng.toStringAsFixed(2)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Text('Select day', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.small),
                  SizedBox(
                    height: 96,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _days.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.small),
                      itemBuilder: (context, index) {
                        final day = _days[index];
                        final isSelected = DateUtils.isSameDay(
                          day,
                          _selectedDay,
                        );
                        const weekdayLabels = [
                          'MON',
                          'TUE',
                          'WED',
                          'THU',
                          'FRI',
                          'SAT',
                          'SUN',
                        ];
                        final weekday = weekdayLabels[(day.weekday - 1) % 7];
                        final formattedDate = localizations.formatShortDate(
                          day,
                        );
                        return ChoiceChip(
                          label: SizedBox(
                            width: 72,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  weekday,
                                  style: theme.textTheme.labelMedium,
                                ),
                                const SizedBox(height: AppSpacing.small / 2),
                                Text(
                                  formattedDate,
                                  style: theme.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedDay = day;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Text('Available times', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.small),
                  Wrap(
                    spacing: AppSpacing.small,
                    runSpacing: AppSpacing.small,
                    children: slots.map((slot) {
                      final timeLabel = localizations.formatTimeOfDay(
                        TimeOfDay.fromDateTime(slot),
                        alwaysUse24HourFormat: true,
                      );
                      final isPast = slot.isBefore(now);
                      return ChoiceChip(
                        label: Text(timeLabel),
                        selected: false,
                        onSelected: isPast
                            ? null
                            : (_) => _goToCheckout(
                                service: service,
                                pro: pro,
                                slot: slot,
                              ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => const _ServiceDetailMessageView(
            title: 'Select slot',
            message: 'Unable to load professional details.',
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => const _ServiceDetailMessageView(
        title: 'Select slot',
        message: 'Unable to load service details.',
      ),
    );
  }
}

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({
    super.key,
    required this.serviceId,
    required this.proId,
    required this.slotIso,
  });
  static const String routeName = 'checkout';
  final String serviceId;
  final String proId;
  final String? slotIso;
  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  PaymentMethod _paymentMethod = PaymentMethod.wallet;
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _confirmBooking({
    required Service service,
    required Pro pro,
    required DateTime slot,
  }) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final sameDay = DateUtils.isSameDay(slot, DateTime.now());
    final base = service.basePrice;
    final surcharge = sameDay ? base * 0.1 : 0.0;
    final total = base + surcharge;
    if (_paymentMethod == PaymentMethod.wallet) {
      ref.read(walletProvider.notifier).charge(
            total,
            description: 'Booking ${service.title}',
          );
    }
    final booking = Booking(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      serviceId: service.id,
      proId: pro.id,
      slot: slot,
      customerName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      paymentMethod: _paymentMethod,
      basePrice: base,
      surcharge: surcharge,
      total: total,
      status: BookingStatus.confirmed,
    );
    ref.read(bookingsProvider.notifier).addBooking(booking);
    FocusScope.of(context).unfocus();
    context.pushNamed(
      BookingDetailsPage.routeName,
      pathParameters: {'bookingId': booking.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final slot = widget.slotIso != null
        ? DateTime.tryParse(widget.slotIso!)
        : null;
    final serviceAsync = widget.serviceId.isEmpty
        ? const AsyncValue<Service?>.data(null)
        : ref.watch(serviceByIdProvider(widget.serviceId));
    final proAsync = widget.proId.isEmpty
        ? const AsyncValue<Pro?>.data(null)
        : ref.watch(proByIdProvider(widget.proId));
    return serviceAsync.when(
      data: (service) {
        return proAsync.when(
          data: (pro) {
            if (service == null || pro == null || slot == null) {
              return const _ServiceDetailMessageView(
                title: 'Checkout',
                message:
                    'Missing booking details. Please select a service, professional, and slot again.',
              );
            }
            final theme = Theme.of(context);
            final localizations = MaterialLocalizations.of(context);
            final slotLabel =
                '${localizations.formatMediumDate(slot)} • ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(slot), alwaysUse24HourFormat: true)}';
            final sameDay = DateUtils.isSameDay(slot, DateTime.now());
            final surcharge = sameDay ? service.basePrice * 0.1 : 0.0;
            final total = service.basePrice + surcharge;
            return Scaffold(
              appBar: AppBar(title: const Text('Checkout')),
              body: ListView(
                padding: const EdgeInsets.all(AppSpacing.medium),
                children: [
                  AppCard(
                    title: 'Contact & address',
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.small),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.small),
                          TextFormField(
                            controller: _streetController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Street address',
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.small),
                          TextFormField(
                            controller: _cityController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'City',
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppCard(
                    title: service.title,
                    subtitle: '${pro.name} · $slotLabel',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Duration: ${service.durationMin} min',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.small),
                        PriceRow(
                          label: 'Base price',
                          amount: '\$${service.basePrice.toStringAsFixed(2)}',
                        ),
                        if (surcharge > 0) ...[
                          const SizedBox(height: AppSpacing.small),
                          PriceRow(
                            label: 'Same-day surcharge (10%)',
                            amount: '\$${surcharge.toStringAsFixed(2)}',
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.small,
                          ),
                          child: Divider(),
                        ),
                        PriceRow(
                          label: 'Total due',
                          amount: '\$${total.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppCard(
                    title: 'Payment method',
                    child: SegmentedButton<PaymentMethod>(
                      segments: const [
                        ButtonSegment(
                          value: PaymentMethod.wallet,
                          icon: Icon(Icons.account_balance_wallet_outlined),
                          label: Text('Wallet'),
                        ),
                        ButtonSegment(
                          value: PaymentMethod.card,
                          icon: Icon(Icons.credit_card),
                          label: Text('Card'),
                        ),
                      ],
                      selected: {_paymentMethod},
                      onSelectionChanged: (selection) {
                        if (selection.isNotEmpty) {
                          setState(() => _paymentMethod = selection.first);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  AppButton(
                    label: 'Confirm booking',
                    expand: true,
                    onPressed: () =>
                        _confirmBooking(service: service, pro: pro, slot: slot),
                  ),
                ],
              ),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => const _ServiceDetailMessageView(
            title: 'Checkout',
            message: 'Unable to load professional details.',
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => const _ServiceDetailMessageView(
        title: 'Checkout',
        message: 'Unable to load service details.',
      ),
    );
  }
}

class BookingDetailsPage extends ConsumerStatefulWidget {
  const BookingDetailsPage({super.key, required this.bookingId});

  static const String routeName = 'bookingDetails';

  final String bookingId;

  @override
  ConsumerState<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends ConsumerState<BookingDetailsPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateStatus(BookingStatus status) {
    ref.read(bookingsProvider.notifier).updateStatus(widget.bookingId, status);
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingByIdProvider(widget.bookingId));
    if (booking == null) {
      return const _ServiceDetailMessageView(
        title: 'Booking details',
        message: 'We could not find this booking.',
      );
    }

    final serviceAsync = booking.serviceId.isEmpty
        ? const AsyncValue<Service?>.data(null)
        : ref.watch(serviceByIdProvider(booking.serviceId));
    final proAsync = booking.proId.isEmpty
        ? const AsyncValue<Pro?>.data(null)
        : ref.watch(proByIdProvider(booking.proId));

    return serviceAsync.when(
      data: (service) {
        return proAsync.when(
          data: (pro) {
            final theme = Theme.of(context);
            final localizations = MaterialLocalizations.of(context);
            final slotDate = localizations.formatMediumDate(booking.slot);
            final slotTime = localizations.formatTimeOfDay(
              TimeOfDay.fromDateTime(booking.slot),
              alwaysUse24HourFormat: true,
            );
            final slotLabel = '$slotDate • $slotTime';
            final serviceTitle =
                service?.title ?? 'Service ${booking.serviceId}';
            final proName = pro?.name ?? 'Professional ${booking.proId}';

            final now = DateTime.now();
            final arrivalWindow = booking.slot.difference(now);
            final showArrivalTag =
                booking.status == BookingStatus.confirmed &&
                !arrivalWindow.isNegative &&
                arrivalWindow <= const Duration(minutes: 30);

            final status = booking.status;
            final statusIndex = switch (status) {
              BookingStatus.confirmed => 0,
              BookingStatus.inProgress => 1,
              BookingStatus.completed => 2,
            };

            return Scaffold(
              appBar: AppBar(title: const Text('Booking details')),
              body: ListView(
                padding: const EdgeInsets.all(AppSpacing.medium),
                children: [
                  if (showArrivalTag)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.small),
                      child: PillTag(
                        label: 'Pro arriving in ~30 min',
                        icon: Icon(
                          Icons.directions_walk,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  AppCard(
                    title: serviceTitle,
                    subtitle: '$proName · $slotLabel',
                    trailing: PillTag(
                      label: _bookingStatusLabel(booking.status),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment method: ${_paymentMethodLabel(booking.paymentMethod)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppCard(
                    title: 'Status timeline',
                    child: Column(
                      children: [
                        _TimelineStep(
                          label: 'Scheduled',
                          description: 'Booking confirmed with $proName',
                          isCompleted: statusIndex >= 0,
                          isCurrent: statusIndex == 0,
                          showConnector: true,
                        ),
                        _TimelineStep(
                          label: 'In progress',
                          description: 'Professional currently on site',
                          isCompleted: statusIndex >= 1,
                          isCurrent: statusIndex == 1,
                          showConnector: true,
                        ),
                        _TimelineStep(
                          label: 'Completed',
                          description: 'Job finished and receipt issued',
                          isCompleted: statusIndex >= 2,
                          isCurrent: statusIndex == 2,
                          showConnector: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  if (status == BookingStatus.confirmed) ...[
                    AppButton(
                      label: 'Start job',
                      expand: true,
                      onPressed: () => _updateStatus(BookingStatus.inProgress),
                    ),
                    const SizedBox(height: AppSpacing.small),
                  ],
                  if (status != BookingStatus.completed)
                    AppButton(
                      label: 'Finish job',
                      variant: AppButtonVariant.ghost,
                      expand: true,
                      onPressed: () => _updateStatus(BookingStatus.completed),
                    ),
                  if (status != BookingStatus.completed)
                    const SizedBox(height: AppSpacing.medium),
                  AppCard(
                    title: 'Price summary',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PriceRow(
                          label: 'Base price',
                          amount: '\$${booking.basePrice.toStringAsFixed(2)}',
                        ),
                        if (booking.surcharge > 0) ...[
                          const SizedBox(height: AppSpacing.small),
                          PriceRow(
                            label: 'Same-day surcharge',
                            amount: '\$${booking.surcharge.toStringAsFixed(2)}',
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.small,
                          ),
                          child: Divider(),
                        ),
                        PriceRow(
                          label: status == BookingStatus.completed
                              ? 'Total paid'
                              : 'Total due',
                          amount: '\$${booking.total.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                  if (status == BookingStatus.completed) ...[
                    const SizedBox(height: AppSpacing.medium),
                    AppCard(
                      title: 'Receipt',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thanks for your business!',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.small),
                          Text(
                            'A payment receipt was sent to ${booking.customerName}.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.medium),
                  AppCard(
                    title: 'Contact & address',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.customerName,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.small / 2),
                        Text(booking.phone, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.small),
                        Text(booking.street, style: theme.textTheme.bodyMedium),
                        Text(booking.city, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => const _ServiceDetailMessageView(
            title: 'Booking details',
            message: 'Unable to load professional details.',
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => const _ServiceDetailMessageView(
        title: 'Booking details',
        message: 'Unable to load service details.',
      ),
    );
  }
}

class KycPage extends StatelessWidget {
  const KycPage({super.key});
  static const String routeName = 'kyc';
  @override
  Widget build(BuildContext context) {
    return _DetailShowcase(
      title: 'KYC',
      message:
          'Capture identity documents and verification steps when the flow is ready.',
      icon: Icons.verified_user_outlined,
      children: [
        AppCard(
          title: 'Verification progress',
          subtitle: 'Combine cards and tags to communicate status.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PillTag(label: 'ID check complete'),
              SizedBox(height: AppSpacing.small),
              PillTag(label: 'Address proof pending'),
            ],
          ),
        ),
        AppCard(
          title: 'Next step',
          child: AppButton(
            label: 'Upload documents',
            expand: true,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class AdminApprovalPendingPage extends StatelessWidget {
  const AdminApprovalPendingPage({super.key});
  static const String routeName = 'adminApprovalPending';
  @override
  Widget build(BuildContext context) {
    return _DetailShowcase(
      title: 'Admin Approval',
      message:
          'Display the current approval status while administrators review submissions.',
      icon: Icons.admin_panel_settings_outlined,
      children: [
        AppCard(
          title: 'Status update',
          trailing: const PillTag(label: 'Reviewing'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Use pill tags to highlight the current approval stage.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.medium),
              AppButton(
                label: 'Refresh status',
                variant: AppButtonVariant.ghost,
                expand: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PageShowcase extends StatelessWidget {
  const _PageShowcase({
    required this.title,
    required this.description,
    required this.icon,
    required this.children,
  });
  final String title;
  final String description;
  final IconData icon;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          ..._addVerticalSpacing(children),
        ],
      ),
    );
  }
}

class _DetailShowcase extends StatelessWidget {
  const _DetailShowcase({
    required this.title,
    required this.message,
    required this.icon,
    required this.children,
  });
  final String title;
  final String message;
  final IconData icon;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          ..._addVerticalSpacing(children),
        ],
      ),
    );
  }
}

class _ServiceGridCard extends StatelessWidget {
  const _ServiceGridCard({required this.service, required this.onTap});
  final Service service;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.network(
              service.thumbUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: colorScheme.primary.withValues(alpha: 0.1),
                alignment: Alignment.center,
                child: Icon(Icons.design_services, color: colorScheme.primary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  service.title,
                  style: textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.small / 2),
                Text(service.category, style: textTheme.bodySmall),
                const SizedBox(height: AppSpacing.small),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: colorScheme.primary),
                    const SizedBox(width: AppSpacing.small / 2),
                    Text(
                      '${service.durationMin} min',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.medium),
                PriceRow(
                  label: 'From',
                  amount: '\$${service.basePrice.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceDetailMessageView extends StatelessWidget {
  const _ServiceDetailMessageView({required this.title, required this.message});
  final String title;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.label,
    required this.description,
    required this.isCompleted,
    required this.isCurrent,
    required this.showConnector,
  });

  final String label;
  final String description;
  final bool isCompleted;
  final bool isCurrent;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = isCompleted || isCurrent
        ? colorScheme.primary
        : colorScheme.outlineVariant;
    final fillColor = isCompleted ? colorScheme.primary : Colors.transparent;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: fillColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
            ),
            if (showConnector)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                width: 2,
                height: 40,
                color: colorScheme.outlineVariant,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.small),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isCurrent ? colorScheme.primary : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.small / 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BookingList extends ConsumerWidget {
  const _BookingList({required this.bookings, required this.emptyMessage});
  final List<Booking> bookings;
  final String emptyMessage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.medium),
      itemBuilder: (context, index) =>
          _BookingListItem(booking: bookings[index]),
    );
  }
}

class _BookingListItem extends ConsumerWidget {
  const _BookingListItem({required this.booking});
  final Booking booking;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref
        .watch(serviceByIdProvider(booking.serviceId))
        .valueOrNull;
    final pro = ref.watch(proByIdProvider(booking.proId)).valueOrNull;
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);
    final slotLabel =
        '${localizations.formatMediumDate(booking.slot)} • ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(booking.slot), alwaysUse24HourFormat: true)}';
    final serviceTitle = service?.title ?? 'Service ${booking.serviceId}';
    final proName = pro?.name ?? 'Professional ${booking.proId}';
    final statusLabel = _bookingStatusLabel(booking.status);
    return AppCard(
      title: serviceTitle,
      subtitle: proName,
      trailing: PillTag(label: statusLabel),
      onTap: () => context.goNamed(
        BookingDetailsPage.routeName,
        pathParameters: {'bookingId': booking.id},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(slotLabel, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Paid via ${_paymentMethodLabel(booking.paymentMethod)}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.small),
          PriceRow(
            label: 'Total',
            amount: '\$${booking.total.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}

class _ProListItem extends StatelessWidget {
  const _ProListItem({
    required this.pro,
    required this.primarySkill,
    required this.additionalSkillNames,
    required this.distanceKm,
    required this.onBook,
  });
  final Pro pro;
  final String? primarySkill;
  final List<String> additionalSkillNames;
  final double distanceKm;
  final VoidCallback? onBook;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return AppCard(
      onTap: onBook,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarWithBadge(
            image: pro.photoUrl.isNotEmpty ? NetworkImage(pro.photoUrl) : null,
            initials: _initialsForName(pro.name),
            isOnline: true,
            size: 56,
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pro.name, style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.small / 2),
                Row(
                  children: [
                    RatingStars(rating: pro.rating),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      pro.rating.toStringAsFixed(1),
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      '${distanceKm.toStringAsFixed(1)} km away',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                if (primarySkill != null) ...[
                  const SizedBox(height: AppSpacing.small),
                  PillTag(label: primarySkill!),
                ],
                if (additionalSkillNames.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.small),
                  Wrap(
                    spacing: AppSpacing.small,
                    runSpacing: AppSpacing.small,
                    children: additionalSkillNames
                        .take(3)
                        .map((skill) => PillTag(label: skill))
                        .toList(),
                  ),
                ],
                const SizedBox(height: AppSpacing.small),
                Text(
                  'Base location: ${pro.baseLocation.lat.toStringAsFixed(2)}, '
                  '${pro.baseLocation.lng.toStringAsFixed(2)}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          AppButton(
            label: 'Book',
            variant: AppButtonVariant.ghost,
            onPressed: onBook,
          ),
        ],
      ),
    );
  }
}

List<Widget> _addVerticalSpacing(
  List<Widget> children, {
  double spacing = AppSpacing.medium,
}) {
  if (children.isEmpty) {
    return const <Widget>[];
  }
  final spaced = <Widget>[];
  for (var i = 0; i < children.length; i += 1) {
    spaced.add(children[i]);
    if (i < children.length - 1) {
      spaced.add(SizedBox(height: spacing));
    }
  }
  return spaced;
}

String _paymentMethodLabel(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.wallet:
      return 'Wallet';
    case PaymentMethod.card:
      return 'Card';
  }
}

String _bookingStatusLabel(BookingStatus status) {
  switch (status) {
    case BookingStatus.confirmed:
      return 'Confirmed';
    case BookingStatus.inProgress:
      return 'In progress';
    case BookingStatus.completed:
      return 'Completed';
  }
}

double _mockDistanceForPro(String proId, String serviceId) {
  final hash = proId.hashCode ^ serviceId.hashCode;
  final normalized = (hash.abs() % 800) / 100.0; // 0.0 - 7.99
  return 2 + normalized;
}

String _initialsForName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) {
    return '--';
  }
  final parts = trimmed.split(RegExp(r'\s+'));
  if (parts.length == 1) {
    final word = parts.first;
    return word.substring(0, word.length >= 2 ? 2 : 1).toUpperCase();
  }
  final first = parts.first;
  final last = parts.last;
  final firstInitial = first.isNotEmpty ? first[0] : '';
  final lastInitial = last.isNotEmpty ? last[0] : '';
  final initials = '$firstInitial$lastInitial'.toUpperCase();
  return initials.isEmpty ? '--' : initials;
}
