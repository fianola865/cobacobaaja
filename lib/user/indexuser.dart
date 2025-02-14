import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/user/insertuser.dart';
import 'package:ukk_2025/user/updateuser.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  List<Map<String, dynamic>> user = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchuser();
  }

  Future<void> deleteuser(int id) async {
    try {
      await Supabase.instance.client.from('user').delete().eq('UserID', id);
      fetchuser();
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> fetchuser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('user').select();
      setState(() {
        user = List<Map<String, dynamic>>.from(response);
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
          : user.isEmpty
              ? Center(
                  child: Text(
                    'User belum ditambahkan',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    final User = user[index];
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
                                'Username: ${User['Username'] ?? 'tidak tersedia'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Password: ${User['Password'] ?? 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Role: ${User['Role'] ?? 'tidak tersedia'}',
                                style: TextStyle(fontSize: 18),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      final UserID = User['UserID'] ?? 0; // Pastikan ini sesuai dengan kolom di database
                                        if (UserID != 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdateUser(UserID: UserID)
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
                                          title: Text('hapus user'),
                                          content: Text('apa anda yakin menghapus data user ini?'),
                                          actions: [
                                            ElevatedButton(onPressed: (){
                                              Navigator.pop(context);
                                            }, child: Text('Batal')),
                                            ElevatedButton(onPressed: (){
                                              deleteuser(User['UserID']);
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUser()));
              },
              child: Icon(Icons.add),
              ),
    );
  }
}