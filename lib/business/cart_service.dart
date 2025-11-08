import '../data/models.dart';

// Аналог TDataPrepare из лабораторной работы
class CartService {
  final List<OrderItem> _cartItems = [];
  
  List<OrderItem> get cartItems => List.unmodifiable(_cartItems);
  
  // Аналог Add() метода
  void addToCart(Dish dish, {int quantity = 1, String notes = ''}) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.dishId == dish.id && item.notes == notes
    );
    
    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity += quantity;
    } else {
      _cartItems.add(OrderItem(
        dishId: dish.id!,
        quantity: quantity,
        notes: notes,
        dish: dish,
      ));
    }
  }
  
  // Аналог Delete() метода
  void removeFromCart(OrderItem item) {
    _cartItems.remove(item);
  }
  
  void removeDish(Dish dish) {
    _cartItems.removeWhere((item) => item.dishId == dish.id);
  }
  
  void updateQuantity(OrderItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(item);
    } else {
      final index = _cartItems.indexOf(item);
      if (index != -1) {
        _cartItems[index].quantity = newQuantity;
      }
    }
  }
  
  // Аналог Select() метода
  void clearCart() {
    _cartItems.clear();
  }
  
  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
  
  int getItemQuantity(Dish dish) {
    final item = _cartItems.firstWhere(
      (item) => item.dishId == dish.id,
      orElse: () => OrderItem(dishId: -1, quantity: 0),
    );
    return item.quantity;
  }
}