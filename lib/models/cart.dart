import 'package:flutter/material.dart';

class Cart {
  final String id;
  final String title;
  final double quantiy;
  final String productImage;
  final double price;
  final String unit;

  Cart({
    @required this.id,
    @required this.title,
    @required this.quantiy,
    @required this.productImage,
    @required this.price,
    @required this.unit,
  });
}