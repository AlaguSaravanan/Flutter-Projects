import 'dart:math';

double calculateBMI(int height, int weight) {
  return (weight / pow(height/100, 2));
}

