import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class IpConfiger extends StatefulWidget {
  const IpConfiger({super.key});

  @override
  State<IpConfiger> createState() => _IpConfigerState();
}

class _IpConfigerState extends State<IpConfiger> {
  String _IpFromDb = '';
  String _IpCurrent = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFormFirebase();
    getCurrentIp();
  }

  getDataFormFirebase() async {
    FirebaseFirestore.instance
        .collection('App Data')
        .doc('Constrains')
        .get()
        .then((value) {
      setState(() {
        _IpFromDb = value.data()!['ip'];
      });
    });
  }

  setIpInDB() async {
    FirebaseFirestore.instance
        .collection('App Data')
        .doc('Constrains')
        .update({'ip': _IpCurrent});
  }

  getCurrentIp() async {
    final response =
        await http.get(Uri.parse('https://api64.ipify.org?format=json'));
    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> data = json.decode(response.body);
      String? ipAddress = data['ip'];
      setState(() {
        _IpCurrent = ipAddress!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 50,
              color: Colors.black,
              child: Column(children: [
                Text(
                  'Ip From Db',
                  style: TextStyle(),
                ),
                Text('$_IpFromDb'),
              ]),
            ),
            SizedBox(
              height: 50,
            ),
            Text('Ip Current'),
            SizedBox(
              height: 50,
            ),
            Text('$_IpCurrent'),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: setIpInDB,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(child: Text('data')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
