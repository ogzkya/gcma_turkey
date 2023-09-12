import 'dart:convert';
import 'package:http/http.dart' as http;

class WaterCrisisService {
  Future<List<Map<String, dynamic>>> fetchWaterCrisisData() async {
    final response = await http.get(Uri.parse(
        'https://api.resourcewatch.org/v1/query/1f6b1b14-0b1c-4678-8f1b-74e9d62fd0ee?sql=SELECT%20gid_0%2C%20name_0%2C%20bws_score%20FROM%20aqueduct_v30_v_01%20LIMIT%2010'));
    final data = json.decode(response.body);
    final records = data['data'];

    if (response.statusCode == 200) {
      return records.map<Map<String, dynamic>>((record) {
        return {
          'country': record['name_0'],
          'countryCode': record['gid_0'],
          'waterRisk': record['bws_score'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load water crisis data');
    }
  }
}
