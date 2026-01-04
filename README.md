# Dados Eróticos App

Una aplicación Flutter para lanzar dados eróticos con opciones completamente configurables y persistencia de datos.

## Características

### 🎲 **Funcionalidad Principal**
- **Cantidad de Dados Configurable**: Elige entre 1 a 3 dados
- **Títulos Personalizables**: Asigna títulos personalizados a cada dado
- **Opciones Completamente Editables**: Modifica las opciones de cada dado según tus preferencias
- **Resultados Aleatorios**: Cada dado muestra un resultado aleatorio al lanzarlo

### 🎯 **Opciones Predeterminadas** (en Español):
- **Acciones**: Besar, Lamer, Masajear, Tocar, Acariciar, Mordisquear
- **Parte del Cuerpo**: Cuello, Espalda, Genitales, Pezones, Culo, Labios
- **Tiempo**: 5 segundos, 10 segundos, 30 segundos, 1 minuto, 2 minutos

### 💾 **Persistencia de Datos**
- **Guardado Automático**: Todas las configuraciones se guardan automáticamente
- **Recuperación de Datos**: Tus configuraciones se restauran al abrir la app
- **Funciona en Web**: Utiliza localStorage para persistencia en navegadores

### 🛠️ **Funciones Avanzadas**
- **Editor de Opciones**: Interfaz intuitiva para modificar opciones por dado
- **Restaurar Valores Predeterminados**: Opción para volver a la configuración original
- **Panel de Debug**: Herramientas para troubleshooting de persistencia
- **Indicadores de Estado**: Loading states y mensajes de confirmación
- **Visualización Mejorada**: Opciones mostradas como chips para mejor UX

### 🔒 **Seguridad**
- **Validación de Entrada**: Protección contra caracteres maliciosos
- **Límites de Texto**: Título (50 caracteres), Opciones (100 caracteres)
- **Sanitización**: Filtrado automático de contenido potencialmente peligroso
- **Límite de Opciones**: Máximo 20 opciones por dado

### 🎨 **Interfaz de Usuario**
- **Diseño Responsivo**: Compatible con móviles y web
- **Material Design**: Interfaz moderna y limpia
- **Completamente en Español**: Toda la aplicación localizada
- **Feedback Visual**: Indicadores de carga y mensajes de éxito

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