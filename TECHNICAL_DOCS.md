# Erotic Dice App - Technical Documentation

## Application Overview

The Erotic Dice App is a Flutter-based mobile application that provides an interactive dice rolling experience with customizable options. The app is designed to be simple, intuitive, and responsive across different screen sizes.

## Architecture

### Main Components

1. **EroticDiceApp (StatelessWidget)**
   - Root widget of the application
   - Configures Material Design theme with pink primary color
   - Uses Material 3 design system

2. **Dice (Model Class)**
   - Represents a single dice with:
     - `title`: String - The name/category of the dice
     - `options`: List<String> - Available values for this dice
   - Method `roll()`: Returns a random option from the list

3. **DiceRollerPage (StatefulWidget)**
   - Main interactive page of the application
   - Manages app state including:
     - Number of active dice (1-3)
     - Dice configurations
     - Roll results

### State Management

The app uses Flutter's built-in state management with `StatefulWidget` and `setState()`:

- `_numberOfDice`: Controls how many dice are active (1-3)
- `_diceList`: List of Dice objects with their configurations
- `_rollResults`: Stores the results of the last roll (null when not rolled yet)

### Default Dice Configuration

```dart
Dice(title: 'Actions', options: ['Kiss', 'Lick', 'Massage'])
Dice(title: 'Body Area', options: ['Neck', 'Back', 'Hand'])
Dice(title: 'Time', options: ['5 seconds', '10 seconds', '30 seconds'])
```

## User Interface

### Layout Structure

```
Scaffold
├── AppBar
│   └── Title: "Erotic Dice"
└── Body (SingleChildScrollView)
    ├── Dice Configuration Section (Card)
    │   └── Number of Dice Selector (ChoiceChips 1-3)
    ├── Dice Display Section
    │   └── For each active dice:
    │       └── Dice Card
    │           ├── Dice number label
    │           ├── Title TextField (editable)
    │           └── Options preview text
    ├── Roll Button (ElevatedButton)
    │   └── "Roll Dice" with casino icon
    └── Results Display (Card - conditional)
        └── For each result:
            └── Title → Result
```

### UI Features

1. **Dice Configuration Card**
   - Elevated card with shadow
   - Choice chips for selecting 1, 2, or 3 dice
   - Visual indication of selected number

2. **Dice Display Cards**
   - Each dice has its own card
   - Shows dice number (Dice 1, Dice 2, Dice 3)
   - Editable title field with outline border
   - Small text showing available options
   - Edit icon in the title field

3. **Roll Button**
   - Large, prominent button with pink background
   - Casino icon and "Roll Dice" text
   - Elevated with shadow for depth
   - Rounded corners (12px radius)

4. **Results Display**
   - Only appears after rolling
   - Pink background (Colors.pink[50])
   - Star icon with "Result" header
   - Each result shows:
     - Dice title in a colored badge
     - Arrow icon
     - Selected option in bold text

### Responsive Design

- `SingleChildScrollView` ensures content is scrollable on smaller screens
- `SafeArea` prevents content from being hidden by system UI
- Padding and spacing adjust for different screen sizes
- Cards and buttons use relative sizing with `Expanded` widgets

## Color Scheme

- **Primary Color**: Pink (Colors.pink)
- **Background**: White
- **Result Card**: Light pink (Colors.pink[50])
- **Text**: Black (default)
- **Secondary Text**: Grey
- **Button Text**: White on pink background

## User Flow

1. **Launch App**
   → Default: 3 dice configured with default titles
   
2. **Configure Dice** (Optional)
   → Select number of dice (1-3)
   → Edit dice titles as desired
   
3. **Roll Dice**
   → Tap "Roll Dice" button
   → Results appear in colored card below
   
4. **View Results**
   → Each dice shows its title and randomly selected option
   → Roll again to get new results

## Code Quality Features

- **Type Safety**: Full null safety enabled
- **Const Constructors**: Used throughout for performance
- **Comments**: Comprehensive documentation comments
- **Clean Code**: Organized into logical methods
- **Best Practices**: Follows Flutter style guide
- **Responsive**: Works on various screen sizes

## Testing

The app includes comprehensive tests in `test/widget_test.dart`:

- Dice model functionality tests
- Widget rendering tests
- User interaction tests
- Dice rolling functionality tests
- UI state change tests

## Platform Support

- **Android**: API 21+ (Android 5.0 Lollipop and above)
- **iOS**: iOS 11.0 and above
- **Web**: Supported (though optimized for mobile)

## Future Enhancement Possibilities

While not part of the current implementation, potential enhancements could include:

- Custom options per dice (not just titles)
- Save/load dice configurations
- Dice roll animations
- Sound effects
- Multiple color themes
- History of previous rolls
- Sharing results

## Build Configuration

### Android
- Compile SDK: 34
- Min SDK: 21
- Target SDK: 34
- Build Tools: Gradle 8.1.0
- Kotlin: 1.8.22

### iOS
- Deployment Target: iOS 11.0
- Swift: Latest
- Xcode: 14.0+

## Dependencies

- `flutter`: SDK
- `cupertino_icons`: ^1.0.2 (iOS-style icons)
- `flutter_lints`: ^2.0.0 (dev dependency for linting)
