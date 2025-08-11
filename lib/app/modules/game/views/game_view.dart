import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/game_controller.dart';

class GameView extends GetResponsiveView<GameController> {
  GameView({super.key});

  @override
  Widget? phone() {
    final scheme = Get.theme.colorScheme;

    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withOpacity(0.1),
                  scheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.shadow.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: scheme.primary,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Loading Game...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
        body: Stack(
          children: [
            // Main content
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary.withOpacity(0.05),
                    scheme.secondary.withOpacity(0.05),
                    scheme.tertiary.withOpacity(0.05),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Game Header
                    _GameHeader(controller: controller, scheme: scheme),

                    // Main Game Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Player Turn Indicator
                              _PlayerTurnIndicator(
                                controller: controller,
                                scheme: scheme,
                              ),

                              const SizedBox(height: 30),

                              // Difficulty Selector (for AI mode)
                              if (controller.isVsAI.value)
                                _DifficultySelector(
                                  controller: controller,
                                  scheme: scheme,
                                ),

                              if (controller.isVsAI.value)
                                const SizedBox(height: 30),

                              // Game Board
                              _GameBoard(
                                controller: controller,
                                scheme: scheme,
                              ),

                              const SizedBox(height: 30),

                              // Game Info/Stats
                              _GameInfoPanel(
                                controller: controller,
                                scheme: scheme,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Confetti overlay
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: controller.confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 50,
                  maxBlastForce: 35,
                  minBlastForce: 15,
                  emissionFrequency: 0.05,
                  gravity: 0.3,
                  particleDrag: 0.05,
                  colors: [
                    scheme.primary,
                    scheme.secondary,
                    scheme.tertiary,
                    Colors.red,
                    Colors.green,
                    Colors.blue,
                    Colors.orange,
                    Colors.purple,
                  ],
                  strokeWidth: 0,
                  blastDirection: -pi / 2,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget? tablet() {
    return phone(); // Use the same modern design for tablet
  }

  @override
  Widget? desktop() {
    return phone(); // Use the same modern design for desktop
  }
}

// Game Header Component
class _GameHeader extends StatelessWidget {
  final GameController controller;
  final ColorScheme scheme;

  const _GameHeader({required this.controller, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button and game info
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: scheme.primary),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tic Tac Toe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.isVsAI.value
                          ? 'vs AI'
                          : '${controller.playerOName.value} vs ${controller.playerXName.value}',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Reset button
          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.refresh, color: scheme.primary),
              onPressed: controller.resetGame,
              tooltip: 'Reset current round',
              // Long press full reset (scores + round)
              onLongPress: controller.resetAll,
            ),
          ),
        ],
      ),
    );
  }
}

// Player Turn Indicator Component
class _PlayerTurnIndicator extends StatelessWidget {
  final GameController controller;
  final ColorScheme scheme;

