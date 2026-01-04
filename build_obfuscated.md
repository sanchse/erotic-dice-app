# Code Obfuscation Configuration
# This file contains instructions for obfuscating the Flutter app for production

# Build commands for obfuscated releases:

## Android APK (obfuscated)
flutter build apk --obfuscate --split-debug-info=build/debug-info/

## Android App Bundle (obfuscated) 
flutter build appbundle --obfuscate --split-debug-info=build/debug-info/

## iOS (obfuscated)
flutter build ios --obfuscate --split-debug-info=build/debug-info/

## Web (optimized)
flutter build web --release --web-renderer canvaskit

# The --obfuscate flag will:
# - Rename classes, functions, and variables to meaningless names
# - Make reverse engineering much more difficult
# - Reduce app size
# - Improve performance

# The --split-debug-info flag:
# - Separates debug symbols from the main app
# - Allows crash reporting while keeping code obfuscated
# - Store debug info securely for crash analysis

# Security notes:
# - Keep the debug-info directory secure and private
# - Never commit debug-info to version control
# - Use these builds for production releases only