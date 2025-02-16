import 'package:flutter/material.dart';
import 'package:ukk_2025/detail/indexdetail.dart';
import 'package:ukk_2025/pelanggan/indexpelanggan.dart';
import 'package:ukk_2025/penjualan/indexpenjualan.dart';
import 'package:ukk_2025/produk/indexproduk.dart';
import 'package:ukk_2025/user/indexuser.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 5, child:
    Scaffold(
      appBar: AppBar(
        bottom: TabBar(tabs:
        [
          Tab(icon: Icon(Icons.person), child: Text('User')),
          Tab(icon: Icon(Icons.person_2), child: Text('pelanggan')),
          Tab(icon: Icon(Icons.inventory), child: Text('Produk')),
          Tab(icon: Icon(Icons.shopping_cart), child: Text('Penjualan')),
          Tab(icon: Icon(Icons.shopping_bag), child: Text('Detail Penjualan')),
        ]),
      ),
      body: TabBarView(children: [
        UserTab(),
        PelangganTab(),
        ProdukTap(),
        PenjualanTab(),
        DetailTab(),
      ],),
    )
    );
  }
}