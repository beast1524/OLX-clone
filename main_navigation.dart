import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/sell_listing_page.dart';

class MainNavigation extends StatefulWidget {
  final Widget? themeToggleButton;

  const MainNavigation({
    super.key,
    this.themeToggleButton,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Screens list - HomeScreen gets the theme toggle button
  List<Widget> get _screens => [
    HomeScreen(themeToggleButton: widget.themeToggleButton),
    const WishlistScreen(),
    const _PlaceholderScreen(title: "Sell"),
    const _PlaceholderScreen(title: "My Listings"),
    const _PlaceholderScreen(title: "Account"),
  ];

  // AppBar titles for each screen
  final List<String> _appBarTitles = const [
    "Company Marketplace",
    "Wishlist",
    "Sell",
    "My Listings",
    "Account",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves state of each tab (recommended)
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Sell",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "My Listings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
    );
  }
}

/// Use a full-screen Scaffold for placeholders so they look like real pages.
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconForTitle(title),
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            "$title Screen",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 12),
          Text(
            "Coming soon...",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case "Sell":
        return Icons.add_circle_outline;
      case "My Listings":
        return Icons.inventory_2_outlined;
      case "Account":
        return Icons.person_outline;
      default:
        return Icons.info_outline;
    }
  }
}