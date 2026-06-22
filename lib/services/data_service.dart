import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  static Future<List<Map<String, dynamic>>> loadColleges() async {
    final String data = await rootBundle.loadString('assets/colleges.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.cast<Map<String, dynamic>>();
  }
}
