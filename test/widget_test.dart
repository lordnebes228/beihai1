import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dwlq/main.dart';

void main() {
  testWidgets('Главная страница отображается корректно', (WidgetTester tester) async {
    // Строим наше приложение и запускаем кадр
    await tester.pumpWidget(const ChineseRestaurantApp());

    // Проверяем, что заголовок приложения отображается
    expect(find.text('🏮 Красный Дракон'), findsOneWidget);
    expect(find.text('Добро пожаловать в китайский ресторан!'), findsOneWidget);

    // Проверяем, что кнопки отображаются
    expect(find.text('Открыть меню'), findsOneWidget);
    expect(find.text('Посмотреть корзину'), findsOneWidget);
    expect(find.text('Войти / Зарегистрироваться'), findsOneWidget);
  });

  testWidgets('Навигация к меню работает', (WidgetTester tester) async {
    await tester.pumpWidget(const ChineseRestaurantApp());

    // Нажимаем кнопку "Открыть меню"
    await tester.tap(find.text('Открыть меню'));
    await tester.pumpAndSettle();

    // Проверяем, что перешли на страницу меню
    expect(find.text('🏮 Меню ресторана'), findsOneWidget);
  });

  testWidgets('Навигация к корзине работает', (WidgetTester tester) async {
    await tester.pumpWidget(const ChineseRestaurantApp());

    // Нажимаем кнопку "Посмотреть корзину"
    await tester.tap(find.text('Посмотреть корзину'));
    await tester.pumpAndSettle();

    // Проверяем, что перешли на страницу корзины
    expect(find.text('🧧 Корзина'), findsOneWidget);
  });

  testWidgets('Добавление товара в корзину', (WidgetTester tester) async {
    await tester.pumpWidget(const ChineseRestaurantApp());

    // Переходим в меню
    await tester.tap(find.text('Открыть меню'));
    await tester.pumpAndSettle();

    // Ищем кнопку добавления для первого блюда
    final addButton = find.byIcon(Icons.add_circle_outline).first;
    await tester.tap(addButton);
    await tester.pump();

    // Проверяем, что счетчик изменился
    expect(find.text('1'), findsAtLeast(1));
  });

  testWidgets('Корзина пуста при первом открытии', (WidgetTester tester) async {
    await tester.pumpWidget(const ChineseRestaurantApp());

    // Переходим в корзину
    await tester.tap(find.text('Посмотреть корзину'));
    await tester.pumpAndSettle();

    // Проверяем, что корзина пуста
    expect(find.text('Корзина пуста 🥢'), findsOneWidget);
  });

  testWidgets('Навигация к странице входа', (WidgetTester tester) async {
    await tester.pumpWidget(const ChineseRestaurantApp());

    // Нажимаем кнопку входа
    await tester.tap(find.text('Войти / Зарегистрироваться'));
    await tester.pumpAndSettle();

    // Проверяем, что перешли на страницу входа
    expect(find.text('🔑 Вход'), findsOneWidget);
  });
}