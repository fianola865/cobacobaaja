import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

addPenjualan(BuildContext context, List produk, List pelanggan) {
  final formPelanggan = GlobalKey<FormState>();
  final pelangganCtrl = SingleValueDropDownController();
  List<Map<String, dynamic>> produkBeli = [];
  int totalHarga = 0;
  return showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dialog(child: StatefulBuilder(builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height / 1.2,
                width: MediaQuery.of(context).size.width / 1.3,
                child: LayoutBuilder(builder: (context, constraint) {
                  return Form(
                    key: formPelanggan,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Penjualan",
                         
                        ),
                        SizedBox(
                          height: constraint.maxHeight / 25,
                        ),
                        DropDownTextField(
                          enableSearch: true,
                          controller: pelangganCtrl,
                          dropDownList: [
                            DropDownValueModel(name: "Non member", value: null),
                            ...List.generate(pelanggan.length, (index) {
                              return DropDownValueModel(
                                  name:
                                      "${pelanggan[index]["NamaPelanggan"]}/${pelanggan[index]["NomorTelepon"]}",
                                  value: pelanggan[index]["PelangganID"]);
                            }),
                          ],
                          textFieldDecoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Pilih pelanggan",
                              ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Pilih pelanggan yang akan bertransaksi";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: constraint.maxHeight / 30,
                        ),
                        Container(
                          height: constraint.maxHeight / 2,
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20)),
                          child: produkBeli.isEmpty
                              ? null
                              : ListView(
                                  children: [
                                    ...List.generate(produkBeli.length,
                                        (index) {
                                      return Card(
                                        elevation: 15,
                                        child: ListTile(
                                          title: Text(
                                              "${produkBeli[index]["NamaProduk"]} (${produkBeli[index]["JumlahProduk"]})"),
                                          subtitle: Text(
                                              "Rp.${produkBeli[index]["Subtotal"].toString()}"),
                                          trailing: IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    totalHarga -=
                                                        produkBeli[index]
                                                            ["Subtotal"] as int;
                                                    produkBeli.removeAt(index);
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons.close)),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                        ),
                        SizedBox(
                          height: constraint.maxHeight / 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Total harga:Rp.${totalHarga.toString()}"),
                          ],
                        ),
                        SizedBox(
                          height: constraint.maxHeight / 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  // produk.removeWhere(test)
                                  // produk=produk.where((item)=>item["ProdukID"]).toList();
                                  final jumlahCtrl = TextEditingController();
                                  final produkCtrl =
                                      SingleValueDropDownController();
                                  final formProduk = GlobalKey<FormState>();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                            child: Form(
                                          key: formProduk,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Produk penjualan",
                                                 
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      20,
                                                ),
                                                DropDownTextField(
                                                    enableSearch: true,
                                                    textFieldDecoration:
                                                        InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            labelText:
                                                                "Pilih produk",
                                                            ),
                                                    controller: produkCtrl,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "Pilih barang yang dibeli";
                                                      }
                                                      return null;
                                                    },
                                                    dropDownList: [
                                                      ...List.generate(
                                                          produk.length,
                                                          (index) {
                                                        return DropDownValueModel(
                                                            name:
                                                                "${produk[index]["NamaProduk"]} (${produk[index]["Stok"]})",
                                                            value:
                                                                produk[index]);
                                                      })
                                                    ]),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      25,
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Jumlah yang dibeli tidak boleh kosong";
                                                    } else if (int.parse(
                                                            value) >
                                                        produkCtrl
                                                            .dropDownValue!
                                                            .value["Stok"]) {
                                                      return "Pembelian melebihi stok produk";
                                                    }
                                                    return null;
                                                  },
                                                  controller: jumlahCtrl,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration: InputDecoration(
                                                      labelText: "Jumlah beli",
                                                      
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("Batal",
                                                          ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              foregroundColor:
                                                                  Colors.white),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        if (formProduk
                                                            .currentState!
                                                            .validate()) {
                                                          produkCtrl.dropDownValue!
                                                                      .value[
                                                                  "JumlahProduk"] =
                                                              int.parse(
                                                                  jumlahCtrl
                                                                      .text);
                                                          produkCtrl
                                                                  .dropDownValue!
                                                                  .value[
                                                              "Subtotal"] = (produkCtrl
                                                                      .dropDownValue!
                                                                      .value[
                                                                  "Harga"] *
                                                              int.parse(jumlahCtrl
                                                                  .text)) as int;
                                                          setState(
                                                            () {
                                                              totalHarga += produkCtrl
                                                                      .dropDownValue!
                                                                      .value[
                                                                  "Subtotal"] as int;
                                                              produkBeli.add(
                                                                  produkCtrl
                                                                      .dropDownValue!
                                                                      .value);
                                                            },
                                                          );
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                      child: Text("Simpan"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          20,
                                                                          78,
                                                                          253),
                                                              foregroundColor:
                                                                  Colors.white),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                      });
                                },
                                child: Text("Tambah produk"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 20, 78, 253),
                                    foregroundColor: Colors.white))
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Batal"),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white),
                                ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (formPelanggan.currentState!.validate()) {
                                    if (produkBeli.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "Tambahkan data barang terlebih dahulu",
                                          
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      var penjualan = await Supabase.instance.client
                                          .from("penjualan")
                                          .insert([
                                        {
                                          "PelangganID":
                                              pelangganCtrl.dropDownValue!.value,
                                          "TotalHarga": totalHarga
                                        }
                                      ]).select();
                            
                                      List myDetail = [];
                                      for (var i = 0; i < produkBeli.length; i++) {
                                        myDetail.add({
                                          "PenjualanID": penjualan[0]
                                              ["PenjualanID"],
                                          "ProdukID": produkBeli[i]["ProdukID"],
                                          "JumlahProduk":
                                              produkBeli[i]["JumlahProduk"] as int,
                                          "Subtotal": produkBeli[i]["Subtotal"]
                                        });
                                      }
                            
                                      await Supabase.instance.client
                                          .from("detailpenjualan")
                                          .insert(myDetail);
                            
                                      for (var i = 0; i < produkBeli.length; i++) {
                                        produkBeli[i]["Stok"] -=
                                            produkBeli[i]["JumlahProduk"] as int;
                                        produkBeli[i].remove("JumlahProduk");
                                        produkBeli[i].remove("Subtotal");
                                      }
                            
                                      await Supabase.instance.client
                                          .from("produk")
                                          .upsert(produkBeli);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "Pembayaran berhasil",
                                         
                                        ),
                                        backgroundColor: Colors.green,
                                      ));
                                      Navigator.of(context).pop(true);
                                    }
                                  }
                                },
                                child: Text(
                                  "Bayar",
                                  
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 20, 78, 253),
                                    foregroundColor: Colors.white)),
                          ],
                        )
                      ],
                    ),
                  );
                }),
              );
            })),
          ],
        );
      });
}