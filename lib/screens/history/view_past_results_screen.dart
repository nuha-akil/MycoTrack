import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/delete_dialog.dart';
import 'package:intl/intl.dart';

class ViewPastResultsScreen extends StatefulWidget {
  const ViewPastResultsScreen({super.key});

  @override
  State<ViewPastResultsScreen> createState() => _ViewPastResultsScreenState();
}

class _ViewPastResultsScreenState extends State<ViewPastResultsScreen> {
  // Use 10.0.2.2 for Emulator
  final String serverIp = "10.0.2.2";
  List<dynamic> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final response = await http.get(
        Uri.parse('http://$serverIp:3000/api/skin/history'),
      );

      if (response.statusCode == 200) {
        setState(() {
          history = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("History fetch error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBD5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8D604F),
        elevation: 0,
        toolbarHeight: 90,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "View Past Results",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? const Center(child: Text("No scan history found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    // Formatting date
                    DateTime dateTime = DateTime.parse(item['captured_at']);
                    String date = DateFormat('dd.MM.yyyy').format(dateTime);
                    String time = DateFormat('HH:mm').format(dateTime);
                    
                    // Create full URL for image
                    String imageUrl = "http://$serverIp:3000/${item['image_path'].replaceAll('\\', '/')}";

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: HistoryCard(
                        imageUrl: imageUrl,
                        prediction: "Analysis Saved", // You can update this when you have real AI data
                        date: date,
                        time: time,
                      ),
                    );
                  },
                ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String imageUrl;
  final String prediction;
  final String date;
  final String time;

  const HistoryCard({
    super.key,
    required this.imageUrl,
    required this.prediction,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF8D604F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Real Image from Server
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: const Color(0xFFE7D8C5),
                child: const Icon(Icons.broken_image, color: Color(0xFF8D604F)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status: $prediction",
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date: $date", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    Text("Time: $time", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const DeleteDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}
