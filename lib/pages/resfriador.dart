import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Resfriador extends StatefulWidget {
  const Resfriador({Key? key}) : super(key: key);

  @override
  State<Resfriador> createState() => _ResfriadorState();
}

class _ResfriadorState extends State<Resfriador> {
  double? temperatura;

  pegarDados() {
    setState(() {
      try {
        FirebaseFirestore.instance
            .collection("resfriador")
            .doc("1")
            .get()
            .then((value) {
          temperatura = value.get("temperatura");
        });
      } catch (e) {
        temperatura = 0;
      }
    });
  }

  void initState() {
    Future.delayed(Duration.zero, () async {
      Timer.periodic(const Duration(seconds: 2), pegarDados());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(2, 10, 0, 0),
          child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        ),
        backgroundColor: Color(0xB30A3638),
        automaticallyImplyLeading: true,
        title: Text(
          'RESFRIADOR',
          style: TextStyle(fontSize: 33),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 130,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xffAAC7C4),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(12),
            width: double.infinity,
            child: Text(
              "Estado do resfriador",
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(
            height: 80 ,
          ),
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xffAAC7C4),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  "Temperatura",
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "${temperatura} ºC",
                  style: TextStyle(color: Colors.black, fontSize: 26),
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                    onPressed: () {
                      pegarDados();
                    },
                    child: Text(
                      "Atualizar dados",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF098799),
                        fixedSize: const Size(180, 50),
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
