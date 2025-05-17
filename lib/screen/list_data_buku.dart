import 'package:flutter/material.dart';
import 'package:sqflite_buku/helper/db_helper.dart';
import 'package:sqflite_buku/model/model_buku.dart';

class ListDataBuku extends StatefulWidget {
  const ListDataBuku({super.key});

  @override
  State<ListDataBuku> createState() => _ListDataBukuState();
}

class _ListDataBukuState extends State<ListDataBuku> {
  List<ModelBuku> _buku = [];

  @override
  void initState() {
    DatabaseHelper.instance.dumyBuku();
    super.initState();
    _fetchDataBuku();
  }

  Future<void> _fetchDataBuku() async {
    final bukuMaps = await DatabaseHelper.instance.quaryAllBuku();
    setState(() {
      _buku = bukuMaps.map((bukuMaps) => ModelBuku.fromMap(bukuMaps)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Data Buku')),
      body: ListView.builder(
        itemCount: _buku.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_buku[index].judulBuku),
            subtitle: Text(_buku[index].kategori),
          );
        },
      ),
    );
  }
}