  const _PlayerTurnIndicator({required this.controller, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                controller.oTurn.value
                    ? [
                      scheme.primaryContainer,
                      scheme.primaryContainer.withOpacity(0.7),
                    ]
                    : [
                      scheme.secondaryContainer,
                      scheme.secondaryContainer.withOpacity(0.7),
                    ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (controller.oTurn.value
                      ? scheme.primary
                      : scheme.secondary)
                  .withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                controller.oTurn.value ? "⭕" : "❌",
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.headingText.value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          controller.oTurn.value
                              ? scheme.onPrimaryContainer
                              : scheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    controller.oTurn.value
                        ? "${controller.playerOName.value}'s Turn"
                        : "${controller.playerXName.value}'s Turn",
                    style: TextStyle(
                      fontSize: 14,
                      color: (controller.oTurn.value
                              ? scheme.onPrimaryContainer
                              : scheme.onSecondaryContainer)
                          .withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Difficulty Selector Component
class _DifficultySelector extends StatelessWidget {
  final GameController controller;
  final ColorScheme scheme;

  const _DifficultySelector({required this.controller, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Difficulty',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final selected = controller.difficulty.value;
            final hasStarted = controller.hasGameStarted();
            final options = [
              {'value': 'easy', 'label': '🟢 Easy', 'color': Colors.green},
              {'value': 'medium', 'label': '🟠 Medium', 'color': Colors.orange},
              {'value': 'hard', 'label': '🔴 Hard', 'color': Colors.red},
            ];

            return Row(
              children:
                  options.map((option) {
                    final isSelected = option['value'] == selected;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                hasStarted
                                    ? null
                                    : () =>
                                        controller.difficulty.value =
                                            option['value'] as String,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? scheme.primaryContainer
                                        : scheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? scheme.primary
                                          : scheme.outline.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Text(
                                option['label'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      isSelected
                                          ? scheme.onPrimaryContainer
                                          : scheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

// Game Board Component
class _GameBoard extends StatelessWidget {
  final GameController controller;
  final ColorScheme scheme;

  const _GameBoard({required this.controller, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          itemCount: 9,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return Obx(() {
              final isMatched = controller.matchedIndex.contains(index);
              final isTapped = controller.tappedIndex.value == index;
              final cellValue = controller.list[index];

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: isTapped ? 0.95 : 1.0),
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutBack,
                onEnd: () {
                  if (isTapped) controller.tappedIndex.value = -1;
                },
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          isMatched
                              ? [
                                scheme.tertiaryContainer,
                                scheme.tertiaryContainer.withOpacity(0.8),
                              ]
                              : cellValue == 'X'
                              ? [
                                scheme.primaryContainer,
                                scheme.primaryContainer.withOpacity(0.8),
                              ]
                              : cellValue == 'O'
                              ? [
                                scheme.secondaryContainer,
                                scheme.secondaryContainer.withOpacity(0.8),
                              ]
                              : [
                                scheme.surfaceVariant,
                                scheme.surfaceVariant.withOpacity(0.8),
                              ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          isMatched
                              ? scheme.tertiary
                              : scheme.outline.withOpacity(0.2),
                      width: isMatched ? 3 : 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => controller.onTapped(index),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            final rotate = Tween(
                              begin: pi,
                              end: 0.0,
                            ).animate(animation);
                            return AnimatedBuilder(
                              animation: rotate,
                              child: child,
                              builder: (context, child) {
                                final isUnder =
                                    (ValueKey(cellValue) != child?.key);
                                final tilt =
                                    isUnder
                                        ? min(rotate.value, pi / 2)
                                        : rotate.value;
                                return Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(tilt),
                                  child: child,
                                );
                              },
                            );
                          },
                          child: Text(
                            cellValue,
                            key: ValueKey(cellValue),
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color:
                                  cellValue == 'X'
                                      ? scheme.onPrimaryContainer
                                      : cellValue == 'O'
                                      ? scheme.onSecondaryContainer
                                      : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}

// Game Info Panel Component
class _GameInfoPanel extends StatelessWidget {
  final GameController controller;
  final ColorScheme scheme;

  const _GameInfoPanel({required this.controller, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outline.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PlayerScore(
                  label: controller.playerXName.value,
                  icon: '❌',
                  score: controller.xScore.value.toString(),
                  isActive: !controller.oTurn.value,
                  scheme: scheme,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: scheme.outline.withOpacity(0.2),
                ),
                _PlayerScore(
                  label: controller.playerOName.value,
                  icon: '⭕',
                  score: controller.oScore.value.toString(),
                  isActive: controller.oTurn.value,
                  scheme: scheme,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Draws: ${controller.drawScore.value}',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerScore extends StatelessWidget {
  final String label;
  final String icon;
  final String score;
  final bool isActive;
  final ColorScheme scheme;

  const _PlayerScore({
    required this.label,
    required this.icon,
    required this.score,
    required this.isActive,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color:
                isActive ? scheme.primary : scheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          score,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isActive ? scheme.primary : scheme.onSurface,
          ),
        ),
      ],
    );
  }
}
