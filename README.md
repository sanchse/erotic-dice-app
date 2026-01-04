# Erotic Dice App

A Flutter mobile application for rolling erotic dice with customizable options.

## Features

- **Configurable Dice Count**: Choose between 1 to 3 dice
- **Customizable Titles**: Assign custom titles to each dice (default: Actions, Body Area, Time)
- **Random Results**: Each dice displays a random result when rolled
- **Predefined Options**:
  - **Actions**: Kiss, Lick, Massage
  - **Body Area**: Neck, Back, Hand
  - **Time**: 5 seconds, 10 seconds, 30 seconds
- **Responsive Design**: Mobile-friendly UI for both iOS and Android
- **Material Design**: Clean and modern interface using Flutter Material Design

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode for device emulation

### Installation

1. Clone the repository:
```bash
git clone https://github.com/sanchse/erotic-dice-app.git
cd erotic-dice-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Running Tests

```bash
flutter test
```

## Project Structure

```
lib/
  main.dart           # Main application entry point with all widgets and logic
test/
  widget_test.dart    # Unit and widget tests
android/              # Android-specific configuration
ios/                  # iOS-specific configuration
```

## Usage

1. **Select Number of Dice**: Choose 1, 2, or 3 dice using the choice chips
2. **Customize Titles**: Edit the title field for each dice to personalize
3. **Roll the Dice**: Tap the "Roll Dice" button to get random results
4. **View Results**: See the randomly selected option for each dice

## Technical Details

- **Framework**: Flutter
- **Language**: Dart
- **UI Components**: Material Design widgets
- **State Management**: StatefulWidget with setState
- **Random Generation**: dart:math Random class

## Code Quality

- Clean code with comprehensive comments
- Follows Flutter best practices
- Responsive design for various screen sizes
- Type-safe implementation with null safety