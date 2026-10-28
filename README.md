
# IQRA — Arabic Learning Platform

A bilingual Arabic learning application built with Flutter,
PHP, and MySQL. Designed to help beginners learn the Arabic
alphabet, practice pronunciation, and track their progress
through interactive exercises.

## 🌐 Live Application

- [Launch IQRA Web](https://salahayash.helioho.st/iqra/)
- [Download Android APK](https://salahayash.helioho.st/download/IQRA-v1.2.apk)
- [Official Download Page](https://salahayash.helioho.st/download/)

## ✨ Key Features

- User registration and login
- Arabic alphabet and vowel lessons with audio
- Multiple-choice and matching exercises
- Speech recognition for pronunciation practice
- Quiz scores and progress tracking
- User profile management
- English and Arabic language support
- Android and Flutter Web support

## 🛠 Technologies

**Mobile & Web**
- Flutter
- Dart
- Flutter Web

**Backend**
- PHP
- REST-style APIs
- MySQL

**Additional Tools**
- Speech-to-Text
- SharedPreferences
- HTTP API integration
- HelioHost hosting

## 📂 Project Structure

- `lib/` — Flutter application source code
- `lib/l10n/` — English and Arabic translations
- `assets/` — Images, icons, and Arabic audio
- `android/` — Android project configuration
- `ios/` — iOS project configuration
- `web/` — Flutter Web resources
- `backend/` — Selected PHP backend examples

## 🔌 Backend Implementation

IQRA connects to a PHP/MySQL backend for user accounts,
quiz content, profile management, and score tracking.

This public repository contains a selected backend showcase:

- Quiz 1 API
- Quiz 2 API
- Quiz 3 API
- CORS configuration
- Example database connection configuration

The complete production backend, real database credentials,
admin configuration, and user data are not included.

See `backend/README.md` for implementation details and
important security limitations.

## 🚀 Running the Flutter Project

Install Flutter and configure the required development tools.

Clone the repository:

```bash
git clone https://github.com/salah804/IQRA-Arabic-Learning-App.git
cd IQRA-Arabic-Learning-App
```

Install dependencies:

```bash
flutter pub get
```

Run the Android application:

```bash
flutter run
```

Run in a web browser:

```bash
flutter run -d chrome
```

Note: Features that access server data require a working API
backend. The published backend showcase is not a complete
standalone backend deployment.

## 🔒 Security

Private credentials, signing keys, and production database
configuration are excluded from this repository.

The included PHP examples demonstrate backend techniques,
but should not be treated as a fully audited production API.

## 👨‍💻 Developer

**Salah Ayash**

Computer Science Graduate — Universiti Teknikal Malaysia
Melaka (UTeM)

Full-Stack, Mobile & Cloud Developer

[GitHub Profile](https://github.com/salah804)
