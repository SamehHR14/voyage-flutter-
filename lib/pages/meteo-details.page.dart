import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeteoDetailsPage extends StatefulWidget {
  final String ville;

  MeteoDetailsPage(this.ville);

  @override
  State<MeteoDetailsPage> createState() => _MeteoDetailsPageState();
}

class _MeteoDetailsPageState extends State<MeteoDetailsPage> {
  var meteoData;
  bool isLoading = true; // Ajout d'un état de chargement
  bool hasError = false; // Indicateur d'erreur

  @override
  void initState() {
    super.initState();
    getMeteoData(widget.ville);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Météo Details ${widget.ville}')),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loader pendant le chargement
          : hasError
          ? Center(
        child: Text(
          "Erreur lors du chargement des données",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      )
          : ListView.builder(
        itemCount: meteoData['list']?.length ?? 0,
        itemBuilder: (context, index) {
          var weather = meteoData['list'][index];

          if (weather == null || weather['main'] == null || weather['dt_txt'] == null) {
            return Container(); // Ne rien afficher si les données sont absentes
          }

          String dateTime = weather['dt_txt']; // Date et heure
          double tempCelsius = weather['main']['temp'] - 273.15; // Conversion Kelvin → Celsius
          String weatherState = weather['weather'][0]['description']; // État du temps
          String iconCode = weather['weather'][0]['icon']; // Code de l'icône météo
          String imageUrl = "https://openweathermap.org/img/wn/$iconCode@2x.png"; // URL de l'icône météo

          return Card(
            color: Colors.blue,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/${meteoData['list'][index]['weather'][0]['main'].toString().toLowerCase()}.png"),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: $dateTime",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text("État: $weatherState", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "${tempCelsius.toStringAsFixed(1)}°C", // Affichage de la température
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void getMeteoData(String ville) async {
    try {
      String url =
          "https://api.openweathermap.org/data/2.5/forecast?q=$ville&appid=c109c07bc4df77a88c923e6407aef864";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          meteoData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (err) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print("Erreur: $err");
    }
  }
}
