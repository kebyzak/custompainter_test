import 'dart:math';

import 'package:custompainter_test/custom_checkbox.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Map<Color, AnimationController> animationControllers =
      {}; // Map to store animation controllers
  int _value = 200;
  List<Color> circleColors = [Colors.yellow, Colors.red, Colors.orange];
  List<Color> selectedColors = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 400,
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        direction: Axis.horizontal,
                        verticalDirection: VerticalDirection.down,
                        children: generateCheckboxes(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Slider(
                    min: 200,
                    max: 2000,
                    activeColor: Colors.black54,
                    inactiveColor: Colors.black12,
                    thumbColor: Colors.black,
                    value: _value.toDouble(),
                    onChanged: (value) {
                      _value = value.round();
                      updateAnimationDurations(); // Update animation durations
                      setState(() {});
                    },
                  ),
                  Text(
                    '$_value ms',
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Add Checkboxes'),
                    onPressed: () {
                      addRandomCheckboxes();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Clear'),
                    onPressed: () {
                      clearCheckboxes();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void animationTap(Color color) {
    final animationController = animationControllers[color];
    if (animationController != null) {
      if (animationController.status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (animationController.status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    }
  }

  void addRandomCheckboxes() {
    final random = Random();
    for (int i = 0; i < 10; i++) {
      final randomColor = circleColors[random.nextInt(circleColors.length)];
      selectedColors.add(randomColor);

      // Create an animation controller for the color if it doesn't exist
      if (!animationControllers.containsKey(randomColor)) {
        animationControllers[randomColor] = AnimationController(
          duration: Duration(milliseconds: _value),
          // Use the current slider value
          vsync: this,
        );
      }
    }
    setState(() {});
  }

  void clearCheckboxes() {
    selectedColors.clear();
    animationControllers.forEach((color, controller) {
      controller.dispose();
    });
    animationControllers.clear();
    setState(() {});
  }

  void updateAnimationDurations() {
    // Update the duration of animation controllers based on the current slider value
    animationControllers.forEach((color, controller) {
      controller.duration = Duration(milliseconds: _value);
    });
  }

  List<Widget> generateCheckboxes() {
    List<Widget> checkboxes = [];
    for (final color in selectedColors) {
      checkboxes.add(
        GestureDetector(
          onTap: () {
            animationTap(color);
          },
          child: MySizedBox(
            painter: CustomCheckbox(
              animation: animationControllers[color]!,
              color: color,
            ),
            padding: EdgeInsets.all(10),
          ),
        ),
      );
    }
    return checkboxes;
  }

  @override
  void dispose() {
    animationControllers.forEach((color, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
