import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/pages/game_page.dart';
import 'package:trivia/providers/start_page_provider.dart';

class StartPage extends StatefulWidget {
  StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  double? _deviceHeight;
  double? _deviceWidth;
  double _currentDifficulty = 0;
  String? _selectedCategory;
  final List<String> _difficultyList = ['Easy', 'Medium', 'Hard'];

  // List of categories to be excluded
  final List<String> _excludedCategories = [
    'Entertainment: Books',
    'Entertainment: Musicals & Theatres',
    'Entertainment: Television',
    'Entertainment: Board Games',
    'Science: Mathematics',
    'Mythology',
    'Sports',
    'Art',
    'Celebrities',
    'Vehicles',
    'Entertainment: Comics',
    'Science: Gadgets',
    'Entertainment: Cartoon & Animations',
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StartPageProvider()..getCategoriesFromAPI(),
      child: Builder(
        builder: (context) {
          final provider = context.watch<StartPageProvider>();
          _deviceHeight = MediaQuery.of(context).size.height;
          _deviceWidth = MediaQuery.of(context).size.width;
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color.fromRGBO(31, 31, 31, 1.0),
              body: provider.categories == null
                  ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
                  : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Center(
                        child: Text(
                          'Frivia!',
                          style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          _difficultyList[_currentDifficulty.toInt()],
                          style: const TextStyle(
                              fontSize: 26, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 24),
                          child: Slider(
                            value: _currentDifficulty,
                            max: 2,
                            min: 0,
                            label: 'Difficulty',
                            activeColor: Colors.blue,
                            divisions: 2,
                            onChanged: (_value) {
                              setState(
                                    () {
                                  _currentDifficulty = _value;
                                  // Reset selected category when changing difficulty
                                  _selectedCategory = null;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      // Conditionally show dropdown based on difficulty
                      if (_currentDifficulty == 0) // Only show for Easy difficulty
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                hint: const Text(
                                  'Select Category',
                                  style: TextStyle(color: Colors.white),
                                ),
                                dropdownColor:
                                const Color.fromRGBO(31, 31, 31, 1.0),
                                style: const TextStyle(
                                    color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                                items: provider.categories!
                                    .where((category) =>
                                !_excludedCategories.contains(
                                    category['name']))
                                    .map<DropdownMenuItem<String>>(
                                        (category) {
                                      return DropdownMenuItem<String>(
                                        value: category['id'].toString(),
                                        child: Text(
                                          category['name'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),
                      if(_currentDifficulty > 0)
                        Container(
                          height: _deviceHeight! * 0.080,
                        ),
                    ],
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: _currentDifficulty == 0 &&
                          _selectedCategory == null
                          ? _showSelectCategoryDialog
                          : () {
                        _navigateToGamePage();
                      },
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      color: Colors.blue,
                      height: _deviceHeight! * 0.075,
                      minWidth: _deviceWidth! * 0.65,
                      child: const Text(
                        'Start',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToGamePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          difficultyLevel:
          _difficultyList[_currentDifficulty.toInt()].toLowerCase(),
          category: _currentDifficulty == 0 ? _selectedCategory! : '',
        ),
      ),
    );
  }

  void _showSelectCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          shape:
          const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
          title: const Text(
            'Select a Category to Start!',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
