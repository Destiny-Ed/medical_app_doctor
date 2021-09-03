import 'package:flutter/material.dart';

Widget vitalSigns(BuildContext context,
    {required String title, required String value}) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
          ),
          const SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
        ],
      ),
    ),
  );
}
