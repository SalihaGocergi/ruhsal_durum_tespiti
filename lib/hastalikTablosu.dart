import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class HastalikTablosu extends StatefulWidget {
  const HastalikTablosu({Key? key}) : super(key: key);

  @override
  _HastalikTablosuState createState() => _HastalikTablosuState();
}

class _HastalikTablosuState extends State<HastalikTablosu> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[Color(0xFF6F4C5B), Color(0xFFDEBA9D)]),
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('hastaliklar')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Material(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(30),
                              elevation: 20,
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${document['hastalik_adi']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }),
        ],
      ),
    );
  }
}
