import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/pros/models/pro.dart';
import 'package:my_app/pros/providers.dart';
import 'package:my_app/services/models/service.dart';
import 'package:my_app/services/providers.dart';
import 'package:my_app/ui/ui.dart';

class BookingLauncherSheet extends ConsumerWidget {
  const BookingLauncherSheet({super.key, required this.rootContext});

  final BuildContext rootContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Plan a visit', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Follow the path that matches your client: explore services, pick a professional, or reserve the next premium slot.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.medium),
            _LauncherTile(
              icon: Icons.design_services_outlined,
              title: 'Explore services',
              subtitle:
                  'Browse curated categories before choosing a professional.',
              onTap: () {
                Navigator.of(context).pop();
                rootContext.goNamed('services');
              },
            ),
            _LauncherTile(
              icon: Icons.badge_outlined,
              title: 'Choose a professional',
              subtitle: 'Filter by rating, location, and service category.',
              onTap: () {
                Navigator.of(context).pop();
                rootContext.goNamed(ProDirectoryPage.routeName);
              },
            ),
            _LauncherTile(
              icon: Icons.flash_on_outlined,
              title: 'Express booking',
              subtitle:
                  'Reserve one of the next available premium slots in two taps.',
              onTap: () {
                Navigator.of(context).pop();
                showModalBottomSheet<void>(
                  context: rootContext,
                  isScrollControlled: true,
                  builder: (_) => ExpressBookingSheet(rootContext: rootContext),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LauncherTile extends StatelessWidget {
  const _LauncherTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class ExpressBookingSheet extends ConsumerWidget {
  const ExpressBookingSheet({super.key, required this.rootContext});

  final BuildContext rootContext;

  List<_ExpressOption> _buildOptions(List<Service> services, List<Pro> pros) {
    final serviceMap = {for (final service in services) service.id: service};
    final options = <_ExpressOption>[];
    final now = DateTime.now();
    for (final pro in pros) {
      for (final skill in pro.skills) {
        final service = serviceMap[skill];
        if (service == null) {
          continue;
        }
        final slot = DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
        ).add(Duration(minutes: 120 + options.length * 45));
        options.add(_ExpressOption(service: service, pro: pro, slot: slot));
        if (options.length >= 4) {
          return options;
        }
      }
      if (options.length >= 4) {
        break;
      }
    }
    return options;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final prosAsync = ref.watch(allProsProvider);
    final theme = Theme.of(context);
    return SafeArea(
      child: servicesAsync.when(
        data: (services) {
          return prosAsync.when(
            data: (pros) {
              final options = _buildOptions(services, pros);
              if (options.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  child: Text(
                    'No instant slots are available right now. Try another path or adjust availability.',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(AppSpacing.medium),
                itemCount: options.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.small),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final dateLabel = MaterialLocalizations.of(
                    context,
                  ).formatMediumDate(option.slot);
                  final timeLabel = MaterialLocalizations.of(context)
                      .formatTimeOfDay(
                        TimeOfDay.fromDateTime(option.slot),
                        alwaysUse24HourFormat: true,
                      );
                  return AppCard(
                    title: option.service.title,
                    subtitle: '${option.pro.name} - $dateLabel at $timeLabel',
                    trailing: PillTag(
                      label: '\$${option.service.basePrice.toStringAsFixed(0)}',
                    ),
                    child: AppButton(
                      label: 'Reserve',
                      expand: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                        rootContext.goNamed(
                          'checkout',
                          queryParameters: {
                            'serviceId': option.service.id,
                            'proId': option.pro.id,
                            'slot': option.slot.toIso8601String(),
                            'express': 'true',
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.medium),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Text(
                'Unable to fetch professionals for express booking right now.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.medium),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Text(
            'Unable to load services for express booking right now.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _ExpressOption {
  const _ExpressOption({
    required this.service,
    required this.pro,
    required this.slot,
  });

  final Service service;
  final Pro pro;
  final DateTime slot;
}

double _mockDistanceForPro(String proId, String serviceId) {
  final hash = proId.hashCode ^ serviceId.hashCode;
  final normalized = (hash.abs() % 800) / 100.0;
  return 2 + normalized;
}

class ProDirectoryPage extends ConsumerStatefulWidget {
  const ProDirectoryPage({super.key});

  static const String routeName = 'proDirectory';

  @override
  ConsumerState<ProDirectoryPage> createState() => _ProDirectoryPageState();
}

class _ProDirectoryPageState extends ConsumerState<ProDirectoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider);
    final prosAsync = ref.watch(allProsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a professional'),
        actions: [
          IconButton(
            tooltip: 'Clear filters',
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedCategory = null;
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: servicesAsync.when(
        data: (services) {
          final serviceMap = {
            for (final service in services) service.id: service,
          };
          final categories =
              services
                  .map((service) => service.category)
                  .where((category) => category.isNotEmpty)
                  .toSet()
                  .toList()
                ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
          return prosAsync.when(
            data: (pros) {
              final query = _searchController.text.trim().toLowerCase();
              final filtered = pros.where((pro) {
                final matchesQuery =
                    query.isEmpty || pro.name.toLowerCase().contains(query);
                final matchesCategory =
                    _selectedCategory == null ||
                    pro.skills.any(
                      (skillId) =>
                          serviceMap[skillId]?.category == _selectedCategory,
                    );
                return matchesQuery && matchesCategory;
              }).toList()..sort((a, b) => b.rating.compareTo(a.rating));
              if (filtered.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.large),
                    child: Text(
                      'No professionals match this search. Adjust the filters or try another keyword.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.medium),
                children: [
                  AppCard(
                    title: 'Filters',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search by name',
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        DropdownButton<String?>(
                          value: _selectedCategory,
                          isExpanded: true,
                          hint: const Text('Category'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All categories'),
                            ),
                            ...categories.map(
                              (category) => DropdownMenuItem<String?>(
                                value: category,
                                child: Text(category),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _selectedCategory = value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  ...filtered.map((pro) {
                    final proServices = pro.skills
                        .map((skill) => serviceMap[skill])
                        .whereType<Service>()
                        .toList();
                    final topServices = proServices
                        .take(3)
                        .map((service) => service.title)
                        .toList();
                    final defaultService = proServices.isNotEmpty
                        ? proServices.first
                        : null;
                    final distance = _mockDistanceForPro(
                      pro.id,
                      defaultService?.id ?? pro.id,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                      child: AppCard(
                        title: pro.name,
                        subtitle:
                            '${pro.rating.toStringAsFixed(1)} * - ${distance.toStringAsFixed(1)} km away',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (topServices.isNotEmpty)
                              Wrap(
                                spacing: AppSpacing.small,
                                runSpacing: AppSpacing.small,
                                children: topServices
                                    .map((label) => PillTag(label: label))
                                    .toList(),
                              ),
                            const SizedBox(height: AppSpacing.medium),
                            Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    label: 'View services',
                                    variant: AppButtonVariant.ghost,
                                    expand: true,
                                    onPressed: proServices.isEmpty
                                        ? null
                                        : () => _showServicePicker(
                                            context,
                                            pro,
                                            proServices,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.small),
                                Expanded(
                                  child: AppButton(
                                    label: 'Book',
                                    expand: true,
                                    onPressed: defaultService == null
                                        ? null
                                        : () {
                                            context.goNamed(
                                              'slotPicker',
                                              pathParameters: {
                                                'serviceId': defaultService.id,
                                                'proId': pro.id,
                                              },
                                            );
                                          },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Text(
                  'Unable to load professionals right now.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Text(
              'Unable to load services right now.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }

  void _showServicePicker(
    BuildContext context,
    Pro pro,
    List<Service> services,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.medium),
            itemCount: services.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.small),
            itemBuilder: (_, index) {
              final service = services[index];
              return Card(
                child: ListTile(
                  title: Text(service.title),
                  subtitle: Text(
                    '${service.durationMin} min - \$${service.basePrice.toStringAsFixed(0)}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.goNamed(
                      'slotPicker',
                      pathParameters: {
                        'serviceId': service.id,
                        'proId': pro.id,
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
