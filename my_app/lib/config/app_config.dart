import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Toggles whether the app uses local mock data or hits live APIs.
/// Override this provider in `main` or tests to switch modes.
final useMocksProvider = StateProvider<bool>((_) => true);

/// Base URL for the backend API.
final apiBaseUrlProvider = StateProvider<String>((_) => 'https://api.example.com');

/// Stores the current JWT token (if any) used for authenticated requests.
final authTokenProvider = StateProvider<String?>((_) => null);
