import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<int> getUserCount() async {
    QuerySnapshot snapshot = await _usersCollection.get();
    return snapshot.size;
  }

  Future<Map<String, int>> getRegionCount() async {
    QuerySnapshot snapshot = await _usersCollection.get();
    Map<String, int> regionCount = {};

    for (var doc in snapshot.docs) {
      String? region = doc['region'];
      if (region != null) {
        regionCount[region] = (regionCount[region] ?? 0) + 1;
      }
    }

    return regionCount;
  }

  // Uygulama trafiği için örnek bir değer
  Future<int> getAppTraffic() async {
    return 1500;
  }
}
