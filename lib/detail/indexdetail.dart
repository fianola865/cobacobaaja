import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DetailTab extends StatefulWidget {
  const DetailTab({super.key});

  @override
  State<DetailTab> createState() => _DetailTabState();
}

class _DetailTabState extends State<DetailTab> {
  List<Map<String, dynamic>> detail = [];
  bool isLoading = true;
  Map<int, bool> selectedProduk = {};
  double totalHarga = 0.0;

  @override
  void initState() {
    super.initState();
    fetchdetail();
  }

  Future<void> fetchdetail() async {
    setState(() => isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*, penjualan(*, pelanggan(*)), produk(*)');

      setState(() {
        detail = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void toggleProdukSelection(int produkID, double harga) {
    setState(() {
      selectedProduk[produkID] = !(selectedProduk[produkID] ?? false);
      totalHarga = selectedProduk[produkID]! ? totalHarga + harga : totalHarga - harga;
    });
  }

  Future<void> insertDetailPenjualan() async {
    List<Map<String, dynamic>> produkDipilih = detail.where((dtl) {
      int? produkID = dtl['produk']?['ProdukID'] as int?;
      return produkID != null && selectedProduk[produkID] == true;
    }).map((dtl) {
      return {
        'PelangganID': dtl['penjualan']?['PelangganID'],
        'TotalHarga': (dtl['Subtotal'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();

    if (produkDipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pilih minimal satu produk!")),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('penjualan').insert(produkDipilih);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Produk berhasil dipesan!")),
      );
      setState(() {
        selectedProduk.clear();
        totalHarga = 0.0;
      });
    } catch (e) {
      debugPrint("Error saat insert: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memesan produk: $e")),
      );
    }
  }

  Future<void> generatePDF() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Detail Penjualan",
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['Produk', 'Jumlah', 'Subtotal'],
                  data: detail.where((dtl) {
                    int? produkID = dtl['produk']?['ProdukID'] as int?;
                    return produkID != null && selectedProduk[produkID] == true;
                  }).map((dtl) {
                    return [
                      dtl['produk']?['NamaProduk'] ?? '-',
                      dtl['JumlahProduk'].toString(),
                      'Rp${(dtl['Subtotal'] as num?)?.toStringAsFixed(2) ?? '0.00'}'
                    ];
                  }).toList(),
                  border: pw.TableBorder.all(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
                pw.SizedBox(height: 10),
                pw.Text("Total Harga: Rp${totalHarga.toStringAsFixed(2)}",
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          debugPrint("Mencetak PDF...");
          return pdf.save();
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Error saat mencetak PDF: $e");
      debugPrint(stackTrace.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mencetak PDF: $e")),
      );
    }
  }

  void showOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pilih Opsi"),
        content: Text("Ingin memesan sekarang atau mencetak PDF?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              insertDetailPenjualan();
            },
            child: Text("Pesan Sekarang"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              generatePDF();
            },
            child: Text("Cetak PDF"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: LoadingAnimationWidget.twoRotatingArc(color: Colors.grey, size: 30))
          : detail.isEmpty
              ? Center(child: Text('Penjualan belum ditambahkan', style: TextStyle(fontSize: 18)))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: detail.length,
                        itemBuilder: (context, index) {
                          final dtl = detail[index];
                          int produkID = dtl['produk']?['ProdukID'] ?? 0;
                          double harga = (dtl['Subtotal'] as num?)?.toDouble() ?? 0.0;
                          return Card(
                            key: ValueKey(produkID),
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: Checkbox(
                                value: selectedProduk[produkID] ?? false,
                                onChanged: (bool? value) => toggleProdukSelection(produkID, harga),
                              ),
                              title: Text(
                                'Nama Produk: ${dtl['produk']?['NamaProduk'] ?? '-'}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nama Pelanggan: ${dtl['penjualan']?['pelanggan']?['NamaPelanggan'] ?? '-'}',
                                  ),
                                  Text('Jumlah Produk: ${dtl['JumlahProduk'] ?? 'tidak tersedia'}'),
                                  Text(
                                    'Total Harga: Rp${harga.toStringAsFixed(2)}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        onPressed: showOrderDialog,
                        child: Text("Pesan"),
                      ),
                    )
                  ],
                ),
    );
  }
}
