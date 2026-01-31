// Model for gesture actions like opening apps or settings
class GestureAction {
  final GestureActionType type;
  final String? appPackageName;
  final String? appName;

  const GestureAction({required this.type, this.appPackageName, this.appName});

  // Factory methods for common actions
  factory GestureAction.disabled() {
    return const GestureAction(type: GestureActionType.disabled);
  }

  factory GestureAction.camera() {
    return const GestureAction(type: GestureActionType.camera);
  }

  factory GestureAction.phone() {
    return const GestureAction(type: GestureActionType.phone);
  }

  factory GestureAction.clock() {
    return const GestureAction(type: GestureActionType.clock);
  }

  factory GestureAction.calendar() {
    return const GestureAction(type: GestureActionType.calendar);
  }

  factory GestureAction.openApp(String packageName, String appName) {
    return GestureAction(
      type: GestureActionType.openApp,
      appPackageName: packageName,
      appName: appName,
    );
  }

  factory GestureAction.lockScreen() {
    return const GestureAction(type: GestureActionType.lockScreen);
  }

  factory GestureAction.showAppList() {
    return const GestureAction(type: GestureActionType.showAppList);
  }

  factory GestureAction.showNotifications() {
    return const GestureAction(type: GestureActionType.showNotifications);
  }

  // For display in UI
  String get displayName {
    switch (type) {
      case GestureActionType.disabled:
        return 'Disabled';
      case GestureActionType.camera:
        return 'Open Camera';
      case GestureActionType.phone:
        return 'Open Phone';
      case GestureActionType.clock:
        return 'Open Clock';
      case GestureActionType.calendar:
        return 'Open Calendar';
      case GestureActionType.openApp:
        return 'Open ${appName != null && appName != '' ? appName : 'App'}';
      case GestureActionType.lockScreen:
        return 'Lock Screen';
      case GestureActionType.showAppList:
        return 'Show App List';
      case GestureActionType.showNotifications:
        return 'Show Notifications';
    }
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'appPackageName': appPackageName,
      'appName': appName,
    };
  }

  // Create from JSON
  factory GestureAction.fromJson(Map<String, dynamic> json) {
    return GestureAction(
      type: GestureActionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => GestureActionType.disabled,
      ),
      appPackageName: json['appPackageName'],
      appName: json['appName'],
    );
  }
}

// Enum for action types
enum GestureActionType {
  disabled,
  camera,
  phone,
  clock,
  calendar,
  openApp,
  lockScreen,
  showAppList,
  showNotifications,
}

// Enum for directions
enum GestureDirection { left, right, up, down, doubleTap }
