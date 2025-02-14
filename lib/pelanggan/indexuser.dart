import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Pelanggan/insertPelanggan.dart';
import 'package:ukk_2025/Pelanggan/updatePelanggan.dart';

class PelangganTab extends StatefulWidget {
  const PelangganTab({super.key});

  @override
  State<PelangganTab> createState() => _PelangganTabState();
}

class _PelangganTabState extends State<PelangganTab> {
  List<Map<String, dynamic>> Pelanggan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> deletePelanggan(int id) async {
    try {
      await Supabase.instance.client.from('pelanggan').delete().eq('PelangganID', id);
      fetchPelanggan();
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> fetchPelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        Pelanggan = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('error $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.grey, size: 30),
            )
          : Pelanggan.isEmpty
              ? Center(
                  child: Text(
                    'Pelanggan belum ditambahkan',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: Pelanggan.length,
                  itemBuilder: (context, index) {
                    final planggan = Pelanggan[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: SizedBox(
                        height: 180,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pelangganname: ${Pelanggan['Pelangganname'] ?? 'tidak tersedia'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Password: ${Pelanggan['Password'] ?? 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Role: ${Pelanggan['Role'] ?? 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      final PelangganID = Pelanggan['PelangganID'] ?? 0; // Pastikan ini sesuai dengan kolom di database
                                        if (PelangganID != 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdatePelanggan(PelangganID: PelangganID)
                                            ),
                                          );
                                        } else {
                                          print('ID pelanggan tidak valid');
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(context: context,
                                      builder:(BuildContext context){
                                        return AlertDialog(
                                          title: Text('hapus Pelanggan'),
                                          content: Text('apa anda yakin menghapus data Pelanggan ini?'),
                                          actions: [
                                            ElevatedButton(onPressed: (){
                                              Navigator.pop(context);
                                            }, child: Text('Batal')),
                                            ElevatedButton(onPressed: (){
                                              deletePelanggan(Pelanggan['PelangganID']);
                                              Navigator.pop(context);
                                            }, child: Text('Hapus'))
                                          ],
                                        );
                                      }
                                      );
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              floatingActionButton: FloatingActionButton(onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => InsertPelanggan()));
              },
              child: Icon(Icons.add),
              ),
    );
  }
}