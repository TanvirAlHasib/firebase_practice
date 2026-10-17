# Firebase Practice Task Manager

A task management mobile application built with **Flutter** and **Firebase**, featuring secure authentication, real-time task management, Firebase Cloud Messaging (FCM), and local notifications.

The application helps users organize their daily activities, manage task priorities, track completion status, and stay informed through push notifications.

## Overview

Firebase Task Manager demonstrates the integration of Firebase services into a Flutter application, with an emphasis on real-time data synchronization, authentication, and notification handling across different application lifecycle states.

### Key Features

**Authentication**
- Email and password registration and login
- Google Sign-In integration
- Firebase Authentication
- User-specific task management

**Task Management**
- Create, view, update, and delete tasks
- Mark tasks as completed or pending
- Assign task priorities
- Set task due dates
- Real-time task synchronization with Cloud Firestore
- Confirmation dialog before task deletion

**Push Notifications**
- Firebase Cloud Messaging integration
- FCM device token retrieval
- Push notification handling
- Foreground, background, and terminated-state support
- Notification tap handling and screen navigation

**Local Notifications**
- Display notifications while the application is in the foreground
- Integrate FCM with Flutter Local Notifications
- Extract notification content and payload data
- Navigate to the task screen when a notification is tapped

## Technology Stack

| Category | Technology |
|---|---|
| Framework | Flutter |
| Programming Language | Dart |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| Push Notifications | Firebase Cloud Messaging |
| Local Notifications | Flutter Local Notifications |
| Google Authentication | Google Sign-In |
| Backend Services | Firebase |

## Application Architecture

The application uses Firebase services for authentication, persistent data storage, and cloud messaging.

```text
                    Flutter Application
                            |
          +-----------------+-----------------+
          |                 |                 |
          v                 v                 v
    Authentication     Task Management   Notifications
          |                 |                 |
          v                 v                 v
    Firebase Auth      Cloud Firestore       FCM
          |                 |                 |
          |                 |          +------+------+
          |                 |          |             |
          |                 |          v             v
          |                 |      Foreground     Background
          |                 |          |             |
          |                 |          v             v
          |                 |        Local         System
          |                 |     Notification  Notification
          |                 |          |             |
          +-----------------+----------+-------------+
                            |
                            v
                     Flutter UI
```

## Firebase Integration

### Firebase Authentication

Firebase Authentication manages user registration and sign-in.

Supported authentication methods include:

- Email and password
- Google Sign-In

Each authenticated user can access and manage their own tasks.

### Cloud Firestore

Cloud Firestore provides persistent storage and real-time synchronization for task data.

**Example Firestore structure:**

```text
users/
  └── {userId}/
       └── tasks/
            └── {taskId}/
                 ├── title
                 ├── description
                 ├── dueDate
                 ├── priority
                 ├── isDone
                 └── createdAt
```

**Example task document:**

```json
{
  "title": "Complete Flutter Project",
  "description": "Implement Firebase notifications",
  "dueDate": "2026-10-20",
  "priority": "High",
  "isDone": false,
  "createdAt": "2026-10-18"
}
```

> The database structure above is illustrative. Field names and date representations should match the actual implementation.

## Notification System

The application integrates Firebase Cloud Messaging with local notifications to provide a consistent notification experience.

### Foreground Notifications

When the application is active, incoming FCM messages are processed through `FirebaseMessaging.onMessage`.

The notification payload is extracted and displayed using `flutter_local_notifications`.

```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  final notification = message.notification;

  if (notification != null) {
    // Display a local notification.
  }
});
```

### Background Notifications

When the application is in the background, notification messages can be displayed by the operating system.

Notification interaction events are handled using:

```dart
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // Handle notification navigation.
});
```

### Terminated-State Notifications

When the application is launched through a notification, the initial message is retrieved using:

```dart
final RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

if (initialMessage != null) {
  // Handle initial notification navigation.
}
```

### Notification Navigation

Notification payloads can contain a task identifier.

**Example payload:**

```json
{
  "notification": {
    "title": "Task Reminder",
    "body": "Complete your Flutter assignment"
  },
  "data": {
    "taskId": "task_123",
    "screen": "tasks"
  }
}
```

When a user taps the notification, the application can navigate to the task list or the corresponding task details screen.

## Getting Started

### Prerequisites

Before running the project, ensure that the following tools are installed:

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Firebase CLI
- FlutterFire CLI
- Android emulator or physical device

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/TanvirAlHasib/firebase_practice.git
```

**2. Navigate to the project directory**

```bash
cd firebase_practice
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Configure Firebase**

Install FlutterFire CLI if it is not already installed:

```bash
dart pub global activate flutterfire_cli
```

Generate the Firebase configuration:

```bash
flutterfire configure
```

**5. Configure Firebase services**

In the Firebase Console:

1. Enable Email/Password authentication.
2. Configure Google Sign-In.
3. Create a Cloud Firestore database.
4. Configure appropriate Firestore security rules.
5. Enable Firebase Cloud Messaging.
6. Complete any platform-specific notification configuration.

**6. Run the application**

```bash
flutter run
```

## Dependencies

The project uses the following Firebase and notification packages:

```yaml
dependencies:
  flutter:
    sdk: flutter

  firebase_core:
  firebase_auth:
  cloud_firestore:
  firebase_messaging:
  flutter_local_notifications:
  google_sign_in:
```

Package versions should be selected based on compatibility with the installed Flutter SDK.

## Testing Notifications

Push notifications can be tested using the Firebase Console.

1. Launch the application on a supported device.
2. Grant notification permissions.
3. Retrieve the device FCM registration token.
4. Open Firebase Console → Messaging.
5. Create a notification campaign.
6. Send a test notification using the device token.
7. Verify notification behavior in foreground, background, and terminated states.

**Example notification:**

```text
Title: New Task

Body: You have a new task: Complete Flutter Assignment
```

### Expected Behavior

| Application State | Expected Behavior |
|---|---|
| Foreground | Display a local notification |
| Background | Display a system notification |
| Terminated | Display notification and handle navigation when opened |
| Notification Tapped | Navigate to the task list or related task |

Notification delivery and display behavior may vary depending on platform configuration, permissions, and message type.

## Security

The application uses Firebase Authentication to identify users and Cloud Firestore to store task data.

Recommended security practices include:

- Restrict Firestore access to authenticated users.
- Ensure users can access only their own task documents.
- Avoid embedding service account credentials in the application.
- Configure Firestore security rules before production deployment.
- Keep Firebase dependencies updated.

## Future Enhancements

Potential improvements include:

- Scheduled task reminders
- Task search and filtering
- Priority-based notification customization
- Task analytics and productivity insights
- Dark mode support
- Enhanced task categorization
- Improved offline task management

## UI Design

The application interface is based on the provided Figma design.

[Figma Design Reference](https://www.figma.com/design/H7AJlTItYcXu96WEIwrqeF/Flutter-Firebase)

## Author

**Tanvir Al-Hasib**

Flutter Developer | Mobile Application Developer

---

Built with Flutter and Firebase.