import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/app/controllers/theme_controller.dart';

class HomeView extends GetView<ThemeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access your ThemeController easily because it's already put into Get
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          // Example: let user open a theme picker with an icon
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () {
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Choose Theme',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Show a simple list or grid of theme options
                      Wrap(
                        spacing: 8,
                        children: themeController.themes.keys.map((themeName) {
                          return ElevatedButton(
                            onPressed: () {
                              themeController.switchTheme(themeName);
                              Get.back(); // Close bottom sheet
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeController
                                  .themes[themeName]?.primaryColor,
                            ),
                            child: Text(themeName),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to Tic Tac Toe!',
          style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }
}
