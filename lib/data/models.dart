// Базовый класс как в лабораторной работе
abstract class BaseModel {
  int? id;
  BaseModel({this.id});
}

// Модель категории
class Category extends BaseModel {
  final String name;
  final String emoji;
  
  Category({
    super.id,
    required this.name,
    required this.emoji,
  });
  
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
    );
  }
}

// Модель блюда
class Dish extends BaseModel {
  final String name;
  final double price;
  final String description;
  final int categoryId;
  final bool isSpicy;
  final bool isVegetarian;
  
  Dish({
    super.id,
    required this.name,
    required this.price,
    this.description = '',
    required this.categoryId,
    this.isSpicy = false,
    this.isVegetarian = false,
  });
  
  String get emoji {
    // Простая логика для получения эмодзи из названия блюда
    if (name.toLowerCase().contains('димсам')) return '🥟';
    if (name.toLowerCase().contains('лапша')) return '🍜';
    if (name.toLowerCase().contains('рис')) return '🍚';
    if (name.toLowerCase().contains('утк')) return '🦆';
    if (name.toLowerCase().contains('куриц')) return '🍗';
    if (name.toLowerCase().contains('чай')) return '🍵';
    if (name.toLowerCase().contains('молок')) return '🥛';
    return '🍽️'; // эмодзи по умолчанию
  }
  
  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'] ?? '',
      categoryId: json['category_id'],
      isSpicy: json['is_spicy'] == 1,
      isVegetarian: json['is_vegetarian'] == 1,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dish && name == other.name && price == other.price;

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}

// Модель элемента заказа
class OrderItem extends BaseModel {
  final int dishId;
  int quantity;
  final String notes;
  Dish? dish; // Связанное блюдо
  
  OrderItem({
    super.id,
    required this.dishId,
    required this.quantity,
    this.notes = '',
    this.dish,
  });
  
  double get totalPrice => dish != null ? dish!.price * quantity : 0;
}

// Модель заказа
class Order extends BaseModel {
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  final List<OrderItem> items;
  
  Order({
    super.id,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.items,
  });
}