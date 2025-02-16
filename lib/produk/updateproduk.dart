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
    // TODO: implement initState
    super.initState();
    TampilProduk();
  }

  Future<void> TampilProduk() async{

    final data = await Supabase.instance.client.from('produk').select().eq('ProdukID', widget.ProdukID).single();
    setState(() {
      _nmp.text = data['NamaProduk'] ?? '';
      _hrg.text = data['Harga'] ?? '';
      _stk.text = data['Stok'] ?? '';
    });
  }

  Future<void> UpdateProduk() async{
    if(_formKey.currentState!.validate()){
      await Supabase.instance.client.from('produk').update({
      'NamaProduk': _nmp.text.trim(),
      'Harga': _hrg.text.trim(),
      'Stok': _stk.text.trim(),
    }).eq('ProdukID', widget.ProdukID);
    
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    
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
              TextFormField(
                controller: _nmp,
                decoration: InputDecoration(
                  labelText:'Nama Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ) 
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _hrg,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:'Harga',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ) 
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _stk,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:'Stok',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: UpdateProduk, child: Text('update'))
            ],
          )
        ),
      ),
    );
  }
}