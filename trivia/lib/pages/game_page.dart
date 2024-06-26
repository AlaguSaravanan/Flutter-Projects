import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia/providers/game_page_provider.dart';

class GamePage extends StatelessWidget {
  final String difficultyLevel;
  final String category;
  double? _deviceHeight, _deviceWidth;

  GamePageProvider? _pageProvider;

  GamePage({super.key, required this.difficultyLevel, required this.category});

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_context) => GamePageProvider(context: context, difficultyLevel: difficultyLevel, category: category),
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (_context) {
      _pageProvider = _context.watch<GamePageProvider>();
      if (_pageProvider?.questions != null) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceHeight! * 0.05,
              ),
              child: _gameUI(),
            ),
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    });
  }

  Widget _gameUI() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _questionText(),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _trueButton(),
            SizedBox(
              height: _deviceHeight! * 0.03,
            ),
            _falseButton(),
          ],
        ),
      ],
    );
  }

  Widget _questionText() {
    return  Text(
      _pageProvider!.getCurrentQuestionText(),
      style: const TextStyle(
          fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white),
    );
  }

  Widget _trueButton() {
    return MaterialButton(
      onPressed: () {
        _pageProvider?.answerQuestion('True');
      },
      color: Colors.green,
      minWidth: _deviceWidth! * 0.65,
      height: _deviceHeight! * 0.075,
      child: const Text(
        'True',
        style: TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _falseButton() {
    return MaterialButton(
      onPressed: () {
        _pageProvider?.answerQuestion('False');
      },
      color: Colors.red,
      minWidth: _deviceWidth! * 0.65,
      height: _deviceHeight! * 0.075,
      child: const Text(
        'False',
        style: TextStyle(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }
}
