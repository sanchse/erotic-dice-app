# Application Features Showcase

## ✨ Features Implemented

### 1. Configurable Dice Count (1-3)
The app allows users to select between 1, 2, or 3 dice using easy-to-tap choice chips at the top of the screen.

### 2. Customizable Dice Titles
Each dice has an editable text field where users can customize the title:
- Default Titles:
  - **Actions** (Kiss, Lick, Massage)
  - **Body Area** (Neck, Back, Hand)
  - **Time** (5 seconds, 10 seconds, 30 seconds)

### 3. Random Dice Rolling
When the "Roll Dice" button is pressed:
- Each active dice randomly selects one option
- Results are displayed in a beautiful pink result card
- Each result shows the dice title and selected option

### 4. Responsive Design
- Clean Material Design 3 interface
- Pink color theme throughout
- Scrollable content for smaller screens
- Large, easy-to-tap buttons and controls
- Works on both portrait and landscape orientations

### 5. Code Quality
- ✅ Comprehensive inline comments explaining all logic
- ✅ Clean, organized code structure
- ✅ Flutter best practices followed
- ✅ Type-safe with null safety
- ✅ Efficient random number generation
- ✅ Unit tests for the Dice model
- ✅ Widget tests for UI components
- ✅ Passed code review
- ✅ No security vulnerabilities

## 🎨 User Interface

The app features a clean, modern interface with:

**Color Scheme:**
- Primary: Pink (#E91E63)
- Background: White
- Results Card: Light Pink (#FCE4EC)
- Text: Dark grey/black for readability

**Layout:**
1. **App Bar** - Pink background with "Erotic Dice" title
2. **Dice Configuration Card** - Select number of dice (1-3)
3. **Dice Display Section** - Shows each active dice with editable title
4. **Roll Button** - Large pink button with dice icon
5. **Results Display** - Appears after rolling, shows results with visual badges

## 🎲 How to Use

1. **Choose Number of Dice**: Tap on 1, 2, or 3 at the top
2. **Customize Titles** (Optional): Edit the title field for any dice
3. **Roll the Dice**: Tap the big "Roll Dice" button
4. **View Results**: See your random results displayed below

## 📱 Platform Support

- **Android**: API Level 21+ (Android 5.0 Lollipop and above)
- **iOS**: iOS 11.0 and above
- **Web**: Supported (optimized for mobile)

## 🧪 Testing

The app includes comprehensive tests:
- Dice model tests (roll functionality, title updates)
- Widget tests (app loading, button presence, dice configuration)
- Interaction tests (rolling dice, changing number of dice)

## 📚 Documentation

Three comprehensive documentation files included:
1. **README.md** - Quick start guide and usage instructions
2. **TECHNICAL_DOCS.md** - Architecture, components, and technical details
3. **UI_DESIGN.md** - Visual design specifications and UI layouts

## 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/sanchse/erotic-dice-app.git

# Navigate to project directory
cd erotic-dice-app

# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
```

## 💡 Key Implementation Details

**Architecture:**
- Uses StatefulWidget for state management
- Clean separation between model (Dice) and view (DiceRollerPage)
- Efficient static Random instance for better performance

**State Variables:**
- `_numberOfDice`: Tracks active dice count (1-3)
- `_diceList`: List of 3 Dice objects with titles and options
- `_rollResults`: Stores current roll results (null when not rolled)

**Widgets:**
- `EroticDiceApp`: Root application widget
- `DiceRollerPage`: Main interactive page
- Custom builder methods for each UI section

## ✅ All Requirements Met

✓ Configure between 1-3 dice
✓ Customizable dice titles
✓ Default titles: Actions, Body Area, Time
✓ Random results on roll
✓ Predefined options for each category
✓ Flutter framework
✓ iOS and Android support
✓ Responsive design
✓ Clean code with comments
✓ Best practices followed
