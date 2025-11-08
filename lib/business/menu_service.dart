import '../data/models.dart';

// Сервис для работы с меню - аналог бизнес-логики из лабораторной работы
class MenuService {
  final List<Category> _categories = [];
  final List<Dish> _dishes = [];
  
  MenuService() {
    _initializeData();
  }
  
  void _initializeData() {
    // Инициализация категорий
    _categories.addAll([
      Category(id: 1, name: "🥟 Димсам", emoji: "🥟"),
      Category(id: 2, name: "🍜 Лапша", emoji: "🍜"),
      Category(id: 3, name: "🍚 Рис и вторые блюда", emoji: "🍚"),
      Category(id: 4, name: "🍵 Напитки", emoji: "🍵"),
    ]);
    
    // Инициализация блюд
    _dishes.addAll([
      // Димсам
      Dish(id: 1, name: "Димсам с креветками", price: 6.5, categoryId: 1),
      Dish(id: 2, name: "Димсам с курицей", price: 5.5, categoryId: 1),
      
      // Лапша
      Dish(id: 3, name: "Лапша удон с овощами", price: 8.0, categoryId: 2),
      Dish(id: 4, name: "Лапша рамен с говядиной", price: 9.0, categoryId: 2),
      
      // Рис и вторые блюда
      Dish(id: 5, name: "Жареный рис с яйцом", price: 7.0, categoryId: 3),
      Dish(id: 6, name: "Утка по-пекински", price: 12.5, categoryId: 3, isSpicy: true),
      Dish(id: 7, name: "Курица кунг-пао", price: 9.0, categoryId: 3, isSpicy: true),
      
      // Напитки
      Dish(id: 8, name: "Зелёный чай жасминовый", price: 3.0, categoryId: 4),
      Dish(id: 9, name: "Имбирный чай", price: 3.5, categoryId: 4),
      Dish(id: 10, name: "Соевое молоко", price: 2.8, categoryId: 4),
    ]);
  }
  
  // Получить все категории
  List<Category> getCategories() {
    return List.unmodifiable(_categories);
  }
  
  // Получить блюда по категории
  List<Dish> getDishesByCategory(int categoryId) {
    return _dishes.where((dish) => dish.categoryId == categoryId).toList();
  }
  
  // Получить популярные блюда
  List<Dish> getPopularDishes() {
    return _dishes.take(3).toList(); // Первые 3 как популярные
  }
  
  // Поиск блюд
  List<Dish> searchDishes(String query) {
    if (query.isEmpty) return [];
    
    return _dishes.where((dish) => 
      dish.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
  
  // Найти блюдо по ID
  Dish? getDishById(int id) {
    try {
      return _dishes.firstWhere((dish) => dish.id == id);
    } catch (e) {
      return null;
    }
  }
}