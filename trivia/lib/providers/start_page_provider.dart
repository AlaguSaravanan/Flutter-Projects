import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class StartPageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  List? categories;

  StartPageProvider() {
    _dio.options.baseUrl = 'https://opentdb.com/api_category.php';
  }

  Future<void> getCategoriesFromAPI() async {
    var _response = await _dio.get('');
    var _data = jsonDecode(_response.toString());
    categories = _data['trivia_categories'];
    notifyListeners();
  }
}
