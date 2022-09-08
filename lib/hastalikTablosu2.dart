import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HastalikTablosu2 extends StatefulWidget {
  const HastalikTablosu2({Key? key}) : super(key: key);

  @override
  _HastalikTablosu2State createState() => _HastalikTablosu2State();
}

//BURADA TEK BİR VERİYE ULAŞABİLİYORUZZZZ
class _HastalikTablosu2State extends State<HastalikTablosu2> {
  Future getHastalik() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("hastaliklar").get();

    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('hastaliklar').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          var items = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return Text("${ds["hastalik_adi"]}");
            },
          );
        },
      ),
    );
  }
}
