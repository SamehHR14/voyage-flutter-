
import 'package:flutter/material.dart';

import 'meteo-details.page.dart';

class MeteoPage extends StatelessWidget {
  final TextEditingController txt_ville = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Page Meteo')),
        body: Column(children: [
        Container(padding: EdgeInsets.all(10),
      child: TextFormField(controller: txt_ville,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.location_city),
            hintText: "chercher",
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10)
            )
        ),
      ),
    ),
          Container(padding: EdgeInsets.all(10),
            child: ElevatedButton(onPressed: ()=>
              _onGetMeteoDetails(context),
                child: Text("Chercher",style: TextStyle(fontSize: 22),)),),
        ])
    );
  }

  void _onGetMeteoDetails(BuildContext context) {
    String v = txt_ville.text;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> MeteoDetailsPage(v))
    );
    txt_ville.text = "";
  }
}