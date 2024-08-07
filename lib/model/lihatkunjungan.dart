import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class LihatKunjunganPage extends StatefulWidget {
  @override
  _LihatKunjunganPageState createState() => _LihatKunjunganPageState();
}

class _LihatKunjunganPageState extends State<LihatKunjunganPage> {
  final databaseReference = FirebaseDatabase.instance.ref().child('kunjungan');
  List<Map<String, dynamic>> kunjunganList = [];

  @override
  void initState() {
    super.initState();
    _getKunjungan();

    databaseReference.onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          int index = kunjunganList
              .indexWhere((item) => item['key'] == event.snapshot.key);
          if (index != -1) {
            kunjunganList[index] = {
              'key': event.snapshot.key,
              'tanggal_kunjungan': data['tanggal_kunjungan'] as String? ?? '',
              'jenis_hewan': data['jenis_hewan'] as String? ?? '',
              'nama_hewan': data['nama_hewan'] as String? ?? '',
              'keluhan': data['keluhan'] as String? ?? '',
              'nama_pemilik': data['nama_pemilik'] as String? ?? '',
            };
          }
        });
      }
    });

    databaseReference.onChildRemoved.listen((event) {
      setState(() {
        kunjunganList.removeWhere((item) => item['key'] == event.snapshot.key);
      });
    });
  }

  String convertTanggal(String tanggalString) {
    DateTime tanggal = DateTime.parse(tanggalString);
    return formatTanggal(tanggal);
  }

  String formatTanggal(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  void _getKunjungan() {
    databaseReference.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          kunjunganList.add({
            'key': event.snapshot.key,
            'tanggal_kunjungan':
                convertTanggal(data['tanggal_kunjungan'] as String? ?? ''),
            'jenis_hewan': data['jenis_hewan'] as String? ?? '',
            'nama_hewan': data['nama_hewan'] as String? ?? '',
            'keluhan': data['keluhan'] as String? ?? '',
            'nama_pemilik': data['nama_pemilik'] as String? ?? '',
          });
        });
      }
    });
  }

  void _editKunjungan(String key, Map<String, dynamic> kunjungan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String jenisHewan = kunjungan['jenis_hewan'] as String? ?? '';
        String namaHewan = kunjungan['nama_hewan'] as String? ?? '';
        String keluhan = kunjungan['keluhan'] as String? ?? '';
        String namaPemilik = kunjungan['nama_pemilik'] as String? ?? '';

        return AlertDialog(
          title: Text('Edit Kunjungan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: Color.fromARGB(255, 217, 217, 217),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Jenis Hewan'),
                    controller: TextEditingController(text: jenisHewan),
                    onChanged: (value) => jenisHewan = value,
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
                    decoration: InputDecoration(labelText: 'Nama Hewan'),
                    controller: TextEditingController(text: namaHewan),
                    onChanged: (value) => namaHewan = value,
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
                    decoration: InputDecoration(labelText: 'Keluhan'),
                    controller: TextEditingController(text: keluhan),
                    onChanged: (value) => keluhan = value,
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
                    decoration: InputDecoration(labelText: 'Nama Pemilik'),
                    controller: TextEditingController(text: namaPemilik),
                    onChanged: (value) => namaPemilik = value,
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
                  'tanggal_kunjungan': formatTanggal(DateTime.now()),
                  'jenis_hewan': jenisHewan,
                  'nama_hewan': namaHewan,
                  'keluhan': keluhan,
                  'nama_pemilik': namaPemilik,
                }).then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kunjungan berhasil diperbarui')),
                  );
                }).catchError((error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal memperbarui: $error')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteKunjungan(String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus kunjungan ini?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                databaseReference.child(key).remove().then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kunjungan berhasil dihapus')),
                  );
                }).catchError((error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus: $error')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lihat Kunjungan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 206, 99, 255),
      ),
      body: ListView.builder(
        itemCount: kunjunganList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Color.fromARGB(255, 226, 164, 255),
            child: ListTile(
              title: Text(
                '\Jenis hewan       : ${kunjunganList[index]['jenis_hewan']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '\Nama Hewan           : ${kunjunganList[index]['nama_hewan']}'),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        '\Tanggal kunjungan : ${kunjunganList[index]['tanggal_kunjungan']}'),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        '\ Nama Pemilik        : ${kunjunganList[index]['nama_pemilik']}'),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        '\ Keluhan                  : ${kunjunganList[index]['keluhan']}'),
                  ]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editKunjungan(
                      kunjunganList[index]['key'] as String,
                      Map<String, dynamic>.from(kunjunganList[index]),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _deleteKunjungan(kunjunganList[index]['key']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
