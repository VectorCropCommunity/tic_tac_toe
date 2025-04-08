import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/app/controllers/theme_controller.dart';
import 'package:tic_tac_toe/app/modules/home/controllers/home_controller.dart';
import 'package:tic_tac_toe/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                isAudioOn.value ? Icons.volume_up : Icons.volume_off,
                color: scheme.onSurface,
              ),
              tooltip: isAudioOn.value ? "Mute" : "Unmute",
              onPressed: controller.toggleAudio,
            );
          }),

          IconButton(
            icon: Icon(Icons.color_lens_outlined, color: scheme.onSurface),
            onPressed: () {
              Get.bottomSheet(
                Obx(
                  () => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: scheme.onSurface.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const Text(
                          "Theme",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children:
                              themeController.availableSeeds.map((color) {
                                final isSelected =
                                    color ==
                                    themeController.selectedSeedColor.value;
                                return GestureDetector(
                                  onTap: () {
                                    final index = themeController.availableSeeds
                                        .indexOf(color);
                                    themeController.switchSeedColor(index);
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? scheme.onSurface
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child:
                                        isSelected
                                            ? const Icon(
                                              Icons.check,
                                              size: 18,
                                              color: Colors.white,
                                            )
                                            : null,
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Mode",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Light'),
                              icon: Icon(Icons.light_mode),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Dark'),
                              icon: Icon(Icons.dark_mode),
                            ),
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('System'),
                              icon: Icon(Icons.brightness_auto),
                            ),
                          ],
                          selected: {themeController.themeMode.value},
                          onSelectionChanged: (Set<ThemeMode> newSelection) {
                            themeController.switchThemeMode(newSelection.first);
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background
          Container(decoration: BoxDecoration(color: scheme.surfaceContainer)),

          // Logo & Buttons
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Image
                  Image.asset(
                    'assets/images/Logo.png',
                    width: 220,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 60),

                  // 🎮 Mode Cards
                  _BeautifulModeCard(
                    emoji: '👥',
                    label: "Player vs Player",
                    onTap:
                        () => Get.toNamed(
                          Routes.GAME,
                          arguments: {'vsAI': false},
                        ),
                    scheme: scheme,
                  ),
                  const SizedBox(height: 20),
                  _BeautifulModeCard(
                    emoji: '🤖',
                    label: "Play vs AI",
                    onTap:
                        () =>
                            Get.toNamed(Routes.GAME, arguments: {'vsAI': true}),
                    scheme: scheme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BeautifulModeCard extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _BeautifulModeCard({
    required this.emoji,
    required this.label,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.primary,
      borderRadius: BorderRadius.circular(32),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        splashColor: scheme.onPrimary.withOpacity(0.2),
        highlightColor: scheme.onPrimary.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: scheme.onPrimary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
