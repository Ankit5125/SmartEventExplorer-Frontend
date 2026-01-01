import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_event_explorer_frontend/apis/storage/LocalStorage.dart';
import 'package:smart_event_explorer_frontend/controllers/NavController.dart';
import 'package:smart_event_explorer_frontend/screens/splash/SplashScreen.dart';
import 'package:smart_event_explorer_frontend/services/UserService.dart';
import 'package:smart_event_explorer_frontend/utils/AnimatedNavigator/AnimatedNavigator.dart';

class CustomNavBar extends StatelessWidget {
  final Size size;
  const CustomNavBar({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    final double iconSize = size.height * 0.03;

    return ValueListenableBuilder<int>(
      valueListenable: NavController.selectedIndex,
      builder: (context, value, child) => ClipRRect(
        borderRadius: .all(.circular(50)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: size.height * 0.07,
            width: size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 2.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                // home
                _navIcon(0, Icons.home),

                // Search
                _navIcon(1, Icons.search),

                // createEvent
                _navIcon(2, Icons.add),

                // Account Setting
                _navIcon(3, Icons.person),

                // logout
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      NavController.selectedIndex.value == 4
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                  onPressed: () async {
                    await UserService().clearUser();
                    LocalStorage().delete("token").then((val) {
                      AnimatedNavigator(SplashScreen(), context);
                    });
                  },
                  highlightColor: Colors.grey,
                  icon: Icon(
                    Icons.logout,
                    color: NavController.selectedIndex.value == 4
                        ? Colors.black
                        : Colors.white,
                    size: iconSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navIcon(int index, IconData icon) => IconButton(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(
        NavController.selectedIndex.value == index
            ? Colors.white
            : Colors.transparent,
      ),
    ),
    highlightColor: Colors.grey,
    onPressed: () {
      NavController.selectedIndex.value = index;
    },
    icon: Icon(
      icon,
      color: NavController.selectedIndex.value == index
          ? Colors.black
          : Colors.white,
      size: size.height * 0.03,
    ),
  );
}
