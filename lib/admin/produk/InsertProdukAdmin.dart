import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/homepageadmin.dart';

class InsertProdukAdminAdmin extends StatefulWidget {
  const InsertProdukAdminAdmin({super.key});

  @override
  State<InsertProdukAdminAdmin> createState() => _InsertProdukAdminAdminState();
}

class _InsertProdukAdminAdminState extends State<InsertProdukAdminAdmin> {
  final _nmp = TextEditingController();
  final _hrg = TextEditingController();
  final _stk = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> InsertProdukAdminAdmin() async {
    if (_formKey.currentState!.validate()) {
      final nmp = _nmp.text.trim();
      final hrg = _hrg.text.trim();
      final stk = _stk.text.trim();

      await Supabase.instance.client.from('produk').insert({
        'NamaProduk': nmp,
        'Harga': hrg,
        'Stok': stk
      });

      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePageAdmin()));
       
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),

      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                    return 'tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                    return 'tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                    return 'tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: InsertProdukAdminAdmin,
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
