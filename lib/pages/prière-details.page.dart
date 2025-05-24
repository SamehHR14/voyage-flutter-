import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PriereDetailsPage extends StatefulWidget {
  final String city;
  final String country;

  PriereDetailsPage({required this.city, required this.country});

  @override
  _PriereDetailsPageState createState() => _PriereDetailsPageState();
}

class _PriereDetailsPageState extends State<PriereDetailsPage> {
  Map<String, dynamic>? timings;

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    final url =
        'https://api.aladhan.com/v1/timingsByCity?city=${widget.city}&country=${widget.country}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        timings = data['data']['timings'];
      });
    }
  }

  Widget _buildTimingRow(String titleFr, String titleAr, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$titleFr - $titleAr", style: TextStyle(fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSunCard(String type, String value, String arabic) {
    final icon = type == 'Lever'
        ? Icons.wb_sunny
        : Icons.nightlight_round;
    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Colors.orange),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: TextStyle(fontSize: 18)),
                Text(arabic, style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prières à ${widget.city}'),
      ),
      body: timings == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Image.asset('assets/images/priere.png', height: 120), // à ajouter dans assets
            Text("أوقات الصلاة اليوم", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(thickness: 1),
            _buildTimingRow("Fajr", "الفجر", timings!["Fajr"]),
            _buildTimingRow("Dhuhr", "الظهر", timings!["Dhuhr"]),
            _buildTimingRow("Asr", "العصر", timings!["Asr"]),
            _buildTimingRow("Maghrib", "المغرب", timings!["Maghrib"]),
            _buildTimingRow("Isha", "العشاء", timings!["Isha"]),
            Divider(thickness: 1),
            _buildSunCard("Levé", timings!["Sunrise"], "الشروق"),
            _buildSunCard("Coucher", timings!["Sunset"], "الغروب"),
          ],
        ),
      ),
    );
  }
}
