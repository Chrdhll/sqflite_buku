import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_buku/helper/db_helper.dart';
import 'package:sqflite_buku/model/model_buku.dart';
import 'package:sqflite_buku/screen/add_data_buku.dart';
import 'package:sqflite_buku/screen/edit_data_buku.dart';

class ListDataBuku extends StatefulWidget {
  const ListDataBuku({super.key});

  @override
  State<ListDataBuku> createState() => _ListDataBukuState();
}

class _ListDataBukuState extends State<ListDataBuku> {
  List<ModelBuku> _buku = [];
  bool _isLoading = false;

  @override
  void initState() {
    _initializeDummyData();
    super.initState();
    _fetchDataBuku();
  }

  Future<void> _initializeDummyData() async {
    final existingData = await DatabaseHelper.instance.queryAllBuku();
    if (existingData.isEmpty) {
      await DatabaseHelper.instance.dumyBuku();
    }
  }

  // Future<void> _fetchDataBuku() async {
  //   final bukuMaps = await DatabaseHelper.instance.quaryAllBuku();
  //   setState(() {
  //     _buku = bukuMaps.map((bukuMaps) => ModelBuku.fromMap(bukuMaps)).toList();
  //   });
  // }

  Future<void> _fetchDataBuku() async {
    setState(() {
      _isLoading = true;
    });
    final bukuMaps = await DatabaseHelper.instance.queryAllBuku();
    setState(() {
      _buku = bukuMaps.map((bukuMaps) => ModelBuku.fromMap(bukuMaps)).toList();
      _isLoading = false;
    });
  }

  _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // _deleteFormDialog(BuildContext context, bukuId) {
  //   return showDialog(
  //     context: context,
  //     builder: (param) {
  //       return AlertDialog(
  //         title: AlertDialog(
  //           title: const Text(
  //             'Are you sure to delete ?',
  //             style: TextStyle(color: Colors.teal, fontSize: 20),
  //           ),
  //           actions: [
  //             TextButton(
  //               style: TextButton.styleFrom(
  //                 foregroundColor: Colors.white,
  //                 backgroundColor: Colors.red,
  //               ),
  //               onPressed: () async {
  //                 var result = await DatabaseHelper.instance.deleteBuku(bukuId);
  //                 if (result != null) {
  //                   Navigator.pop(context);
  //                   _fetchDataBuku();
  //                   _showSuccessSnackbar(
  //                     "Buku dengan ID ${bukuId} berhasil di delete",
  //                   );
  //                 }
  //               },
  //               child: Text('Delete'),
  //             ),
  //             TextButton(
  //               style: TextButton.styleFrom(
  //                 foregroundColor: Colors.white,
  //                 backgroundColor: Colors.teal,
  //               ),
  //               onPressed: () {},
  //               child: Text("Cancel"),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  _deleteFormDialog(BuildContext context, bukuId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Apakah Anda yakin ingin menghapus?',
            style: TextStyle(color: Colors.teal, fontSize: 18),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    //ambil dulu data judul berdasarkan ID
                    var buku = await DatabaseHelper.instance.getBukuById(
                      bukuId,
                    );
                    String judul = buku?.judulBuku ?? 'Buku';

                    //hapus data buku
                    var result = await DatabaseHelper.instance.deleteBuku(
                      bukuId,
                    );
                    if (result != null) {
                      Navigator.pop(context);
                      _fetchDataBuku();
                      _showSuccessSnackbar(
                        "Buku dengan judul $judul berhasil dihapus.",
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Menutup dialog saat cancel
                  },
                  child: const Text('Cancel'),
                ),
              ],
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
        title: Text('List Data Buku'),
        actions: [
          IconButton(
            onPressed: () {
              _fetchDataBuku();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _buku.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_buku[index].judulBuku),
                    subtitle: Text(_buku[index].kategori),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditDataBuku(buku: _buku[index]),
                        ),
                      );

                      if (result == true) {
                        _fetchDataBuku();
                        _showSuccessSnackbar("Data berhasil diubah.");
                      }
                    },
                    onLongPress: () {
                      _deleteFormDialog(context, _buku[index].id);
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDataBuku()),
          ).then((_) => _fetchDataBuku()); // Refresh list setelah tambah
        },
        child: Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}
