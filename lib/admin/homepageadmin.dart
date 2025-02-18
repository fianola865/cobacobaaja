import 'package:flutter/material.dart';
import 'package:ukk_2025/admin/detail/IndexDetailAdmin.dart';
import 'package:ukk_2025/admin/pelanggan/IndexPelangganAdmin.dart';
import 'package:ukk_2025/admin/penjualan/IndexPenjualanAdmin.dart';
import 'package:ukk_2025/admin/penjualan/grafik.dart';
import 'package:ukk_2025/admin/produk/IndexProdukAdmin.dart';
import 'package:ukk_2025/admin/user/IndexUserAdmin.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'menu', // Ganti dengan nama admin yang sesuai
                      style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.green),
                title: Text('User'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IndexUserAdmin()));
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart, color: Colors.green),
                title: Text('Penjualan'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IndexPenjualanAdmin()));
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag, color: Colors.green),
                title: Text('Detail Penjualan'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IndexDetailAdmin()));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Es Teh Borcelle',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.bar_chart, color: Colors.green), text: 'Grafik'),
              Tab(icon: Icon(Icons.person_2, color: Colors.green), text: 'Pelanggan'),
              Tab(icon: Icon(Icons.inventory, color: Colors.green), text: 'Produk'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GrafikAdmin(),
            IndexPelangganAdmin(),
            IndexProdukAdmin(),
          ],
        ),
      ),
    );
  }
}
