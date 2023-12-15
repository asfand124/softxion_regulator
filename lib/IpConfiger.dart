import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animations/simple_animations.dart';

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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 177, 175, 175),
        elevation: 0,
        title: Center(
          child: Text(
            'IP Address',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Container(
        color: Colors.cyanAccent,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ip From Db',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: GoogleFonts.cabin().fontFamily,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                             
                              Text(
                                ' Current IP',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: GoogleFonts.dhurjati().fontFamily,
                                    fontWeight: FontWeight.w700),
                              ),
                            ]),
                      ),
                      SizedBox(height: 40,),
                      Row(
                        children: [
                          Text(
                            '$_IpFromDb',
                            style: TextStyle(
                                fontFamily: GoogleFonts.inter().fontFamily,fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 74,
                          ),
                          Text(
                            '$_IpCurrent',
                            style: TextStyle(
                                fontFamily: GoogleFonts.cabin().fontFamily,fontSize: 15,fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: setIpInDB,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                    child: Text(
                  'Update',
                  style: TextStyle(
                      fontFamily: GoogleFonts.cabin().fontFamily,
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
