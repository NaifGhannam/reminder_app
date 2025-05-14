# 📝 Reminder App

A simple Flutter app to schedule and receive local notifications as reminders.

## 🚀 Features

- Schedule reminders with custom titles  
- Select specific time for notifications  
- Local notification pops up at the chosen time  
- Tap on notification to view reminder details  

## 🛠️ Getting Started

### Prerequisites

- Flutter installed  
- Emulator or physical device setup  
- Java JDK (for Android build)  

### Installation

git clone https://github.com/yourusername/reminder_app.git  
cd reminder_app  
flutter pub get  

### Run the App

flutter run  

## 📱 Platform Setup

### Android

1. Add permissions in `android/app/src/main/AndroidManifest.xml`:

<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>  
<uses-permission android:name="android.permission.VIBRATE"/>

2. Make sure your launcher icon is set:

<application  
    android:icon="@mipmap/ic_launcher"  
    ... >

### iOS

1. Add background mode and notification permission in `ios/Runner/Info.plist`:

<key>UIBackgroundModes</key>  
<array>  
  <string>fetch</string>  
  <string>remote-notification</string>  
</array>

<key>NSLocalNotificationUsageDescription</key>  
<string>This app uses notifications to remind you.</string>

## 📂 Folder Structure

lib/  
└── main.dart   # Main application code

## 📦 Dependencies

- flutter_local_notifications  
- timezone  

## 🔔 Notification Flow

1. User enters reminder title and picks time.  
2. App schedules a local notification using zonedSchedule.  
3. When the notification triggers, tapping it navigates to the detail screen showing the reminder title.  
