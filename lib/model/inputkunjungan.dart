import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class InputKunjunganPage extends StatefulWidget {
  @override
  _InputKunjunganPageState createState() => _InputKunjunganPageState();
}

class _InputKunjunganPageState extends State<InputKunjunganPage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  List<String> jenisHewanList = [];
  String selectedJenisHewan = '';
  final namaHewanController = TextEditingController();
  final keluhanController = TextEditingController();
  final namaPemilikController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getJenisHewan();
  }

  void _getJenisHewan() {
    databaseReference.child('jenis_hewan').onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        if (data.containsKey('jenis_hewan')) {
          setState(() {
            jenisHewanList.add(data['jenis_hewan'] as String);
          });
        }
      }
    });
  }

  void _saveKunjungan() {
    final now = DateTime.now();
    databaseReference.child('kunjungan').push().set({
      'tanggal_kunjungan': now.toIso8601String(),
      'jenis_hewan': selectedJenisHewan,
      'nama_hewan': namaHewanController.text,
      'keluhan': keluhanController.text,
      'nama_pemilik': namaPemilikController.text,
    });

    // Clear form
    setState(() {
      selectedJenisHewan = '';
      namaHewanController.clear();
      keluhanController.clear();
      namaPemilikController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kunjungan berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input Kunjungan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 206, 99, 255),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Color.fromARGB(255, 226, 164, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  value:
                      selectedJenisHewan.isNotEmpty ? selectedJenisHewan : null,
                  items: jenisHewanList.map((jenis) {
                    return DropdownMenuItem(value: jenis, child: Text(jenis));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedJenisHewan = value.toString();
                    });
                  },
                  decoration: InputDecoration(labelText: 'Jenis Hewan'),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              color: Color.fromARGB(255, 226, 164, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: namaHewanController,
                  decoration: InputDecoration(labelText: 'Nama Hewan'),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              color: Color.fromARGB(255, 226, 164, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: keluhanController,
                  decoration: InputDecoration(labelText: 'Keluhan'),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              color: Color.fromARGB(255, 226, 164, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: namaPemilikController,
                  decoration: InputDecoration(labelText: 'Nama Pemilik'),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(
                'Simpan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _saveKunjungan,
            ),
          ],
        ),
      ),
    );
  }
}
