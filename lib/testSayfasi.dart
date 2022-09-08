import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ruhsal_durum_tespiti/girisEkrani.dart';
import 'package:ruhsal_durum_tespiti/hastalikTablosu.dart';
import 'package:ruhsal_durum_tespiti/hastalikTablosu2.dart';
import 'package:ruhsal_durum_tespiti/main.dart';
import 'package:ruhsal_durum_tespiti/sonucSayfasi.dart';

class TestSayfasi extends StatefulWidget {
  TestSayfasi({
    Key? key,
    @required this.r,
  }) : super(key: key);
  var r;

  @override
  _TestSayfasiState createState() => _TestSayfasiState();
}

List<int> secilmisSorular = [];
List<String> kabulEdilenHastaliklar = [];
List<String> redEdilenHastaliklar = [];
//List<String> redEdilenSorular = [];

class _TestSayfasiState extends State<TestSayfasi> {
  final _firestore = FirebaseFirestore.instance;
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    CollectionReference sorularRef = _firestore.collection('sorular');

    secilmisSorular.add(widget.r);
    print("->secilmisSorular son hali: $secilmisSorular");

    void randomDegerAl() {
      int min = 10, max = 35;
      int r = min + random.nextInt(max - min);
      for (int k = 0; k < secilmisSorular.length; k++) {
        if (r == secilmisSorular[k]) {
          randomDegerAl();
        }
      }
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => TestSayfasi(r: r),
        ),
      );
    }

//EVET TIKLANDIĞINDA
    void kabulEdilenHastalikEkle() async {
      final QuerySnapshot sorularHastalikRef = await FirebaseFirestore.instance
          .collection('sorular')
          .doc("${widget.r}")
          .collection("hastaliklar")
          .get();
      final int documents = sorularHastalikRef.docs.length;

      for (int i = 0; i < documents; i++) {
        int varmiKabul = 0, varmiRed = 0;
        //EĞER KABUL EDİLEN HASTALIK İÇERİSİNDE VARSA TEKRARDAN KAYDETME
        for (int j = 0; j < kabulEdilenHastaliklar.length; j++) {
          if (kabulEdilenHastaliklar[j] == sorularHastalikRef.docs[i].id) {
            varmiKabul = 1;
          }
        }
        //EĞER RED EDİLEN İÇERİSİNDE VARSA KABUL'E EKLENMESİN
        for (int j = 0; j < redEdilenHastaliklar.length; j++) {
          if (redEdilenHastaliklar[j] == sorularHastalikRef.docs[i].id) {
            varmiRed = 1;
          }
        }
        //KONTROLLER SONRASI KAYIT ETME İŞLEMİ
        if (varmiKabul == 0 && varmiRed == 0) {
          kabulEdilenHastaliklar.add(sorularHastalikRef.docs[i].id);
        }
      }
      //BURADA KABUL EDİLEN HASTALIKLAR İÇERİSİNDEN 2.SORUYU GETİREBİLMEK İÇİN SORULARINI ÇEKTİK
      if (kabulEdilenHastaliklar.isNotEmpty) {
        //TEK HASTALIK KALDIYSA sonuç sayfasına gitsin
        if (kabulEdilenHastaliklar.length == 1) {
          if (secilmisSorular.length <= 5) {
            final QuerySnapshot hastalikSorularRef = await FirebaseFirestore
                .instance
                .collection('hastaliklar')
                .doc(kabulEdilenHastaliklar[0])
                .collection("sorular")
                .get();
            final int documentsKabulEdilenHastalik =
                hastalikSorularRef.docs.length;

            for (int z = 0; z < documentsKabulEdilenHastalik; z++) {
              int varmiSecilmisSorular = 0;
              for (int i = 0; i < secilmisSorular.length; i++) {
                if (int.parse(hastalikSorularRef.docs[z].id) ==
                    secilmisSorular[i]) {
                  varmiSecilmisSorular = 1;
                }
              }
              if (varmiSecilmisSorular == 0) {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => TestSayfasi(
                        r: int.parse(hastalikSorularRef.docs[z].id)),
                  ),
                );
                break;
              }
            }
          } else {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    SonucSayfasi(r: int.parse(kabulEdilenHastaliklar[0])),
              ),
            );
          }
        } else {
          final QuerySnapshot hastalikSorularRef = await FirebaseFirestore
              .instance
              .collection('hastaliklar')
              .doc(kabulEdilenHastaliklar[0])
              .collection("sorular")
              .get();

          final int documentsKabulEdilenHastalik =
              hastalikSorularRef.docs.length;

          for (int z = 0; z < documentsKabulEdilenHastalik; z++) {
            int varmiSecilmisSorular = 0;
            for (int i = 0; i < secilmisSorular.length; i++) {
              if (int.parse(hastalikSorularRef.docs[z].id) ==
                  secilmisSorular[i]) {
                varmiSecilmisSorular = 1;
              }
            }
            if (varmiSecilmisSorular == 0) {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      TestSayfasi(r: int.parse(hastalikSorularRef.docs[z].id)),
                ),
              );
              break;
            }
          }
        }
      }
      if (kabulEdilenHastaliklar.isEmpty) {
        if (secilmisSorular.length >= 5) {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => SonucSayfasi(r: 9),
            ),
          );
        } else {
          randomDegerAl();
        }
      }
      print("secilmisSorular son hali: $secilmisSorular");
      print("kabulEdilenHastaliklar son hali: $kabulEdilenHastaliklar");
      print("redEdilenHastaliklar son hali: $redEdilenHastaliklar");
    }

