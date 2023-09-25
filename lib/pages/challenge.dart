import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:provider/provider.dart';
import 'package:zen/theme/typo.dart';

import '../models/challenge_game.dart';
import '../theme/colors.dart';
import '../theme/dp.dart';
import '../utils/haptics.dart';
import '../widgets/clickable.dart';

class ChallengePage extends StatefulWidget {
  final int mode;

  const ChallengePage({super.key, this.mode = -1});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage>
    with TickerProviderStateMixin {
  static const opIcons = [
    CupertinoIcons.plus,
    CupertinoIcons.minus,
    CupertinoIcons.multiply,
    CupertinoIcons.divide
  ];

  late final _animation = AnimationController(
    value: 0,
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    print(widget.mode);
    Provider.of<ChallengeGame>(context, listen: false)
        .initialize(context, widget.mode, _animation);
  }

  void _byExitMatch() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  Widget _buildBackArrow() {
    return Row(
      children: [
        Clickable(
          padding: k20dp.symmetric(horizontal: true),
          onTap: _byExitMatch,
          strokeWidth: 0.0,
          builder: (context, child, isHovered) {
            return Icon(
              Pixel.arrowleft,
              color: isHovered ? kHighContrast : kDarkerColor,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBackArrow(),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Provider.of<ChallengeGame>(context, listen: false)
                              .hint();
                        },
                        color: colorScheme.onSurfaceVariant,
                        highlightColor:
                            colorScheme.onSurfaceVariant.withOpacity(0.08),
                        iconSize: 32,
                        icon: const Icon(Icons.lightbulb_outline_rounded),
                      ),
                      Text(
                        Provider.of<ChallengeGame>(context, listen: true)
                            .hintsRemaining
                            .toString(),
                        style: TextStyle(
                            fontSize: 18, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     Provider.of<ChallengeGame>(context, listen: false).undo();
                  //   },
                  //   color: colorScheme.onSurfaceVariant,
                  //   highlightColor:
                  //       colorScheme.onSurfaceVariant.withOpacity(0.08),
                  //   iconSize: 32,
                  //   icon: const Icon(Icons.undo_rounded),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     Provider.of<ChallengeGame>(context, listen: false)
                  //         .reset(true);
                  //   },
                  //   color: colorScheme.onSurfaceVariant,
                  //   highlightColor:
                  //       colorScheme.onSurfaceVariant.withOpacity(0.08),
                  //   iconSize: 32,
                  //   icon: const Icon(Icons.settings_backup_restore_rounded),
                  // ),
                ],
              ),
              const Spacer(flex: 2),
              Consumer<ChallengeGame>(
                builder: (context, challengeGame, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 54,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceTint.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'Ans:' +
                              ' ${Provider.of<ChallengeGame>(context, listen: false).target} ',
                          style: TextStyle(
                              fontSize: 28,
                              color: colorScheme.primary,
                              fontFamily: kFontFamily),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Hero(
                          tag: 'timer',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.surfaceTint.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                ' ${challengeGame.timeString} ',
                                style:
                                    TextStyle(fontSize: 32, color: kRedColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeTransition(
                        opacity: _animation,
                        child: SizedBox(
                          width: 42,
                          child: Text(
                            challengeGame.timeChangeString,
                            style: TextStyle(fontSize: 24, color: kRedColor),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Spacer(flex: 2),
              Consumer<ChallengeGame>(
                builder: (context, challengeGame, child) {
                  return GridView.count(
                    primary: false,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    children: <Widget>[
                      for (int i = 0; i < 4; i++)
                        Visibility(
                          visible: challengeGame.numShown[i],
                          child: Hero(
                            tag: 'num$i',
                            child: ElevatedButton(
                              onPressed: () {
                                challengeGame.pressNumButton(i, true);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  backgroundColor: challengeGame.numPressed[i]
                                      ? Colors.orangeAccent
                                      : null),
                              child: Text(
                                challengeGame.nums[i].toString(),
                                style: const TextStyle(
                                    fontSize: 48, fontFamily: kFontFamily),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const Spacer(flex: 3),
              Consumer<ChallengeGame>(
                builder: (context, casualGame, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 4; i++)
                        SizedBox(
                          width: 66,
                          height: 66,
                          child: ElevatedButton(
                            onPressed: () {
                              casualGame.pressOpButton(i, true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: casualGame.opPressed[i]
                                  ? colorScheme.primaryContainer
                                  : null,
                            ),
                            child: Icon(opIcons[i], size: 36),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
