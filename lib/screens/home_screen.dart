import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

import 'package:win95_launcher/providers/settings_provider.dart';
import 'package:win95_launcher/providers/app_list_provider.dart';

import 'package:win95_launcher/models/app_alignment.dart';
import 'package:win95_launcher/models/gesture_action.dart';
import 'package:win95_launcher/animations/window_transition.dart';

import 'package:win95_launcher/components/home_header.dart';
import 'package:win95_launcher/components/window_widget.dart';
import 'package:win95_launcher/components/home_bottom_bar.dart';
import 'package:win95_launcher/components/app_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  List<String> settingsList = [
    'setDefault',
    'dateTime',
    'appSettings',
    'infoPage',
  ];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: context.read<SettingsProvider>().showStatusBar
          ? SystemUiOverlay.values
          : [SystemUiOverlay.bottom],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final readSettings = context.read<SettingsProvider>();
    final watchSettings = context.watch<SettingsProvider>();
    final readAppList = context.read<AppListProvider>();
    final watchAppList = context.watch<AppListProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomHomeHeader(),
          Expanded(
            child: SwipeDetector(
              onSwipeLeft: (offset) {
                readSettings.leftSwipeAction.type == GestureActionType.disabled
                    ? null
                    : runTransition(
                        direction: Windows95Direction.right,
                        onAction: () => readSettings.executeLeftSwipe(context),
                      );
              },
              onSwipeRight: (offset) {
                readSettings.rightSwipeAction.type == GestureActionType.disabled
                    ? null
                    : runTransition(
                        direction: Windows95Direction.left,
                        onAction: () => readSettings.executeRightSwipe(context),
                      );
              },
              onSwipeUp: (offset) {
                readSettings.upSwipeAction.type == GestureActionType.disabled
                    ? null
                    : runTransition(
                        direction: Windows95Direction.bottomCenter,
                        onAction: () => readSettings.executeUpSwipe(context),
                      );
              },
              onSwipeDown: (offset) {
                readSettings.downSwipeAction.type == GestureActionType.disabled
                    ? null
                    : readSettings.openNotificationPanel();
              },
              child: GestureDetector(
                onDoubleTap: () =>
                    readSettings.doubleTapAction.type ==
                        GestureActionType.disabled
                    ? null
                    : runTransition(
                        direction: Windows95Direction.center,
                        onAction: () => readSettings.executeDoubleTap(context),
                      ),
                child: Container(
                  color: Color.fromRGBO(0, 128, 128, 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  alignment: watchSettings.homeAppBottom
                      ? BottomAppAlignment(
                          watchSettings.homeAppAlignment,
                        ).toAlignment
                      : watchSettings.homeAppAlignment.toAlignment(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollEndNotification) {
                        final metrics = notification.metrics;
                        const double tolerance = 2.0;

                        final bool atTop =
                            metrics.pixels <=
                            metrics.minScrollExtent + tolerance;
                        final bool atBottom =
                            metrics.pixels >=
                            metrics.maxScrollExtent - tolerance;

                        // If the user released while at the top and trying to scroll up (velocity negative)
                        if (atTop &&
                            _scrollController.position.userScrollDirection ==
                                ScrollDirection.forward) {
                          if (readSettings.downSwipeAction.type !=
                              GestureActionType.disabled) {
                            readSettings.openNotificationPanel();
                          }
                        } else if (atBottom &&
                            _scrollController.position.userScrollDirection ==
                                ScrollDirection.reverse) {
                          if (readSettings.upSwipeAction.type !=
                              GestureActionType.disabled) {
                            runTransition(
                              direction: Windows95Direction.bottomCenter,
                              onAction: () =>
                                  readSettings.executeUpSwipe(context),
                            );
                          }
                        }
                      }
                      return true;
                    },
                    child: watchSettings.shortcutNum == 0
                        ? SizedBox()
                        : OrientationBuilder(
                            builder: (context, orientation) => WindowWidget(
                              child: GridView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: watchSettings.shortcutNum.toInt(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          orientation == Orientation.portrait
                                          ? 1
                                          : 2,
                                      childAspectRatio:
                                          orientation == Orientation.portrait
                                          ? 7 - watchSettings.textSize / 16
                                          : 6,
                                    ),
                                itemBuilder: (context, index) {
                                  AppInfo? app =
                                      watchAppList.homeShortcutApps[index];
                                  return AppListTile(
                                    appInfo: app,
                                    title: app != null
                                        ? readAppList.displayNameFor(app)
                                        : 'Add App ${index + 1}',
                                    showIcons: watchSettings.showHomeIcons,
                                    onTap: () async {
                                      app != null
                                          ? await FlutterDeviceApps.openApp(
                                              app.packageName!,
                                            )
                                          : ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  'Long press to select app',
                                                ),
                                              ),
                                            );
                                    },
                                    onLongPress: () {
                                      readSettings.showAppList(
                                        context,
                                        onAppSelected: (appInfo) {
                                          readAppList.addAppToHome(
                                            index,
                                            appInfo.packageName!,
                                          );
                                        },
                                      );
                                    },
                                    appAlignment: watchSettings.homeAppAlignment
                                        .toAlignment(),
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          CustomHomeBottomBar(),
        ],
      ),
    );
  }

  void runTransition({
    required Function() onAction,
    Windows95Direction direction = Windows95Direction.topLeft,
  }) async {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Windows95LaunchOverlay(direction: direction),
    );

    await Future.delayed(const Duration(milliseconds: 200));
    Navigator.of(context).pop();

    onAction();
  }
}
