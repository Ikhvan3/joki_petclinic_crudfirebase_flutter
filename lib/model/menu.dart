import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'inputjenishewan.dart';
import 'inputkunjungan.dart';
import 'lihatkunjungan.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 61, 181, 255),
              Color.fromARGB(255, 118, 118, 118),
            ])),
        child: Scaffold(
          backgroundColor: Color.fromARGB(48, 255, 255, 255),
          body: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // height: 200,
                  // width: 600,
                  child: Image(
                    // height: 250,
                    // width: 250,
                    image: AssetImage("images/bg2.jpg"),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Builder(
                          builder: (context) {
                            return Card(
                              color: Color.fromARGB(255, 0, 255, 213),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          InputKunjunganPage(),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: RadialGradient(colors: [
                                      Color.fromARGB(255, 2, 152, 252),
                                      Color.fromARGB(255, 0, 255, 213),
                                    ])),
                                    height: 170,
                                    width: 150,
                                    child: Column(
                                      children: [
                                        Image(
                                          height: 120,
                                          image:
                                              AssetImage("images/inputpl1.png"),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          width: 160,
                                          color: const Color.fromARGB(
                                              255, 0, 101, 152),
                                          child: Text(
                                            "INPUT KUNJUNGAN",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            return Card(
                              color: Color.fromARGB(255, 0, 255, 213),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          InputJenisHewanPage(),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: RadialGradient(colors: [
                                      Color.fromARGB(255, 2, 152, 252),
                                      Color.fromARGB(255, 0, 255, 213),
                                    ])),
                                    height: 170,
                                    width: 150,
                                    child: Column(
                                      children: [
                                        Image(
                                          height: 120,
                                          image:
                                              AssetImage("images/inputhw.png"),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          width: 160,
                                          color: const Color.fromARGB(
                                              255, 0, 101, 152),
                                          child: Text(
                                            "INPUT JENIS HEWAN",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                      color: Color.fromARGB(255, 0, 255, 213),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LihatKunjunganPage(),
                            ),
                          );
                        },
                        child: Card(
                          color: Color.fromARGB(255, 0, 255, 213),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: RadialGradient(colors: [
                              Color.fromARGB(255, 2, 152, 252),
                              Color.fromARGB(255, 0, 255, 213),
                            ])),
                            height: 170,
                            width: 160,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image(
                                    height: 100,
                                    image: AssetImage("images/view1.png"),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 160,
                                  color: const Color.fromARGB(255, 0, 101, 152),
                                  child: Text(
                                    "LIHAT KUNJUNGAN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
