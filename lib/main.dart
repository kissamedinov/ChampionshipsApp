import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'providers/locale_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/match_provider.dart';
import 'theme/theme_provider.dart';
import 'app_router.dart';
import 'firebase_options.dart';
import 'services/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()), // added
      ],
      child: const FootballChampionshipsApp(),
    ),
  );
}

class FootballChampionshipsApp extends StatelessWidget {
  const FootballChampionshipsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale; // added
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          locale: locale, // added
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (deviceLocale == null) return supportedLocales.first;
            for (var supported in supportedLocales) {
              if (supported.languageCode == deviceLocale.languageCode) {
                return supported;
              }
            }
            return supportedLocales.first;
          },
          routerConfig: appRouter,
          title: 'Football Championships',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
