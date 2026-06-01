# 🌍 EcoThermal

A Duolingo-inspired educational application built with Flutter, designed to teach users about Global Warming, Climate Change, and Environmental Science in an engaging and interactive way.

## ✨ Features

- **Gamified Learning:** Duolingo-style interactive learning experience focused on climate change awareness.
- **Eco Chat Assistant:** A dedicated chat interface (Chat Screen) to discuss, ask questions, and learn more about ecological topics.
- **Calorimetry Simulation:** Interactive simulation elements to understand heat transfer and energy concepts.
- **Beautiful UI/UX:** Smooth transitions and animations powered by `lottie` and `flutter_animate`, combined with modern typography using `google_fonts`.
- **Multilingual Support:** Built-in language provider for localized learning.
- **Web Resources:** Seamless in-app browser (`webview_flutter`) for reading external environmental articles and resources.

## 📱 Screenshots

*(Add your screenshots here by replacing the placeholder links)*
| Home Screen | Chat Screen | Info Screen |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/250x500.png?text=Home+Screen" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Chat+Screen" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Info+Screen" width="250"> |

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
- **Animations:** [Lottie](https://lottiefiles.com/), [Flutter Animate](https://pub.dev/packages/flutter_animate)
- **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)
- **Networking:** `http` package

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0 <4.0.0`)
- Android Studio or VS Code with Flutter/Dart extensions
- A connected device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mohzamilsaifuddin/ecothermal.git
   cd ecothermal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```text
lib/
├── models/       # Data models (e.g., chat_model.dart)
├── providers/    # Riverpod state management (chat, language, pretest, etc.)
├── screens/      # Application screens (Home, Chat, Splash, WebView, etc.)
├── theme/        # Application styling and color schemes
├── utils/        # Utility classes (translations, app links)
├── widgets/      # Reusable UI components
└── main.dart     # Entry point of the Flutter application
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! 
Feel free to check the [issues page](https://github.com/mohzamilsaifuddin/ecothermal/issues) if you want to contribute.

## 📝 License

This project is open-source. Please check the repository for more details regarding the license.
