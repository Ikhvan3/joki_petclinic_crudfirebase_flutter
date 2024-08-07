import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class InputJenisHewanPage extends StatefulWidget {
  @override
  _InputJenisHewanPageState createState() => _InputJenisHewanPageState();
}

class _InputJenisHewanPageState extends State<InputJenisHewanPage> {
  final databaseReference =
      FirebaseDatabase.instance.ref().child('jenis_hewan');
  List<Map<String, dynamic>> jenisHewanList = [];

  @override
  void initState() {
    super.initState();
    _getJenisHewan();

    databaseReference.onChildRemoved.listen((event) {
      setState(() {
        jenisHewanList.removeWhere((item) => item['key'] == event.snapshot.key);
      });
    });
  }

  void _getJenisHewan() {
    databaseReference.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          jenisHewanList.add({
            'key': event.snapshot.key,
            'kode_hewan': data['kode_hewan'] as String? ?? '',
            'jenis_hewan': data['jenis_hewan'] as String? ?? '',
          });
        });
      }
    });

    databaseReference.onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          int index = jenisHewanList
              .indexWhere((item) => item['key'] == event.snapshot.key);
          if (index != -1) {
            jenisHewanList[index] = {
              'key': event.snapshot.key,
              'kode_hewan': data['kode_hewan'] as String? ?? '',
              'jenis_hewan': data['jenis_hewan'] as String? ?? '',
            };
          }
        });
      }
    });
  }

  void _showAddDialog() {
    String kodeHewan = '';
    String jenisHewan = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Jenis Hewan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: Color.fromARGB(255, 217, 217, 217),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Kode Hewan'),
                    onChanged: (value) => kodeHewan = value,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Color.fromARGB(255, 217, 217, 217),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Jenis Hewan'),
                    onChanged: (value) => jenisHewan = value,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () {
                databaseReference.push().set({
                  'kode_hewan': kodeHewan,
                  'jenis_hewan': jenisHewan,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editJenisHewan(String key, Map<String, dynamic> jenisHewan) {
    String kodeHewan = jenisHewan['kode_hewan'] as String? ?? '';
    String namaJenisHewan = jenisHewan['jenis_hewan'] as String? ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Jenis Hewan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: Color.fromARGB(255, 217, 217, 217),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Kode Hewan'),
                    controller: TextEditingController(text: kodeHewan),
                    onChanged: (value) => kodeHewan = value,
                  ),
                ),
              ),
              Card(
                color: Color.fromARGB(255, 217, 217, 217),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Jenis Hewan'),
                    controller: TextEditingController(text: namaJenisHewan),
                    onChanged: (value) => namaJenisHewan = value,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () {
                databaseReference.child(key).update({
                  'kode_hewan': kodeHewan,
                  'jenis_hewan': namaJenisHewan,
                }).then((_) {
                  // Update local list
                  setState(() {
                    int index =
                        jenisHewanList.indexWhere((item) => item['key'] == key);
                    if (index != -1) {
                      jenisHewanList[index] = {
                        'key': key,
                        'kode_hewan': kodeHewan,
                        'jenis_hewan': namaJenisHewan,
                      };
                    }
                  });
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteJenisHewan(String key) {
    databaseReference.child(key).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input Jenis Hewan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 206, 99, 255),
      ),
      body: ListView.builder(
        itemCount: jenisHewanList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Color.fromARGB(255, 226, 164, 255),
            child: ListTile(
              title: Text(
                '\Kode Hewan : ${jenisHewanList[index]['kode_hewan']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '\Jenis Hewan     : ${jenisHewanList[index]['jenis_hewan']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editJenisHewan(
                      jenisHewanList[index]['key'] as String? ?? '',
                      jenisHewanList[index],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _deleteJenisHewan(jenisHewanList[index]['key']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
    );
  }
}
