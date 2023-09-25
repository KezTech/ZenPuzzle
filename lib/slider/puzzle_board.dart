import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:zen/routing/navigator.dart';

import '../theme/colors.dart';
import '../theme/dp.dart';
import '../widgets/clickable.dart';
import 'puzzle_state.dart';
import 'package:zen/slider/shuffle_button.dart';
import 'package:zen/slider/puzzle_title.dart';
import 'button_grid.dart';
import 'package:zen/slider/physics_grid.dart';
import 'package:zen/routing/navigator.dart';


class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    const minSize = 400.0;
    final size = MediaQuery.of(context).size;
    final maxSize = min(minSize, min(size.width, size.height));

    return Center(
      child: ValueListenableBuilder<PuzzleState>(
        valueListenable: puzzleStateNotifier,
        builder: (context, puzzleState, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PuzzleTitle(puzzleState),
                  ),
                ),
              ),
              SizedBox(
                width: maxSize,
                height: maxSize,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ButtonGrid(puzzleState),
                      PhysicsGrid(puzzleState),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  width: maxSize,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ShuffleButton(puzzleState),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          // child: MusicModeButton(puzzleState),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
