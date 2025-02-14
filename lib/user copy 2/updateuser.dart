import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/homepage.dart';

class UpdateUser extends StatefulWidget {
  final int UserID;
  const UpdateUser({super.key, required this.UserID});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _usr = TextEditingController();
  final _pw = TextEditingController();
  final _role = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tampiluser();
  }

  Future<void> tampiluser() async{

    final data = await Supabase.instance.client.from('user').select().eq('UserID', widget.UserID).single();
    setState(() {
      _usr.text = data['Username'] ?? '';
      _pw.text = data['Password'] ?? '';
      _role.text = data['Role'] ?? '';
    });
  }

  Future<void> updateuser() async{
    if(_formKey.currentState!.validate()){
      await Supabase.instance.client.from('user').update({
      'Username': _usr.text.trim(),
      'Password': _pw.text.trim(),
      'Role': _role.text.trim(),
    }).eq('UserID', widget.UserID);
    
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    
  }
    }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usr,
                decoration: InputDecoration(
                  labelText:'Username',
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
                controller: _pw,
                decoration: InputDecoration(
                  labelText:'Password',
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
                controller: _role,
                decoration: InputDecoration(
                  labelText:'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                validator: (value) {
                  if(value != 'petugas' && value != 'admin'){
                    return 'Hanya bole admin dan petugas';
                  }
                  if(value == null || value.isEmpty){
                    return 'tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: updateuser, child: Text('update'))
            ],
          )
        ),
      ),
    );
  }
}