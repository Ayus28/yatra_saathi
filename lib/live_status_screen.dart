import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LiveStatusSearchScreen extends StatefulWidget {
  const LiveStatusSearchScreen({super.key});

  @override
  State<LiveStatusSearchScreen> createState() => _LiveStatusSearchScreenState();
}

class _LiveStatusSearchScreenState extends State<LiveStatusSearchScreen> {
  final TextEditingController _trainController = TextEditingController();
  String selectedDate = 'Today (Thu, 4 Sep)';

  final List<String> dateOptions = [
    'Yesterday (Wed, 3 Sep)',
    'Today (Thu, 4 Sep)',
    'Tomorrow (Fri, 5 Sep)',
  ];

  Future<void> _checkLocationAndNavigate(BuildContext context) async {
    if (_trainController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a train number')),
      );
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled. Please enable GPS.')),
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LiveStatusDetailScreen(
            trainNumber: _trainController.text.trim(),
            journeyDate: selectedDate,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Live Train Status',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
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
                  const Text(
                    'Enter Train Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _trainController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Train Number (e.g. 12951, 0000)',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.train_rounded, color: Color(0xFF0284C7)),
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
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedDate,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                        items: dateOptions.map((String date) {
                          return DropdownMenuItem<String>(
                            value: date,
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, color: Color(0xFF0F172A), size: 18),
                                const SizedBox(width: 12),
                                Text(
                                  date,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedDate = newValue;
                            });
                          }
                        },
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
                      onPressed: () => _checkLocationAndNavigate(context),
                      child: const Text(
                        'Check Live Status',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveStatusDetailScreen extends StatefulWidget {
  final String trainNumber;
  final String journeyDate;

  const LiveStatusDetailScreen({
    super.key,
    required this.trainNumber,
    required this.journeyDate,
  });

  @override
  State<LiveStatusDetailScreen> createState() => _LiveStatusDetailScreenState();
}

class _LiveStatusDetailScreenState extends State<LiveStatusDetailScreen> {
  late String lastUpdated;
  Timer? _autoRefreshTimer;
  bool isAutoRefreshEnabled = true;

  // Shared list of community posts so that they sync when opening the full chat room
  final List<Map<String, String>> _communityPosts = [
    {
      'user': 'Rahul S.',
      'time': '10 mins ago',
      'station': 'Kota Jn',
      'message': 'Cleanliness in Coach B3 is good. Train departed right on time after pantry loading.',
      'likes': '14',
    },
    {
      'user': 'Amit K.',
      'time': '35 mins ago',
      'station': 'Mathura Jn',
      'message': 'Pantry car food quality was decent today. Evening snacks served hot.',
      'likes': '8',
    },
  ];

  @override
  void initState() {
    super.initState();
    lastUpdated = 'Just now (4:42 PM)';

    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (isAutoRefreshEnabled && mounted) {
        _refreshData(isAuto: true);
      }
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshData({bool isAuto = false}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      final now = DateTime.now();
      final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
      final minute = now.minute.toString().padLeft(2, '0');
      final period = now.hour >= 12 ? 'PM' : 'AM';
      lastUpdated = 'Just now ($hour:$minute $period)';
    });

    if (!isAuto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Live status updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddUpdateDialog(BuildContext context, {Function(Map<String, String>)? onPostAdded}) {
    String selectedTag = '🚆 Departed';
    final TextEditingController messageController = TextEditingController();

    final List<Map<String, dynamic>> updateTags = [
      {'label': '🚆 Departed', 'color': const Color(0xFF16A34A)},
      {'label': '🚉 Arrived', 'color': const Color(0xFF0284C7)},
      {'label': '🔄 Crossed', 'color': const Color(0xFF6366F1)},
      {'label': '🛑 Waiting at Signal', 'color': const Color(0xFFCA8A04)},
      {'label': '🚂 Goods Train Crossed', 'color': const Color(0xFF475569)},
      {'label': '🚆 Passenger Train Crossed', 'color': const Color(0xFF0EA5E9)},
      {'label': '🅿️ Platform Changed', 'color': const Color(0xFF9333EA)},
      {'label': '⚠️ Train Stopped', 'color': const Color(0xFFDC2626)},
      {'label': '⏰ Delay', 'color': const Color(0xFFEA580C)},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 20,
                right: 20,
                top: 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.rate_review_rounded, color: Color(0xFF0284C7), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Post Community Update',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                          padding: const EdgeInsets.all(6),
                        ),
                        icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Status Tag',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: updateTags.map((tagMap) {
                      final tag = tagMap['label'] as String;
                      final isSelected = selectedTag == tag;
                      return ChoiceChip(
                        label: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : const Color(0xFF334155),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0F172A),
                        backgroundColor: const Color(0xFFF8FAFC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        onSelected: (bool selected) {
                          setModalState(() {
                            selectedTag = tag;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Additional Details (Optional)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: messageController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      hintText: 'Write details (e.g. Coach position, cleaning status, reason)...',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (messageController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter update details')),
                          );
                          return;
                        }

                        final newPost = {
                          'user': 'You',
                          'time': 'Just now',
                          'station': selectedTag,
                          'message': messageController.text.trim(),
                          'likes': '0',
                        };

                        setState(() {
                          _communityPosts.insert(0, newPost);
                        });

                        if (onPostAdded != null) {
                          onPostAdded(newPost);
                        }

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Update posted successfully under "$selectedTag"')),
                        );
                      },
                      child: const Text(
                        'Post Community Update',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.trainNumber == '0000' || widget.trainNumber.length < 4) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Live Status: ${widget.trainNumber}', style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16)),
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)), onPressed: () => Navigator.pop(context)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: Color(0xFFFEF2F2), shape: BoxShape.circle),
                  child: const Icon(Icons.train_outlined, size: 48, color: Color(0xFFDC2626)),
                ),
                const SizedBox(height: 20),
                const Text('Train Not Found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 8),
                const Text('Please check the train number and try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final trainName = widget.trainNumber == '12951' ? 'Rajdhani Express' : 'Superfast Express';
    final bool isDataOutdated = widget.trainNumber == '12345';
    final bool isNoLocation = widget.trainNumber == '54321';

    final currentLocation = isNoLocation ? 'Location currently unavailable' : 'At Kota Junction (KOTA)';
    final delayStatus = isDataOutdated ? 'Last synced 2h ago' : '15 mins late';

    final List<Map<String, dynamic>> stations = [
      {'code': 'NDLS', 'name': 'New Delhi', 'arr': '16:50', 'dep': '16:55', 'expArr': '16:50', 'expDep': '16:55', 'status': 'departed', 'delay': 'On time'},
      {'code': 'MTJ', 'name': 'Mathura Junction', 'arr': '18:15', 'dep': '18:20', 'expArr': '18:20', 'expDep': '18:25', 'status': 'departed', 'delay': '5m late'},
      {'code': 'KOTA', 'name': 'Kota Junction', 'arr': '21:55', 'dep': '22:10', 'expArr': '22:10', 'expDep': '22:25', 'status': 'current', 'delay': '15m late'},
      {'code': 'RTM', 'name': 'Ratlam Junction', 'arr': '01:25', 'dep': '01:40', 'expArr': '01:40', 'expDep': '01:55', 'status': 'upcoming', 'delay': '15m late'},
      {'code': 'BRC', 'name': 'Vadodara Junction', 'arr': '05:00', 'dep': '05:10', 'expArr': '05:10', 'expDep': '05:20', 'status': 'upcoming', 'delay': '10m late'},
      {'code': 'BCT', 'name': 'Mumbai Central', 'arr': '08:35', 'dep': '-', 'expArr': '08:35', 'expDep': '-', 'status': 'destination', 'delay': 'On time'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Live Status: ${widget.trainNumber}',
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Row(
            children: [
              const Text(
                'Auto',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
              Transform.scale(
                scale: 0.75,
                child: Switch.adaptive(
                  value: isAutoRefreshEnabled,
                  activeTrackColor: const Color(0xFF16A34A),
                  onChanged: (val) {
                    setState(() {
                      isAutoRefreshEnabled = val;
                    });
                  },
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0284C7)),
            tooltip: 'Refresh Status',
            onPressed: () => _refreshData(isAuto: false),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(isAuto: false),
        color: const Color(0xFF0284C7),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Train Details Container
              Container(
                padding: const EdgeInsets.all(20),
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
                          '${widget.trainNumber} • $trainName',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            delayStatus,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 16, color: Color(0xFF0284C7)),
                        const SizedBox(width: 8),
                        Text(
                          currentLocation,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBAE6FD)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.social_distance_rounded, color: Color(0xFF0284C7), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🚆 Train is 2.4 km from Kota Junction',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0369A1),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Next station (Ratlam Jn) is 142.5 km away',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Color(0xFF0284C7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Journey: ${widget.journeyDate}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                        Text(
                          'Updated: $lastUpdated',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Community Updates Section with Click to Open Full Chat Room
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Community Updates & Passenger Reports',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainChatRoomScreen(
                            trainNumber: widget.trainNumber,
                            trainName: trainName,
                            posts: _communityPosts,
                            onAddPost: (post) {
                              setState(() {
                                _communityPosts.insert(0, post);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'View All Chats',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainChatRoomScreen(
                        trainNumber: widget.trainNumber,
                        trainName: trainName,
                        posts: _communityPosts,
                        onAddPost: (post) {
                          setState(() {
                            _communityPosts.insert(0, post);
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Container(
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
                          const Row(
                            children: [
                              Icon(Icons.forum_rounded, size: 18, color: Color(0xFF0284C7)),
                              SizedBox(width: 8),
                              Text(
                                'Live Crowdsourced Feed (Tap to Open Chat)',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              backgroundColor: const Color(0xFFE0F2FE),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => _showAddUpdateDialog(context, onPostAdded: (newPost) {
                              setState(() {
                                _communityPosts.insert(0, newPost);
                              });
                            }),
                            icon: const Icon(Icons.add, size: 14, color: Color(0xFF0284C7)),
                            label: const Text(
                              'Add Update',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _communityPosts.length > 2 ? 2 : _communityPosts.length,
                        separatorBuilder: (context, index) => const Divider(height: 16, color: Color(0xFFF1F5F9)),
                        itemBuilder: (context, index) {
                          final post = _communityPosts[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: const Color(0xFF0284C7).withValues(alpha: 0.15),
                                        child: Text(
                                          post['user']![0],
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        post['user']!,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          post['station']!,
                                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    post['time']!,
                                    style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                post['message']!,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF334155), height: 1.3),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Route Timeline & Arriving Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    final status = station['status'];

                    Color dotColor;
                    IconData dotIcon;
                    if (status == 'departed') {
                      dotColor = const Color(0xFF16A34A);
                      dotIcon = Icons.check;
                    } else if (status == 'current') {
                      dotColor = const Color(0xFF0284C7);
                      dotIcon = Icons.train;
                    } else if (status == 'destination') {
                      dotColor = const Color(0xFF9333EA);
                      dotIcon = Icons.flag;
                    } else {
                      dotColor = const Color(0xFFCBD5E1);
                      dotIcon = Icons.circle;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: dotColor.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(dotIcon, size: 14, color: dotColor),
                                ),
                                if (index != stations.length - 1)
                                  Container(
                                    width: 2,
                                    height: 75,
                                    color: const Color(0xFFE2E8F0),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${station['name']} (${station['code']})',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: status == 'current' ? FontWeight.bold : FontWeight.w600,
                                            color: status == 'current' ? const Color(0xFF0284C7) : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Sch: Arr ${station['arr']} | Dep ${station['dep']}',
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Arriving: ${station['expArr']} | Exp Dep: ${station['expDep']}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: status == 'current' ? const Color(0xFF0284C7) : const Color(0xFF334155),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: dotColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: station['delay'] == 'On time' ? const Color(0xFFDCFCE7) : const Color(0xFFFEF2F2),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            station['delay'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: station['delay'] == 'On time' ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (index == 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 42, bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                                title: const Row(
                                  children: [
                                    Icon(Icons.unfold_more_rounded, size: 16, color: Color(0xFF64748B)),
                                    SizedBox(width: 8),
                                    Text(
                                      '2 Non-Halting Stations in-between',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('• Kosi Kalan (KSV) - Crossed at 18:45', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                                        SizedBox(height: 6),
                                        Text('• Mathura Outer - Crossed at 19:02', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dedicated Train Chat Room Screen (Active until destination reached)
class TrainChatRoomScreen extends StatefulWidget {
  final String trainNumber;
  final String trainName;
  final List<Map<String, String>> posts;
  final Function(Map<String, String>) onAddPost;

  const TrainChatRoomScreen({
    super.key,
    required this.trainNumber,
    required this.trainName,
    required this.posts,
    required this.onAddPost,
  });

  @override
  State<TrainChatRoomScreen> createState() => _TrainChatRoomScreenState();
}

class _TrainChatRoomScreenState extends State<TrainChatRoomScreen> {
  final TextEditingController _msgController = TextEditingController();
  bool isJourneyCompleted = false; // Set to true once train reaches final destination

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Chat: ${widget.trainNumber}',
              style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.trainName,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isJourneyCompleted ? const Color(0xFFFEF2F2) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isJourneyCompleted ? 'Journey Completed' : '🟢 Live Discussion',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isJourneyCompleted ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFE0F2FE),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Color(0xFF0284C7), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This chat is crowdsourced from live passengers and will remain active until the train reaches its destination.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF0369A1), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: widget.posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final post = widget.posts[index];
                return Container(
                  padding: const EdgeInsets.all(14),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: const Color(0xFF0284C7).withValues(alpha: 0.15),
                                child: Text(
                                  post['user']![0],
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                post['user']!,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  post['station']!,
                                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            post['time']!,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post['message']!,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.3),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (!isJourneyCompleted)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: InputDecoration(
                        hintText: 'Share live update with passengers...',
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () {
                      if (_msgController.text.trim().isEmpty) return;
                      final newPost = {
                        'user': 'You',
                        'time': 'Just now',
                        'station': '🚆 Live Update',
                        'message': _msgController.text.trim(),
                        'likes': '0',
                      };
                      widget.onAddPost(newPost);
                      setState(() {
                        _msgController.clear();
                      });
                    },
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFFEF2F2),
              child: const Center(
                child: Text(
                  'Train has reached destination. Discussion closed.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}