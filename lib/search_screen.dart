import 'package:flutter/material.dart';

// Day 6: Main Search Train Bottom Sheet UI
void showSearchTrainSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          String fromStation = 'New Delhi (NDLS)';
          String toStation = 'Mumbai Central (BCT)';
          String selectedDate = 'Thu, 4 Sep 2026';
          final TextEditingController trainSearchController = TextEditingController();

          void swapStations() {
            setSheetState(() {
              String temp = fromStation;
              fromStation = toStation;
              toStation = temp;
            });
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Search Trains',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const StationSearchScreen()),
                                );
                                if (result != null) {
                                  setSheetState(() {
                                    fromStation = '${result['name']} (${result['code']})';
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.trip_origin, color: Color(0xFF0284C7), size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('FROM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                          const SizedBox(height: 2),
                                          Text(fromStation, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(height: 1, color: Color(0xFFE2E8F0)),
                            InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const StationSearchScreen()),
                                );
                                if (result != null) {
                                  setSheetState(() {
                                    toStation = '${result['name']} (${result['code']})';
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Color(0xFFEA580C), size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('TO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                          const SizedBox(height: 2),
                                          Text(toStation, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 24,
                          child: GestureDetector(
                            onTap: swapStations,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.swap_vert_rounded, color: Colors.white, size: 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, color: Color(0xFF0F172A), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('JOURNEY DATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                              const SizedBox(height: 2),
                              Text(selectedDate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                            ],
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: trainSearchController,
                    decoration: InputDecoration(
                      hintText: 'Search by Train Number or Name (e.g. 12951)',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainResultsScreen(
                              from: fromStation,
                              to: toStation,
                              date: selectedDate,
                              searchQuery: trainSearchController.text.trim(),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Find Trains',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// Day 7: Station Search Screen with Autocomplete & Codes
class StationSearchScreen extends StatefulWidget {
  const StationSearchScreen({super.key});

  @override
  State<StationSearchScreen> createState() => _StationSearchScreenState();
}

class _StationSearchScreenState extends State<StationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allStations = [
    {'name': 'New Delhi', 'code': 'NDLS'},
    {'name': 'Mumbai Central', 'code': 'BCT'},
    {'name': 'Howrah Junction', 'code': 'HWH'},
    {'name': 'Chennai Central', 'code': 'MAS'},
    {'name': 'Bengaluru City', 'code': 'SBC'},
    {'name': 'Ahmedabad Junction', 'code': 'ADI'},
    {'name': 'Patna Junction', 'code': 'PNBE'},
    {'name': 'Jaipur Junction', 'code': 'JP'},
  ];

  final List<Map<String, String>> _recentSearches = [
    {'name': 'New Delhi', 'code': 'NDLS'},
    {'name': 'Mumbai Central', 'code': 'BCT'},
  ];

  List<Map<String, String>> _filteredStations = [];

  @override
  void initState() {
    super.initState();
    _filteredStations = _allStations;
  }

  void _filterStations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStations = _allStations;
      } else {
        _filteredStations = _allStations.where((station) {
          final nameMatches = station['name']!.toLowerCase().contains(query.toLowerCase());
          final codeMatches = station['code']!.toLowerCase().contains(query.toLowerCase());
          return nameMatches || codeMatches;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _filterStations,
          decoration: const InputDecoration(
            hintText: 'Search station name or code (e.g., NDLS)',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
          ),
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
              onPressed: () {
                _searchController.clear();
                _filterStations('');
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_searchController.text.isEmpty && _recentSearches.isNotEmpty) ...[
              const Text(
                'Recent Searches',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recentSearches.map((station) {
                  return ActionChip(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    avatar: const Icon(Icons.history, size: 16, color: Color(0xFF0284C7)),
                    label: Text('${station['name']} (${station['code']})'),
                    labelStyle: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                    onPressed: () {
                      Navigator.pop(context, station);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
            const Text(
              'All Stations',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredStations.length,
                itemBuilder: (context, index) {
                  final station = _filteredStations[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.train_rounded, color: Color(0xFF0284C7), size: 20),
                      ),
                      title: Text(
                        station['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          station['code']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context, station);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Day 10: Train Results Screen with Testing States (Loading, Network Error, No Train Found, Empty State)
class TrainResultsScreen extends StatefulWidget {
  final String from;
  final String to;
  final String date;
  final String searchQuery;

  const TrainResultsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    this.searchQuery = '',
  });

  @override
  State<TrainResultsScreen> createState() => _TrainResultsScreenState();
}

class _TrainResultsScreenState extends State<TrainResultsScreen> {
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchTrains();
  }

  void _fetchTrains() {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    // Simulating network fetch delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
          // Simulate a network error if search query is explicitly "error"
          if (widget.searchQuery.toLowerCase() == 'error') {
            hasError = true;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allTrains = [
      {
        'number': '12951',
        'name': 'Rajdhani Express',
        'departure': '16:55',
        'arrival': '08:35',
        'duration': '15h 40m',
        'runningDays': ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
      },
      {
        'number': '12953',
        'name': 'August Kranti Rajdhani',
        'departure': '17:15',
        'arrival': '09:45',
        'duration': '16h 30m',
        'runningDays': ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
      },
      {
        'number': '12955',
        'name': 'Mumbai Mail',
        'departure': '22:10',
        'arrival': '18:35',
        'duration': '20h 25m',
        'runningDays': ['M', 'W', 'F'],
      },
    ];

    final trains = allTrains.where((train) {
      if (widget.searchQuery.isEmpty) return true;
      final numberMatch = train['number'].toLowerCase().contains(widget.searchQuery.toLowerCase());
      final nameMatch = train['name'].toLowerCase().contains(widget.searchQuery.toLowerCase());
      return numberMatch || nameMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Trains',
              style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.searchQuery.isNotEmpty ? '${widget.date} • Filter: "${widget.searchQuery}"' : widget.date,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Color(0xFF0284C7)),
            SizedBox(height: 16),
            Text(
              'Finding best trains for you...',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
            ),
          ],
        ),
      )
          : hasError
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 56, color: Color(0xFFEA580C)),
              const SizedBox(height: 16),
              const Text(
                'Network Error',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _fetchTrains,
                child: const Text('Retry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      )
          : trains.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 56, color: Color(0xFF94A3B8)),
            const SizedBox(height: 16),
            const Text(
              'No Train Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            Text(
              'No trains match "${widget.searchQuery}". Try a different search.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trains.length,
        itemBuilder: (context, index) {
          final train = trains[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainDetailScreen(
                    train: {
                      ...train,
                      'fromStation': widget.from,
                      'toStation': widget.to,
                    },
                    date: widget.date,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${train['number']} • ${train['name']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Icon(Icons.bookmark_border, color: Color(0xFF64748B), size: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            train['departure'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 2),
                          const Text('Origin', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            train['duration'],
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(3, (i) => Container(
                              width: 6,
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              color: const Color(0xFFCBD5E1),
                            )),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            train['arrival'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 2),
                          const Text('Destination', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Color(0xFFF1F5F9), height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Runs On:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                      ),
                      Row(
                        children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                          bool isRunning = (train['runningDays'] as List).contains(day);
                          return Container(
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.only(left: 4),
                            decoration: BoxDecoration(
                              color: isRunning ? const Color(0xFFE0F2FE) : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isRunning ? const Color(0xFF0284C7) : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Day 9: Train Detail Screen with Full Route, Halts, and Platforms
class TrainDetailScreen extends StatelessWidget {
  final Map<String, dynamic> train;
  final String date;

  const TrainDetailScreen({
    super.key,
    required this.train,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> routeStations = [
      {
        'station': train['fromStation'] ?? 'New Delhi',
        'code': 'NDLS',
        'arrival': 'Source',
        'departure': train['departure'],
        'halt': '0m',
        'platform': '1',
      },
      {
        'station': 'Mathura Junction',
        'code': 'MTJ',
        'arrival': '18:50',
        'departure': '18:52',
        'halt': '2m',
        'platform': '3',
      },
      {
        'station': 'Kota Junction',
        'code': 'KOTA',
        'arrival': '22:10',
        'departure': '22:20',
        'halt': '10m',
        'platform': '2',
      },
      {
        'station': 'Ratlam Junction',
        'code': 'RTM',
        'arrival': '01:40',
        'departure': '01:45',
        'halt': '5m',
        'platform': '4',
      },
      {
        'station': train['toStation'] ?? 'Mumbai Central',
        'code': 'BCT',
        'arrival': train['arrival'],
        'departure': 'Destination',
        'halt': '0m',
        'platform': '5',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${train['number']} • ${train['name']}',
              style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Journey Date: $date',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('DURATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(train['duration'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ],
                ),
                Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                Column(
                  children: [
                    const Text('TOTAL STATIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text('${routeStations.length}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: routeStations.length,
              itemBuilder: (context, index) {
                final stop = routeStations[index];
                bool isFirst = index == 0;
                bool isLast = index == routeStations.length - 1;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isFirst || isLast ? const Color(0xFFEA580C) : const Color(0xFF0284C7),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${stop['station']} (${stop['code']})',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'PF #${stop['platform']}',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Arr: ${stop['arrival']}  |  Dep: ${stop['departure']}',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                                Text(
                                  'Halt: ${stop['halt']}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFEA580C)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}