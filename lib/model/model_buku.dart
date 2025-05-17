class ModelBuku {
  final int? id;
  final String judulBuku;
  final String kategori;

  ModelBuku({this.id, required this.judulBuku, required this.kategori});

  //insert data ke dalam map
  Map<String, dynamic> toMap() {
    return {'id': id, 'judulbuku': judulBuku, 'kategori': kategori};
  }

  //get data
  factory ModelBuku.fromMap(Map<String, dynamic> map) {
    return ModelBuku(
      id: map['id'],
      judulBuku: map['judulbuku'],
      kategori: map['kategori'],
    );
  }
}
