import 'package:flutter/material.dart';
import 'business/cart_service.dart';
import 'business/menu_service.dart';
import 'data/models.dart';

void main() => runApp(const ChineseRestaurantApp());

class ChineseRestaurantApp extends StatelessWidget {
  const ChineseRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🏮 Бей Хай | Китайский ресторан',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const HomePage(),
    );
  }
}

//
// ======================= 🏮 ГЛАВНАЯ СТРАНИЦА =======================
//

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🏮 Красный Дракон",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Добро пожаловать в китайский ресторан!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),

              // Кнопка "Меню"
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainMenu()),
                  );
                },
                icon: const Icon(Icons.restaurant_menu),
                label: const Text("Открыть меню"),
              ),
              const SizedBox(height: 20),

              // Кнопка "Корзина"
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage(cartService: CartService())),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Посмотреть корзина"),
              ),
              const SizedBox(height: 20),

              // Кнопка "Войти"
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text("Войти / Зарегистрироваться"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// ======================= 📱 ОСНОВНОЕ МЕНЮ (нижняя навигация) =======================
//

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int selectedIndex = 0;
  late final CartService _cartService;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _cartService = CartService();
    pages = [
      FoodHomePage(cartService: _cartService),
      CartPage(cartService: _cartService),
      const AccountPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.red.shade700,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: "Меню"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Корзина"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Профиль"),
        ],
      ),
    );
  }
}

//
// ======================= 🍱 СТРАНИЦА МЕНЮ =======================
//

class FoodHomePage extends StatefulWidget {
  final CartService cartService;
  const FoodHomePage({super.key, required this.cartService});

  @override
  State<FoodHomePage> createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  final MenuService _menuService = MenuService();
  final List<Category> _categories = [];
  final Map<int, List<Dish>> _categoryDishes = {};
  
  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }
  
  void _loadMenuData() {
    final categories = _menuService.getCategories();
    setState(() {
      _categories.clear();
      _categories.addAll(categories);
      
      // Загружаем блюда для каждой категории
      for (final category in categories) {
        _categoryDishes[category.id!] = _menuService.getDishesByCategory(category.id!);
      }
    });
  }
  
  void _addToCart(Dish dish) {
    setState(() {
      widget.cartService.addToCart(dish);
    });
  }
  
  void _removeFromCart(Dish dish) {
    setState(() {
      widget.cartService.removeDish(dish);
    });
  }
  
  int _getItemQuantity(Dish dish) {
    return widget.cartService.getItemQuantity(dish);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏮 Меню ресторана'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (widget.cartService.totalItems > 0)
            Badge(
              label: Text(widget.cartService.totalItems.toString()),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cartService: widget.cartService),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      body: _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // Баннер популярных блюд
                _buildPopularDishesSection(),
                const SizedBox(height: 20),
                
                // Список категорий
                ..._categories.map((category) => _buildCategorySection(category)),
                const SizedBox(height: 100),
              ],
            ),
    );
  }
  
  Widget _buildPopularDishesSection() {
    final popularDishes = _menuService.getPopularDishes();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "🔥 Популярные блюда",
          style: TextStyle(
            color: Colors.red.shade800,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: popularDishes.map((dish) => _buildPopularDishCard(dish)).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPopularDishCard(Dish dish) {
    final quantity = _getItemQuantity(dish);
    
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dish.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                dish.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${dish.price.toStringAsFixed(2)} \$',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, 
                              color: quantity > 0 ? Colors.red : Colors.grey),
                    onPressed: quantity > 0 ? () => _removeFromCart(dish) : null,
                  ),
                  Text('$quantity', style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.red),
                    onPressed: () => _addToCart(dish),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategorySection(Category category) {
    final dishes = _categoryDishes[category.id!] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            category.name,
            style: TextStyle(
              color: Colors.red.shade800,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...dishes.map((dish) => _buildDishCard(dish)),
      ],
    );
  }
  
  Widget _buildDishCard(Dish dish) {
    final quantity = _getItemQuantity(dish);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(dish.emoji, style: const TextStyle(fontSize: 24)),
        title: Text(dish.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${dish.price.toStringAsFixed(2)} \$'),
            if (dish.isSpicy) 
              Text('🌶️ Острое', style: TextStyle(color: Colors.red.shade600, fontSize: 12)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline, 
                        color: quantity > 0 ? Colors.red : Colors.grey),
              onPressed: quantity > 0 ? () => _removeFromCart(dish) : null,
            ),
            Text('$quantity', style: const TextStyle(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.red),
              onPressed: () => _addToCart(dish),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ======================= 🛒 КОРЗИНА =======================
//

class CartPage extends StatelessWidget {
  final CartService cartService;
  const CartPage({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🧧 Корзина"),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: cartService.cartItems.isEmpty
          ? const Center(child: Text("Корзина пуста 🥢"))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      ...cartService.cartItems.map((item) => Card(
                            child: ListTile(
                              leading: Text(item.dish?.emoji ?? '🍽️', 
                                       style: const TextStyle(fontSize: 24)),
                              title: Text('${item.dish?.name ?? 'Блюдо'} × ${item.quantity}'),
                              subtitle: item.notes.isNotEmpty 
                                  ? Text('Примечание: ${item.notes}')
                                  : null,
                              trailing: Text('${item.totalPrice.toStringAsFixed(2)} \$'),
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Итого:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${cartService.totalPrice.toStringAsFixed(2)} \$',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✅ Заказ оформлен! Сумма: ${cartService.totalPrice.toStringAsFixed(2)} \$'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                          cartService.clearCart();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Оформить заказ'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

//
// ======================= 👤 ПРОФИЛЬ =======================
//

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👤 Профиль'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(Icons.account_circle, size: 100, color: Colors.red.shade400),
            const SizedBox(height: 20),
            const Text(
              "Добро пожаловать!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text("Войти"),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("Зарегистрироваться"),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ======================= 🔑 ВХОД / РЕГИСТРАЦИЯ =======================
//

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔑 Вход'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Форма входа (в разработке) 🧧'),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Регистрация'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Форма регистрации (в разработке) 🐉'),
      ),
    );
  }
}