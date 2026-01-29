# gongbab (공밥)

`gongbab`은 '공단의 밥'의 줄임말로, 공단 내 여러 회사와 식당을 대상으로 하는 식권 관리 키오스크 앱 프로젝트입니다.

## 📝 Description

사용자가 키오스크에 휴대폰 번호 뒷 4자리를 입력하면, 서버와 통신하여 어느 회사 직원이 어떤 식당에서 몇 시에 식사했는지 확인하고 기록하는 식권 체크 기능을 제공합니다.

## ✨ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **UI**:
  - [Material Design](https://material.io/)
  - [Cupertino Icons](https://pub.dev/packages/cupertino_icons)
  - [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- **Routing**:
  - [go_router](https://pub.dev/packages/go_router)
- **State Management / DI**:
  - [get_it](https://pub.dev/packages/get_it)
  - [injectable](https://pub.dev/packages/injectable)
- **Networking**:
  - [dio](https://pub.dev/packages/dio)
  - [pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger)
- **Code Generation**:
  - [json_serializable](https://pub.dev/packages/json_serializable)
  - [build_runner](https://pub.dev/packages/build_runner)
  - [injectable_generator](https://pub.dev/packages/injectable_generator)
- **Fonts**:
  - [Pretendard](https://github.com/orioncactus/pretendard)
- **Testing**:
  - [flutter_test](https://api.flutter.dev/flutter/flutter_test/library.html)
- **Linting**:
  - [flutter_lints](https://pub.dev/packages/flutter_lints)


## 📸 Screenshots

| Phone Number Input | Pin Input |
| :---: | :---: |
| ![Phone Number Input](screenshots/simulator_screenshot_F9F382AA-4276-48EF-ADB1-F26F71A8EFE6.png) | ![Pin Input](screenshots/simulator_screenshot_4A6BB010-2B39-4B70-9F17-94A8FD309ADA.png) |

| Select Name Dialog | Success |
| :---: | :---: |
| ![Select Name Dialog](screenshots/simulator_screenshot_E17DA38B-5A81-45E9-9BBA-535EEE5932B4.png) | ![Success](screenshots/simulator_screenshot_3F338646-0EBF-4D22-98D7-EA65B08FC81C.png) |

## File Structure (lib)

```
lib/
│   ├── main.dart
│   ├── app/
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   └── app_routes.dart
│   │   └── ui/
│   │       ├── phone_number_input/
│   │       │   └── phone_number_input_screen.dart
│   │       ├── select_name/
│   │       │   ├── fake_worker.dart
│   │       │   └── select_name_dialog.dart
│   │       └── success/
│   │           └── success_screen.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── kiosk_status_model.dart
│   │   │   └── kiosk_status_model.g.dart
│   │   ├── network/
│   │   │   └── api_service.dart
│   │   └── repositories/
│   │       └── kiosk_repository_impl.dart
│   ├── di/
│   │   ├── injection.config.dart
│   │   └── injection.dart
│   └── domain/
│       ├── entities/
│       │   └── kiosk_status.dart
│       ├── repositories/
│       │   └── kiosk_repository.dart
│       └── usecases/
│           ├── check_ticket_usecase.dart
│           └── get_kiosk_status_usecase.dart
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.