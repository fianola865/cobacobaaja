import 'package:flutter/material.dart'; 
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/produk/harga.dart';
import 'package:ukk_2025/produk/insertproduk.dart';
import 'package:ukk_2025/produk/updateproduk.dart';

class ProdukTap extends StatefulWidget {
  const ProdukTap({super.key});

  @override
  State<ProdukTap> createState() => _ProdukTapState();
}

class _ProdukTapState extends State<ProdukTap> {
  List<Map<String, dynamic>> produk = [];
  List<Map<String, dynamic>> filteredProduk = [];
  bool isLoading = true;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchproduk();
  }

  Future<void> deleteproduk(int id) async{
    await Supabase.instance.client.from('produk').delete().eq('UserID', id);
    fetchproduk();
  }

  Future<void> fetchproduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        filteredProduk = produk; 
        isLoading = false;
      });
    } catch (e) {
      print('error $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchProduk(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProduk = produk; // Jika kosong, tampilkan semua
      } else {
        filteredProduk = produk
            .where((prd) => prd['NamaProduk']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: searchProduk,
          decoration: InputDecoration(
            hintText: 'Cari produk...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.grey, size: 30),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: filteredProduk.length,
              itemBuilder: (context, index) {
                final prd = filteredProduk[index];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => harga(produk: prd)));
                  },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      prd['NamaProduk'] ?? 'tidak tersedia',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga: ${prd['Harga'] ?? 'tidak tersedia'}'),
                        Text('Stok: ${prd['Stok'] ?? 'tidak tersedia'}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            final ProdukID = prd['ProdukID'] ?? 0;
                            if (ProdukID != 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => 
                                      UpdateProduk(ProdukID: ProdukID),
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteproduk(prd['ProdukID']);
                          },
                        ),
                      ],
                    ),
                  ),
                )
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => InsertProduk()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
