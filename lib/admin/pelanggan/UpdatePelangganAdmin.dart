import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/admin/homepageadmin.dart';

class UpdatePelangganAdmin extends StatefulWidget {
  final int PelangganID;
  const UpdatePelangganAdmin({super.key, required this.PelangganID});

  @override
  State<UpdatePelangganAdmin> createState() => _UpdatePelangganAdminState();
}

class _UpdatePelangganAdminState extends State<UpdatePelangganAdmin> {
  final _np = TextEditingController();
  final _alm = TextEditingController();
  final _nmt = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tampilpelanggan();
  }

  Future<void> tampilpelanggan() async{

    final data = await Supabase.instance.client.from('pelanggan').select().eq('PelangganID', widget.PelangganID).single();
    setState(() {
      _np.text = data['NamaPelanggan'] ?? '';
      _alm.text = data['Alamat'] ?? '';
      _nmt.text = data['NomorTelepon'] ?? '';
    });
  }

  Future<void> UpdatePelangganAdmin() async{
    if(_formKey.currentState!.validate()){
      await Supabase.instance.client.from('pelanggan').update({
      'NamaPelanggan': _np.text.trim(),
      'Alamat': _alm.text.trim(),
      'NomorTelepon': _nmt.text.trim(),
    }).eq('PelangganID', widget.PelangganID);
    
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
    
  }
    }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Pelanggan'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _np,
                decoration: InputDecoration(
                  labelText:'Nama Pelanggan',
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
                controller: _alm,
                decoration: InputDecoration(
                  labelText:'Alamat',
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
                controller: _nmt,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText:'Nomor Telepon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                validator: (value) {
                  
                  if(value == null || value.isEmpty){
                    return 'tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: UpdatePelangganAdmin, child: Text('update'))
            ],
          )
        ),
      ),
    );
  }
}