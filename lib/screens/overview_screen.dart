import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme_provider.dart';
import '../pages/championships_list_page.dart';
import '../league_section.dart';
import 'profile_settings_screen.dart';
import 'map_screen.dart';
import 'match_list_screen.dart';      // ← Added for CRUD
import '../providers/locale_provider.dart';      // ← For language switch
import '../l10n/app_localizations.dart';         // ← Localization

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return ChampionshipsListPage();
      case 1:
        return LeagueSection();
      case 2:
        return ProfileSettingsScreen();
      case 3:
        return MapScreen();
      case 4:
        return const MatchListScreen();  // ← Added for CRUD
      default:
        return Center(
          child: Text(AppLocalizations.of(context).unknownSection),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appTitle),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: AppLocalizations.of(context).changeLanguage,
            onSelected: (locale) {
              context.read<LocaleProvider>().setLocale(locale);
            },
            itemBuilder: (context) {
              return AppLocalizations.supportedLocales.map((locale) {
                return PopupMenuItem<Locale>(
                  value: locale,
                  child: Text(locale.languageCode.toUpperCase()),
                );
              }).toList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () =>
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
        ],
      ),
      body: _getBodyContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.sports_soccer),
            label: AppLocalizations.of(context).championships,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: AppLocalizations.of(context).leagues,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context).settings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: AppLocalizations.of(context).map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt),
            label: AppLocalizations.of(context).matches,
          ),
        ],
      ),
    );
  }
}
