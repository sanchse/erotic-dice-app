# App Screenshots and UI Description

## Main Screen - Initial State

```
┌─────────────────────────────────────┐
│  Erotic Dice                    ≡   │  ← AppBar
├─────────────────────────────────────┤
│                                     │
│  ╔═══════════════════════════════╗ │
│  ║   Number of Dice              ║ │  ← Configuration Card
│  ║                               ║ │
│  ║    [ 1 ]  [ 2 ]  [✓3 ]       ║ │  ← Choice chips
│  ╚═══════════════════════════════╝ │
│                                     │
│  Dice Configuration                 │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Dice 1                        │ │
│  │ ┌─────────────────────────┐  │ │  ← Editable title field
│  │ │ Title: Actions      ✎   │  │ │
│  │ └─────────────────────────┘  │ │
│  │ Options: Kiss, Lick, Massage │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Dice 2                        │ │
│  │ ┌─────────────────────────┐  │ │
│  │ │ Title: Body Area    ✎   │  │ │
│  │ └─────────────────────────┘  │ │
│  │ Options: Neck, Back, Hand    │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Dice 3                        │ │
│  │ ┌─────────────────────────┐  │ │
│  │ │ Title: Time         ✎   │  │ │
│  │ └─────────────────────────┘  │ │
│  │ Options: 5 seconds, 10 se... │ │
│  └───────────────────────────────┘ │
│                                     │
│  ╔═══════════════════════════════╗ │
│  ║     🎲  Roll Dice             ║ │  ← Roll Button
│  ╚═══════════════════════════════╝ │
│                                     │
└─────────────────────────────────────┘
```

## After Rolling - Results Displayed

```
┌─────────────────────────────────────┐
│  Erotic Dice                    ≡   │
├─────────────────────────────────────┤
│                                     │
│  ... (Configuration sections) ...   │
│                                     │
│  ╔═══════════════════════════════╗ │
│  ║     🎲  Roll Dice             ║ │
│  ╚═══════════════════════════════╝ │
│                                     │
│  ╔═══════════════════════════════╗ │  ← Results Card (Pink background)
│  ║ ✨ Result                     ║ │
│  ║                               ║ │
│  ║ ┌─────────┐                   ║ │
│  ║ │ Actions │ → Kiss            ║ │
│  ║ └─────────┘                   ║ │
│  ║                               ║ │
│  ║ ┌───────────┐                 ║ │
│  ║ │ Body Area │ → Neck          ║ │
│  ║ └───────────┘                 ║ │
│  ║                               ║ │
│  ║ ┌──────┐                      ║ │
│  ║ │ Time │ → 10 seconds         ║ │
│  ║ └──────┘                      ║ │
│  ╚═══════════════════════════════╝ │
│                                     │
└─────────────────────────────────────┘
```

## With 1 Dice Selected

```
┌─────────────────────────────────────┐
│  Erotic Dice                    ≡   │
├─────────────────────────────────────┤
│                                     │
│  ╔═══════════════════════════════╗ │
│  ║   Number of Dice              ║ │
│  ║                               ║ │
│  ║    [✓1 ]  [ 2 ]  [ 3 ]       ║ │  ← Only 1 selected
│  ╚═══════════════════════════════╝ │
│                                     │
│  Dice Configuration                 │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Dice 1                        │ │  ← Only one dice shown
│  │ ┌─────────────────────────┐  │ │
│  │ │ Title: Actions      ✎   │  │ │
│  │ └─────────────────────────┘  │ │
│  │ Options: Kiss, Lick, Massage │ │
│  └───────────────────────────────┘ │
│                                     │
│  ╔═══════════════════════════════╗ │
│  ║     🎲  Roll Dice             ║ │
│  ╚═══════════════════════════════╝ │
│                                     │
└─────────────────────────────────────┘
```

## UI Color Reference

- **Primary Theme**: Pink (#E91E63 - Material Pink)
- **AppBar**: Pink with white text
- **Cards**: White with subtle shadow/elevation
- **Roll Button**: Pink background, white text, elevated
- **Results Card**: Light pink background (#FCE4EC)
- **Title Badges**: Pink background, white text
- **Text**: Dark grey/black on white
- **Borders**: Light grey for input fields

## Interactive Elements

1. **Choice Chips (1, 2, 3)**
   - Inactive: Light grey background
   - Active: Pink background with checkmark
   - Touch feedback: Ripple effect

2. **Title Input Fields**
   - Border: Grey outline
   - Focus: Pink outline
   - Edit icon: Grey, changes to pink on hover

3. **Roll Button**
   - Idle: Pink background, elevated
   - Pressed: Darker pink, less elevation
   - Ripple effect on tap

4. **Results Card**
   - Appears with slide-in animation (via setState)
   - Pink background to distinguish from configuration

## Responsive Behavior

- **Portrait Mode**: Optimized default layout
- **Landscape Mode**: Content scrolls as needed
- **Small Screens**: All content remains accessible via scroll
- **Large Screens/Tablets**: Components center with max width

## Accessibility Features

- Semantic labels on all interactive elements
- Sufficient touch target sizes (minimum 48x48 dp)
- High contrast text for readability
- Support for screen readers
- Keyboard navigation support (when applicable)
