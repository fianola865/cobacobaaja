import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class GrafikAdmin extends StatefulWidget {
  const GrafikAdmin({super.key});

  @override
  State<GrafikAdmin> createState() => _GrafikAdminState();
}

class _GrafikAdminState extends State<GrafikAdmin> {
  List<Map<String, dynamic>> penjualan = [];
  bool isLoading = true;
  Map<String, double> salesData = {}; // Total penjualan per tanggal

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select('TanggalPenjualan, TotalHarga');

      debugPrint('Data dari Supabase: $response'); // Debug

      if (response.isNotEmpty) {
        setState(() {
          penjualan = List<Map<String, dynamic>>.from(response);
          _prepareSalesData(); // Persiapkan data
          isLoading = false;
        });

        debugPrint('Sales Data setelah diproses: $salesData'); // Debug
      } else {
        debugPrint('Tidak ada data penjualan.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _prepareSalesData() {
    salesData.clear(); // Reset data

    for (var pjl in penjualan) {
      String? rawDate = pjl['TanggalPenjualan'];
      double? totalHarga = pjl['TotalHarga']?.toDouble();

      if (rawDate != null && totalHarga != null) {
        try {
          DateTime parsedDate = DateTime.parse(rawDate);
          String finalDate = "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";

          if (salesData.containsKey(finalDate)) {
            salesData[finalDate] = salesData[finalDate]! + totalHarga;
          } else {
            salesData[finalDate] = totalHarga;
          }
        } catch (e) {
          debugPrint('Error parsing date ($rawDate): $e');
        }
      }
    }

    debugPrint('Final Sales Data: $salesData'); // Debug
  }

  List<FlSpot> _getSalesChartData() {
    List<FlSpot> spots = [];
    int index = 0;

    salesData.entries.toList().asMap().forEach((i, entry) {
      spots.add(FlSpot(i.toDouble(), entry.value));
    });

    debugPrint('FlSpot Data: $spots'); // Debugging
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colors.grey, size: 30),
            )
          : salesData.isEmpty
              ? const Center(child: Text("Tidak ada data penjualan"))
              : Column(
                  children: [
                    // Grafik Penjualan
                    SizedBox(
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitles: (value) => value.toInt().toString(),
                            ),
                            bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 1,
                              getTitles: (value) {
                                int index = value.toInt();
                                if (index >= 0 &&
                                    index < salesData.keys.length) {
                                  return salesData.keys.elementAt(index);
                                }
                                return '';
                              },
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _getSalesChartData(),
                              isCurved: true,
                              colors: [Colors.blue],
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                colors: [Colors.blue.withOpacity(0.3)],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Riwayat Penjualan dalam ListView
                    Expanded(
                      child: ListView.builder(
                        itemCount: salesData.length,
                        itemBuilder: (context, index) {
                          String date = salesData.keys.elementAt(index);
                          double total = salesData[date]!;
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: const Icon(Icons.calendar_today),
                              title: Text(
                                date,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                "Rp ${total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
