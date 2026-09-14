import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // (ensure .dart in your actual import)
import 'moderation_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final CommunityModerationService _moderationService = CommunityModerationService();
  final TextEditingController _postController = TextEditingController();
  final String currentUserId = "user_ayush_123"; // Dummy user ID for testing

  void _createPost() async {
    if (_postController.text.trim().isEmpty) return;

    // 1. Check Rate Limit (2 minutes)
    bool canPost = await _moderationService.canUserPost(currentUserId);
    if (!canPost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait 2 minutes before posting another update to prevent spam.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 2. Add Post to Firestore
    await FirebaseFirestore.instance.collection('community_posts').add({
      'userId': currentUserId,
      'content': _postController.text.trim(),
      'timestamp': Timestamp.now(),
      'reportCount': 0,
      'isFlagged': false,
    });

    _postController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Update posted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Yatra Saathi Community', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Post Input Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: 'Share live train or route update...',
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _createPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  child: const Text('Post'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Live Community Feed (Filtered by 24 hours & unflagged)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _moderationService.getActiveCommunityPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No recent updates. Be the first to share!',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final postId = docs[index].id;
                    final content = data['content'] ?? '';
                    final Timestamp? timestamp = data['timestamp'];
                    final timeString = timestamp != null
                        ? timestamp.toDate().toLocal().toString().substring(11, 16)
                        : '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
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
                              const Text(
                                'Fellow Passenger',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                              ),
                              Row(
                                children: [
                                  Text(timeString, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.flag_outlined, size: 18, color: Colors.redAccent),
                                    onPressed: () async {
                                      await _moderationService.reportPost(postId);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Post reported for moderation.')),
                                      );
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(content, style: const TextStyle(fontSize: 14, color: Color(0xFF334155))),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}