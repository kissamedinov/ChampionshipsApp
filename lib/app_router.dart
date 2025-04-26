import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/overview_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/prediction_screen.dart';
import 'screens/login_screen.dart';
import 'screens/error_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/leagues_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/map_screen.dart'; // Экран карты подключен

import 'data/match_data.dart';
import 'models/match.dart';
import 'services/auth_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  refreshListenable: AuthService.instance,
  redirect: (context, state) {
    final loggedIn = AuthService.instance.isLoggedIn;
    final loggingIn = state.fullPath == '/login';

    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && loggingIn) return '/';
    return null;
  },
  errorBuilder: (context, state) => const ErrorScreen(),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OverviewScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => FavoritesScreen(matches: mockMatches),
    ),
    GoRoute(
      path: '/predict/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final match = mockMatches.firstWhere((m) => m.id == id);
        return PredictionScreen(match: match);
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => CartScreen(),
    ),
    GoRoute(
      path: '/leagues',
      builder: (context, state) => LeaguesScreen(),
    ),
    GoRoute(
      path: '/matches/:league',
      builder: (context, state) {
        final league = state.pathParameters['league']!;
        return MatchesScreen(league: league);
      },
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
  ],
);
