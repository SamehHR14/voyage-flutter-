import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GallerieDetailsPage extends StatefulWidget {
  final String message;

  const GallerieDetailsPage({required this.message});

  @override
  State<GallerieDetailsPage> createState() => _GallerieDetailsPageState();
}

class _GallerieDetailsPageState extends State<GallerieDetailsPage> {
  int currentPage = 1;
  int totalPages = 1;
  int size = 10;
  List<dynamic> hits = [];
  bool isLoading = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getGalleryData(widget.message);

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (currentPage < totalPages) {
          currentPage++;
          getGalleryData(widget.message);
        }
      }
    });
  }

  Future<void> getGalleryData(String keyword) async {
    setState(() => isLoading = true);

    final String apiKey = '49697410-a91ae8d57c7559881f52ae79c';
    final String url =
        'https://pixabay.com/api/?key=$apiKey&q=$keyword&page=$currentPage&per_page=$size';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          if (currentPage == 1) hits = [];
          hits.addAll(data['hits']);
          totalPages = (data['totalHits'] / size).ceil();
        });
      }
    } catch (e) {
      print("Erreur : $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Résultats pour \"${widget.message}\""),
      ),
      body: hits.isEmpty
          ? Center(child: isLoading ? CircularProgressIndicator() : Text("Aucun résultat trouvé."))
          : ListView.builder(
        controller: scrollController,
        itemCount: hits.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == hits.length) {
            return Center(child: CircularProgressIndicator());
          }

          final item = hits[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                Card(
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      item['tags'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Card(
                  child: Image.network(
                    item['webformatURL'],
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
