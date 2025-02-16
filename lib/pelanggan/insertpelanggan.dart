import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class InsertPelanggan extends StatefulWidget {
  const InsertPelanggan({super.key});

  @override
  State<InsertPelanggan> createState() => _InsertPelangganState();
}

class _InsertPelangganState extends State<InsertPelanggan> {
  final _np = TextEditingController();
  final _alm = TextEditingController();
  final _nmt = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> InsertPelanggan() async {
    if (_formKey.currentState!.validate()) {
      final np = _np.text.trim();
      final alm = _alm.text.trim();
      final nmt = _nmt.text.trim();

      await Supabase.instance.client.from('user').insert({
        'NamaPelanggan': np,
        'Alamat': alm,
        'NomorTelepon': nmt
      });

      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()));
       
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah User'),

      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _np,
                decoration: InputDecoration(
                  labelText: 'Nama Pelanggan',
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
                controller: _alm,
                decoration: InputDecoration(
                  labelText: 'Alamat',
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
                controller: _nmt,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
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
              ElevatedButton(
                onPressed: InsertPelanggan,
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
