import 'package:flutter/material.dart';

void main() {
  runApp(const YatraSaathiApp());
}

class YatraSaathiApp extends StatelessWidget {
  const YatraSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yatra Saathi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A365D)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  // List of screens for Bottom Navigation
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const LiveScreen(),
    const PnrScreen(),
    const JourneyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚆 Yatra Saathi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Har Yatra Ka Bharosemand Saathi',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Alerts',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new alerts')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Menu',
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A365D),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.train_outlined),
            activeIcon: Icon(Icons.train),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            activeIcon: Icon(Icons.confirmation_number),
            label: 'PNR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alt_route_outlined),
            activeIcon: Icon(Icons.alt_route),
            label: 'Journey',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Train • PNR • Travel Alerts',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'Search Train',
                  description: 'From, To & Schedule',
                  icon: Icons.search,
                  color: Colors.blue.shade50,
                  iconColor: Colors.blue.shade800,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DashboardCard(
                  title: 'Live Status',
                  description: 'Real-time & Community',
                  icon: Icons.train_outlined,
                  color: Colors.orange.shade50,
                  iconColor: Colors.orange.shade800,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'PNR Status',
                  description: 'Confirmation & Seats',
                  icon: Icons.confirmation_number_outlined,
                  color: Colors.green.shade50,
                  iconColor: Colors.green.shade800,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DashboardCard(
                  title: 'My Journey',
                  description: 'Tracker & Smart Alarm',
                  icon: Icons.alt_route,
                  color: Colors.purple.shade50,
                  iconColor: Colors.purple.shade800,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28, color: iconColor),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder Screens for Bottom Navigation Tabs
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('🔍 Search Train Screen (Coming Soon)', style: TextStyle(fontSize: 16)),
    );
  }
}

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('🚆 Live Running Status Screen (Coming Soon)', style: TextStyle(fontSize: 16)),
    );
  }
}

class PnrScreen extends StatelessWidget {
  const PnrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('🎟️ PNR Status Screen (Coming Soon)', style: TextStyle(fontSize: 16)),
    );
  }
}

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('📍 My Journey & Smart Alarm Screen (Coming Soon)', style: TextStyle(fontSize: 16)),
    );
  }
}