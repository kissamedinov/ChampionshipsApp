import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart'; // Add CartProvider
import 'app_router.dart'; // Your app's router configuration
import 'theme/theme_provider.dart'; // Add ThemeProvider for theme switching

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // CartProvider
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ThemeProvider
      ],
      child: FootballChampionshipsApp(),
    ),
  );
}

class FootballChampionshipsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          routerConfig: appRouter,
          title: 'Football Championships',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.blueAccent,
            scaffoldBackgroundColor: Colors.black,
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Switch theme mode
        );
      },
    );
  }
}
