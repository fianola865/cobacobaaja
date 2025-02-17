import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class UpdateProduk extends StatefulWidget {
  final int ProdukID;
  const UpdateProduk({super.key, required this.ProdukID});

  @override
  State<UpdateProduk> createState() => _UpdateProdukState();
}

class _UpdateProdukState extends State<UpdateProduk> {
  final _nmp = TextEditingController();
  final _hrg = TextEditingController();
  final _stk = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    TampilProduk();
  }

  // Menampilkan produk berdasarkan ProdukID
  Future<void> TampilProduk() async {
    try {
      final response = await Supabase.instance.client
          .from('produk')
          .select()
          .eq('ProdukID', widget.ProdukID)
          .single();

      if (response != null) {
        throw Exception('Error fetching data: ${response}');
      }

      final data = response;
      setState(() {
        _nmp.text = data['NamaProduk'] ?? '';
        _hrg.text = data['Harga']?.toString() ?? ''; // Pastikan data harga berbentuk string
        _stk.text = data['Stok']?.toString() ?? ''; // Pastikan data stok berbentuk string
      });
    } catch (e) {
      // Menangani error jika ada masalah dalam pengambilan data
      print('Error: $e');
    }
  }

  // Fungsi untuk mengupdate produk
  Future<void> UpdateProduk() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await Supabase.instance.client
            .from('produk')
            .update({
              'NamaProduk': _nmp.text.trim(),
              'Harga': _hrg.text.trim(),
              'Stok': _stk.text.trim(),
            })
            .eq('ProdukID', widget.ProdukID);

        if (response.error != null) {
          throw Exception('Error updating product: ${response.error!.message}');
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } catch (e) {
        // Menangani error jika update gagal
        print('Error updating product: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Produk'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Nama Produk
              TextFormField(
                controller: _nmp,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Harga Produk
              TextFormField(
                controller: _hrg,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Stok Produk
              TextFormField(
                controller: _stk,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Tombol Update
              ElevatedButton(
                onPressed: UpdateProduk,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
