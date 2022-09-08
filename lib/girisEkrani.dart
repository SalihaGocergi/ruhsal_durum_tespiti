import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ruhsal_durum_tespiti/hastalikTablosu.dart';
import 'package:ruhsal_durum_tespiti/hastalikTablosu2.dart';
import 'package:ruhsal_durum_tespiti/testSayfasi.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({Key? key}) : super(key: key);

  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    int min = 10, max = 35;
    int r = min + random.nextInt(max - min);
    print("Random sayi= $r");
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[Color(0xFF6F4C5B), Color(0xFFDEBA9D)]),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            const Text(
              "Ruhsal Durum",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 70,
                  fontFamily: "Architects Daughter",
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
            const Text(
              "Tespiti",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 70,
                  fontFamily: "Architects Daughter",
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(
              height: 150,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  primary: const Color(0xFF781D42),
                  backgroundColor: const Color(0xFFDEBA9D),
                  textStyle: const TextStyle(
                      fontSize: 40,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => TestSayfasi(r: r),
                  ),
                );
              },
              child: const Text('TESTE BAŞLA'),
            ),
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    image: AssetImage('assets/okIsareti.png'),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              height: 120,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10)),
                  label: const Text(''),
                  icon: const Icon(
                    Icons.assignment_late_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const HastalikTablosu(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