//HAYIR TIKLANDIĞINDA
    void redEdilenHastalikEkle() async {
      final QuerySnapshot sorularHastalikRef = await FirebaseFirestore.instance
          .collection('sorular')
          .doc("${widget.r}")
          .collection("hastaliklar")
          .get();
      final int documents = sorularHastalikRef.docs.length;
      //RED EDİLEN SORUNUN HASTALIKLARININ LİSTEYE EKLENMESİ
      for (int i = 0; i < documents; i++) {
        int varmiRed = 0;
        //EĞER RED EDİLEN İÇERİSİNDE VARSA RED'E EKLENMESİN
        for (int j = 0; j < redEdilenHastaliklar.length; j++) {
          if (redEdilenHastaliklar[j] == sorularHastalikRef.docs[i].id) {
            varmiRed = 1;
          }
        }
        //KONTROLLER SONRASI KAYIT ETME İŞLEMİ
        if (varmiRed == 0) {
          redEdilenHastaliklar.add(sorularHastalikRef.docs[i].id);
        }
      }
      for (int j = 0; j < redEdilenHastaliklar.length; j++) {
        for (int z = 0; z < kabulEdilenHastaliklar.length; z++) {
          if (redEdilenHastaliklar[j] == kabulEdilenHastaliklar[z]) {
            kabulEdilenHastaliklar.removeAt(z);
          }
        }
      }
      //BURADA KABUL EDİLEN HASTALIKLAR İÇERİSİNDEN 2.SORUYU GETİREBİLMEK İÇİN SORULARINI ÇEKTİK
      if (kabulEdilenHastaliklar.isNotEmpty) {
        //TEK HASTALIK KALDIYSA sonuç sayfasına gitsin
        if (kabulEdilenHastaliklar.length == 1) {
          if (secilmisSorular.length <= 5) {
            final QuerySnapshot hastalikSorularRef = await FirebaseFirestore
                .instance
                .collection('hastaliklar')
                .doc(kabulEdilenHastaliklar[0])
                .collection("sorular")
                .get();
            final int documentsKabulEdilenHastalik =
                hastalikSorularRef.docs.length;

            for (int z = 0; z < documentsKabulEdilenHastalik; z++) {
              int varmiSecilmisSorular = 0;
              for (int i = 0; i < secilmisSorular.length; i++) {
                if (int.parse(hastalikSorularRef.docs[z].id) ==
                    secilmisSorular[i]) {
                  varmiSecilmisSorular = 1;
                }
              }
              if (varmiSecilmisSorular == 0) {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => TestSayfasi(
                        r: int.parse(hastalikSorularRef.docs[z].id)),
                  ),
                );
                break;
              }
            }
          } else {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    SonucSayfasi(r: int.parse(kabulEdilenHastaliklar[0])),
              ),
            );
          }
        } else {
          final QuerySnapshot hastalikSorularRef = await FirebaseFirestore
              .instance
              .collection('hastaliklar')
              .doc(kabulEdilenHastaliklar[0])
              .collection("sorular")
              .get();
          final int documentsKabulEdilenHastalik =
              hastalikSorularRef.docs.length;

          for (int z = 0; z < documentsKabulEdilenHastalik; z++) {
            int varmiSecilmisSorular = 0;
            for (int i = 0; i < secilmisSorular.length; i++) {
              if (int.parse(hastalikSorularRef.docs[z].id) ==
                  secilmisSorular[i]) {
                varmiSecilmisSorular = 1;
              }
            }
            if (varmiSecilmisSorular == 0) {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      TestSayfasi(r: int.parse(hastalikSorularRef.docs[z].id)),
                ),
              );
              break;
            }
          }
        }
      }
      print("secilmisSorular son hali: $secilmisSorular");
      print("kabulEdilenHastaliklar son hali: $kabulEdilenHastaliklar");
      print("redEdilenHastaliklar son hali: $redEdilenHastaliklar");

      if (kabulEdilenHastaliklar.isEmpty) {
        //boşsa
        if (redEdilenHastaliklar.length == 8) {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => SonucSayfasi(r: 9),
            ),
          );
        } else {
          randomDegerAl();
        }
      }
    }

    return StreamBuilder<QuerySnapshot>(
      stream: sorularRef.snapshots(),
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
                      gelenSorular(snapshot, widget.r, kabulEdilenHastalikEkle,
                          redEdilenHastalikEkle),
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

  Center gelenSorular(
      AsyncSnapshot<dynamic> snapshot,
      int r,
      void Function() kabulEdilenHastalikEkle,
      void Function() redEdilenHastalikEkle) {
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
                  '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "${snapshot.data!.docs[r - 10]['soru_icerik']}",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.brown),
                      label: const Text('EVET'),
                      icon: const Icon(Icons.thumb_up_alt_rounded),
                      onPressed: () {
                        kabulEdilenHastalikEkle();
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.brown),
                      label: const Text('HAYIR'),
                      icon: const Icon(Icons.thumb_down_alt_rounded),
                      onPressed: () {
                        redEdilenHastalikEkle();
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
