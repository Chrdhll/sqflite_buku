import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_buku/helper/db_helper.dart';
import 'package:sqflite_buku/model/model_buku.dart';

class AddDataBuku extends StatefulWidget {
  const AddDataBuku({super.key});

  @override
  State<AddDataBuku> createState() => _AddDataBukuState();
}

class _AddDataBukuState extends State<AddDataBuku> {
  var _judulBukuController = TextEditingController();
  var _kategoriBukuController = TextEditingController();

  bool _validateJudul = false;
  bool _validateKategori = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Data Buku')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Buku',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _judulBukuController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Masukkan Judul Buku',
                  labelText: 'Judul Buku',
                  errorText: _validateJudul ? 'Judul tidak boleh kosong' : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _kategoriBukuController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Masukkan Kategori Buku',
                  labelText: 'Kategori Buku',
                  errorText:
                      _validateKategori ? 'Kategori tidak boleh kosong ' : null,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.teal,
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _validateJudul = _judulBukuController.text.isEmpty;
                        _validateKategori =
                            _kategoriBukuController.text.isEmpty;
                      });

                      if (!_validateJudul && !_validateKategori) {
                        // Simpan ke database
                        var _buku = ModelBuku(
                          judulBuku: _judulBukuController.text,
                          kategori: _kategoriBukuController.text,
                        );

                        var result = await DatabaseHelper.instance.insertBuku(
                          _buku,
                        );
                        Navigator.pop(context, result);
                      }
                    },
                    child: Text(
                      'Save Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _judulBukuController.text = '';
                      _kategoriBukuController.text = '';
                    },
                    child: Text(
                      'Clear Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
