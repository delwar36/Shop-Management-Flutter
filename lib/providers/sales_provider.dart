import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/sale.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesProvider with ChangeNotifier {
  List<Sale> _sales = [];

  List<Sale> get sales {
    return [..._sales];
  }

  Future<void> fetchAllSales() async {
    const url = 'https://shop-management-721b3.firebaseio.com/sales.json';
    try {
      final response = await http.get(url);
      print(response.body);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Sale> loadedSale = [];
      if(extractData == null){
        return;
      }
      extractData.forEach((prodId, prodData) {
        loadedSale.add(
          Sale(
            id: prodId,
            amount: prodData['amount'],
            dateTime: DateTime.parse(prodData['dateTime']),
            cusImageUrl: prodData['cusImageUrl'],
            cusName: prodData['cusName'],
            products: (prodData['products'] as List<dynamic>).map(
              (item) => Cart(
                  id: item['id'],
                  price: item['price'],
                  productImage: item['productImage'],
                  quantiy: item['quantiy'],
                  title: item['title'],
                  unit: item['unit']),
            ).toList(),
          ),
        );
      });
      _sales = loadedSale;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> addSale(List<Cart> cartProducts, double total,
      String cusImageUrl, String cusName, DateTime dateTime) async {
    const url = 'https://shop-management-721b3.firebaseio.com/sales.json';

    Map<String, dynamic> remoteSale = {
      'amount': total,
      'cusImageUrl': cusImageUrl,
      'cusName': cusName,
      'products': cartProducts
          .map((existingCartItem) => {
                'id': existingCartItem.id,
                'title': existingCartItem.title,
                'price': existingCartItem.price,
                'unit': existingCartItem.unit,
                'productImage': existingCartItem.productImage,
                'quantiy': existingCartItem.quantiy,
              })
          .toList(),
      'dateTime': dateTime.toIso8601String(),
    };

    try {
      final response = await http.post(
        url,
        body: json.encode(remoteSale),
      );
      _sales.add(
        Sale(
          amount: total,
          dateTime: dateTime,
          id: json.decode(response.body)['name'],
          cusImageUrl: cusImageUrl,
          cusName: cusName,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
