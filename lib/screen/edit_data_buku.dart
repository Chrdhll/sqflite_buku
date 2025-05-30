import 'package:flutter/material.dart';
import 'package:sqflite_buku/helper/db_helper.dart';
import 'package:sqflite_buku/model/model_buku.dart';

class EditDataBuku extends StatefulWidget {
  final ModelBuku buku;
  const EditDataBuku({super.key, required this.buku});

  @override
  State<EditDataBuku> createState() => _EditDataBukuState();
}

class _EditDataBukuState extends State<EditDataBuku> {
  late TextEditingController _judulBukuController;
  late TextEditingController _kategoriBukuController;

  bool _validateJudul = false;
  bool _validateKategori = false;

  @override
  void initState() {
    super.initState();
    _judulBukuController = TextEditingController(text: widget.buku.judulBuku);
    _kategoriBukuController = TextEditingController(text: widget.buku.kategori);
  }

  @override
  void dispose() {
    _judulBukuController.dispose();
    _kategoriBukuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Data Buku')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Buku',
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
                    style: TextButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () async {
                      setState(() {
                        _validateJudul = _judulBukuController.text.isEmpty;
                        _validateKategori =
                            _kategoriBukuController.text.isEmpty;
                      });

                      if (!_validateJudul && !_validateKategori) {
                        // Update ke database
                        var updatedBuku = ModelBuku(
                          id: widget.buku.id,
                          judulBuku: _judulBukuController.text,
                          kategori: _kategoriBukuController.text,
                        );

                        await DatabaseHelper.instance.updateBuku(updatedBuku);
                        Navigator.pop(
                          context,
                          true,
                        ); // Kembali dengan status berhasil
                      }
                    },
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      _judulBukuController.text = '';
                      _kategoriBukuController.text = '';
                    },
                    child: const Text(
                      'Clear',
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
