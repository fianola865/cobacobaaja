import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/homepageadmin.dart';

class UpdateProdukAdmin extends StatefulWidget {
  final int ProdukID;
  const UpdateProdukAdmin({super.key, required this.ProdukID});

  @override
  State<UpdateProdukAdmin> createState() => _UpdateProdukAdminState();
}

class _UpdateProdukAdminState extends State<UpdateProdukAdmin> {
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

    // Cek jika data tidak ditemukan
    if (response == null) {
      throw Exception('Data produk tidak ditemukan');
    }

    setState(() {
      _nmp.text = response['NamaProduk'] ?? '';
      _hrg.text = response['Harga']?.toString() ?? '';
      _stk.text = response['Stok']?.toString() ?? '';
    });
  } catch (e) {
    print('Error: $e');
  }
}


  // Fungsi untuk mengupdate produk
  Future<void> UpdateProdukAdmin() async {
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
          MaterialPageRoute(builder: (context) => HomePageAdmin()),
        );
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageAdmin()));
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
                onPressed: UpdateProdukAdmin,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
