import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModerationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Rate Limit & Spam Prevention Check
  // Ensures a user cannot post more than once every 2 minutes.
  Future<bool> canUserPost(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('community_posts')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return true; // First post allowed
      }

      final lastPostData = querySnapshot.docs.first.data();
      final Timestamp lastTimestamp = lastPostData['timestamp'];
      final DateTime lastPostTime = lastTimestamp.toDate();

      final difference = DateTime.now().difference(lastPostTime);

      // Return true if more than 2 minutes have passed
      return difference.inMinutes >= 2;
    } catch (e) {
      return true; // Fallback in case of error
    }
  }

  // 2. Report Update Logic
  // Increments the report count for a specific post. If reports exceed threshold, flag it.
  Future<void> reportPost(String postId) async {
    final docRef = _firestore.collection('community_posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      int currentReports = snapshot.data()?['reportCount'] ?? 0;
      int newReports = currentReports + 1;

      transaction.update(docRef, {
        'reportCount': newReports,
        // Auto-hide if reports exceed 5
        'isFlagged': newReports >= 5,
      });
    });
  }

  // 3. Fetch Active (Non-Expired) Updates
  // Filters out posts older than 24 hours and flagged posts.
  Stream<QuerySnapshot> getActiveCommunityPosts() {
    final twentyFourHoursAgo = DateTime.now().subtract(const Duration(hours: 24));

    return _firestore
        .collection('community_posts')
        .where('timestamp', isGreaterThan: Timestamp.fromDate(twentyFourHoursAgo))
        .where('isFlagged', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}