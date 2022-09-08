import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ruhsal_durum_tespiti/girisEkrani.dart';
import 'package:ruhsal_durum_tespiti/main.dart';

class SonucSayfasi extends StatefulWidget {
  SonucSayfasi({
    Key? key,
    @required this.r,
  }) : super(key: key);
  var r;

  @override
  _SonucSayfasiState createState() => _SonucSayfasiState();
}

List<int> secilmisSorular = [];
List<String> kabulEdilenHastaliklar = [];
List<String> redEdilenHastaliklar = [];
int soruSayisi = 25;

class _SonucSayfasiState extends State<SonucSayfasi> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference hastalikRef = _firestore.collection('hastaliklar');

    return StreamBuilder<QuerySnapshot>(
      stream: hastalikRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Bir hata oluştu!"),
          );
        } else {
          if (snapshot.hasData) {
            return Center(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: <Color>[
                            Color(0xFF6F4C5B),
                            Color(0xFFDEBA9D)
                          ]),
                    ),
                  ),
                  Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white70,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10)),
                                label: const Text(''),
                                icon: const Icon(
                                  Icons.home_rounded,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const MyApp(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                          gelenSoru(
                            snapshot,
                            widget.r,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 450,
                        left: 250,
                        child: Container(
                          height: 350,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                                image: AssetImage('assets/sonuc.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
      },
    );
  }

  Center gelenSoru(AsyncSnapshot<dynamic> snapshot, int r) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 60.0),
        child: Material(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(30),
          elevation: 20,
          child: Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  '~~~~~~~ SONUÇ ~~~~~~~',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Tespit Edilen Psikolojik Durum:',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "${snapshot.data!.docs[r - 1]['hastalik_adi']}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
