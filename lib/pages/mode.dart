import 'package:flutter/material.dart';
import 'package:pixelarticons/pixel.dart';

import '../theme/colors.dart';
import '../theme/dp.dart';
import '../theme/typo.dart';
import '../utils/haptics.dart';
import '../widgets/clickable.dart';
import 'casual.dart';
import 'challenge.dart';

class ModePage extends StatefulWidget {
  final int gamemode;

  const ModePage({super.key, required this.gamemode});

  @override
  State<ModePage> createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  void _byExitMatch() {
    Navigator.maybePop(context);
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
                  Text(widget.gamemode == 0 ? 'casual' : 'challenge',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 48),
                ],
              ),
              const Spacer(flex: 1),
              Column(
                children: [
                  SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () {
                        hapticClick(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => widget.gamemode == 0
                                ? const CasualPage(mode: 0)
                                : const ChallengePage(mode: 0),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.white54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text(
                        'Normal',
                        style: kButtonTxt,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () {
                        hapticClick(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => widget.gamemode == 0
                                ? const CasualPage(mode: 1)
                                : const ChallengePage(mode: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white54,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                      child: const Text(
                        'Random',
                        style: kButtonTxt,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
