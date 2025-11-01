import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key, this.navigationShell});

  final StatefulNavigationShell? navigationShell;

  static const _destinations = <_BottomNavDestination>[
    _BottomNavDestination(
      location: '/home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    _BottomNavDestination(
      location: '/services',
      icon: Icons.design_services_outlined,
      selectedIcon: Icons.design_services,
      label: 'Services',
    ),
    _BottomNavDestination(
      location: '/bookings',
      icon: Icons.event_note_outlined,
      selectedIcon: Icons.event_note,
      label: 'Bookings',
    ),
    _BottomNavDestination(
      location: '/wallet',
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet,
      label: 'Wallet',
    ),
    _BottomNavDestination(
      location: '/profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  int _locationToIndex(String location) {
    for (var i = 0; i < _destinations.length; i++) {
      final target = _destinations[i].location;
      if (location == target || location.startsWith('/')) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final location = GoRouterState.of(context).uri.toString();
    final index = navigationShell?.currentIndex ?? _locationToIndex(location);

    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (selected) {
        if (navigationShell != null) {
          navigationShell!.goBranch(
            selected,
            initialLocation: selected == navigationShell!.currentIndex,
          );
          return;
        }
        final target = _destinations[selected].location;
        final currentLocation = GoRouterState.of(context).uri.toString();
        if (currentLocation != target) {
          router.go(target);
        }
      },
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
    );
  }
}

class _BottomNavDestination {
  const _BottomNavDestination({
    required this.location,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final String location;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
