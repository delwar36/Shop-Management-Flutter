import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double quantiy;
  final String productImage;
  final double price;
  final String unit;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantiy,
    @required this.productImage,
    @required this.price,
    @required this.unit,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double getQuantity(String id) {
    if (_items[id] == null) {
      return 0;
    }
    return _items[id].quantiy;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantiy;
    });
    return total;
  }

  void addItem(
    String productId, double price, String title, String productIamge, String unit) {
    
    if (_items.containsKey(productId)) {
      //
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          unit: existingCartItem.unit,
          productImage: existingCartItem.productImage,
          quantiy: existingCartItem.quantiy + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toIso8601String(),
            title: title,
            price: price,
            unit: unit,
            productImage: productIamge,
            quantiy: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void increaseProduct(String productId) {
    _items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        unit: existingCartItem.unit,
        productImage: existingCartItem.productImage,
        quantiy: existingCartItem.quantiy + 1,
      ),
    );
    notifyListeners();
  }

  void decreaseProduct(String productId) {
    if(getQuantity(productId) <= 1){
      removeItem(productId);
    }
    _items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        unit: existingCartItem.unit,
        productImage: existingCartItem.productImage,
        quantiy: existingCartItem.quantiy - 1,
      ),
    );
    notifyListeners();
  }

  void replaceAmount(String id, double amount) {
     if(getQuantity(id) <= 1){
      removeItem(id);
    }
    _items.update(id, (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        unit: existingCartItem.unit,
        productImage: existingCartItem.productImage,
        quantiy: amount,
      ),
    );
    notifyListeners();
  } 

  void clear() {
    _items = {};
    notifyListeners();
  }
}
