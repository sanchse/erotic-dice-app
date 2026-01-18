import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const EroticDiceApp());
}

/// Main application widget
class EroticDiceApp extends StatelessWidget {
  const EroticDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dados Eróticos',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const MainMenuPage(), // Changed to show menu first
    );
  }
}

/// Main menu to choose between different dice types
class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados Eróticos'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Icon(
                Icons.casino,
                size: 80,
                color: Colors.pink,
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Elige tu tipo de dados!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildMenuCard(
                context,
                title: 'Dados Tradicionales',
                subtitle: 'Acciones, partes del cuerpo y tiempo',
                imagePath: 'assets/kamasutra/default.svg',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiceRollerPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMenuCard(
                context,
                title: 'Dados Kamasutra',
                subtitle: 'Posiciones con imágenes ilustrativas',
                imagePath: 'assets/kamasutra/logo.svg',
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KamasutraPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  imagePath,
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Model class representing a single dice
class Dice {
  String title;
  final List<String> options;
  static final Random _random = Random();

  Dice({required this.title, required this.options});

  /// Roll the dice and return a random option
  String roll() {
    // Create a list of 6 options, filling empty slots with "?"
    final fullOptions = List<String>.generate(6, (index) {
      return index < options.length ? options[index] : '?';
    });
    return fullOptions[_random.nextInt(fullOptions.length)];
  }

  /// Get all 6 options including question marks for empty slots
  List<String> get fullOptions {
    return List<String>.generate(6, (index) {
      return index < options.length ? options[index] : '?';
    });
  }
}

/// 3D Dice Widget for realistic dice visualization
class DiceWidget extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final double size;
  final bool isRolling;
  final Animation<double>? rotationAnimation;
  final Color color;

  const DiceWidget({
    super.key,
    required this.options,
    this.selectedOption,
    this.size = 80,
    this.isRolling = false,
    this.rotationAnimation,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    if (isRolling && rotationAnimation != null) {
      return AnimatedBuilder(
        animation: rotationAnimation!,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(rotationAnimation!.value * 2 * pi)
              ..rotateY(rotationAnimation!.value * 1.5 * pi)
              ..rotateZ(rotationAnimation!.value * 2.5 * pi),
            child: _buildDice(),
          );
        },
      );
    } else {
      // Static dice showing result
      return _buildDice();
    }
  }

  Widget _buildDice() {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: DicePainter(
          options: options,
          selectedOption: selectedOption,
          color: color,
        ),
      ),
    );
  }
}

/// Custom painter for 3D dice with text on faces
class DicePainter extends CustomPainter {
  final List<String> options;
  final String? selectedOption;
  final Color color;

  DicePainter({
    required this.options,
    this.selectedOption,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final cubeSize = size.width * 0.65;
    final depth = cubeSize * 0.4; // More balanced depth

    // Enhanced shadow - positioned more naturally
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Draw shadow offset down and right
    final shadowOffset = Offset(depth * 0.3, depth * 0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + shadowOffset,
          width: cubeSize * 0.9,
          height: cubeSize * 0.9,
        ),
        const Radius.circular(4),
      ),
      shadowPaint,
    );

    // Calculate cube vertices for isometric view
    final halfSize = cubeSize / 2;
    final isoX = depth * 0.6; // Isometric X offset
    final isoY = depth * 0.35; // Isometric Y offset

    // Front face vertices
    final frontTL = Offset(center.dx - halfSize, center.dy - halfSize);
    final frontTR = Offset(center.dx + halfSize, center.dy - halfSize);
    final frontBL = Offset(center.dx - halfSize, center.dy + halfSize);
    final frontBR = Offset(center.dx + halfSize, center.dy + halfSize);

    // Back face vertices (with isometric offset)
    final backTL = Offset(frontTL.dx + isoX, frontTL.dy - isoY);
    final backTR = Offset(frontTR.dx + isoX, frontTR.dy - isoY);
    final backBR = Offset(frontBR.dx + isoX, frontBR.dy - isoY);

    // Paint for different faces with proper lighting
    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          _darkenColor(color, 0.1),
        ],
      ).createShader(Rect.fromLTRB(frontTL.dx, frontTL.dy, frontBR.dx, frontBR.dy))
      ..style = PaintingStyle.fill;

    final topPaint = Paint()
      ..color = _lightenColor(color, 0.15) // Top face is lighter
      ..style = PaintingStyle.fill;

    final rightPaint = Paint()
      ..color = _darkenColor(color, 0.25) // Right face is darker
      ..style = PaintingStyle.fill;

    final edgePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw top face
    final topPath = Path()
      ..moveTo(frontTL.dx, frontTL.dy)
      ..lineTo(frontTR.dx, frontTR.dy)
      ..lineTo(backTR.dx, backTR.dy)
      ..lineTo(backTL.dx, backTL.dy)
      ..close();
    canvas.drawPath(topPath, topPaint);
    canvas.drawPath(topPath, edgePaint);

    // Draw right face
    final rightPath = Path()
      ..moveTo(frontTR.dx, frontTR.dy)
      ..lineTo(frontBR.dx, frontBR.dy)
      ..lineTo(backBR.dx, backBR.dy)
      ..lineTo(backTR.dx, backTR.dy)
      ..close();
    canvas.drawPath(rightPath, rightPaint);
    canvas.drawPath(rightPath, edgePaint);

    // Draw front face with gradient
    final frontPath = Path()
      ..moveTo(frontTL.dx, frontTL.dy)
      ..lineTo(frontTR.dx, frontTR.dy)
      ..lineTo(frontBR.dx, frontBR.dy)
      ..lineTo(frontBL.dx, frontBL.dy)
      ..close();
    canvas.drawPath(frontPath, frontPaint);
    canvas.drawPath(frontPath, edgePaint);

    // Draw text on front face
    // For dice display, create a list of 6 options with "?" for empty slots
    final diceOptions = List<String>.generate(6, (index) {
      return index < options.length ? options[index] : '?';
    });
    String displayText = selectedOption ?? (diceOptions.isNotEmpty ? diceOptions[0] : '');
    if (displayText.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: displayText,
          style: TextStyle(
            color: Colors.black87,
            fontSize: _calculateFontSize(displayText, cubeSize),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: const Offset(0.5, 0.5),
                blurRadius: 0.5,
                color: Colors.black38,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout(maxWidth: cubeSize - 20);
      
      final textCenter = Offset(
        (frontTL.dx + frontBR.dx) / 2 - textPainter.width / 2,
        (frontTL.dy + frontBR.dy) / 2 - textPainter.height / 2,
      );

      textPainter.paint(canvas, textCenter);
    }
  }

  /// Helper method to lighten a color
  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }

  /// Helper method to darken a color by a percentage
  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  double _calculateFontSize(String text, double cubeSize) {
    if (text.length <= 8) return cubeSize * 0.22;  // Reducido de 0.25 a 0.22
    if (text.length <= 12) return cubeSize * 0.18; // Reducido de 0.21 a 0.18
    return cubeSize * 0.15; // Reducido de 0.18 a 0.15
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Main page for dice rolling functionality
class DiceRollerPage extends StatefulWidget {
  const DiceRollerPage({super.key});

  @override
  State<DiceRollerPage> createState() => _DiceRollerPageState();
}

class _DiceRollerPageState extends State<DiceRollerPage> 
    with TickerProviderStateMixin {
  // Number of dice to display (1-3)
  int _numberOfDice = 3;
  
  // List of dice with their titles and options
  late List<Dice> _diceList;
  
  // Results from the last roll
  List<String>? _rollResults;
  
  // Loading state for initialization
  bool _isLoading = true;
  
  // Audio player for sound effects
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Animation state and controllers
  bool _isRolling = false;
  late AnimationController _diceAnimationController;
  late AnimationController _resultAnimationController;
  late Animation<double> _diceRotationAnimation;
  late Animation<double> _diceScaleAnimation;
  late Animation<double> _resultFadeAnimation;
  
  // Countdown timer functionality
  Timer? _countdownTimer;
  int _countdownSeconds = 0;
  int _detectedSeconds = 0; // Tiempo detectado antes de iniciar
  String _detectedTimeText = ''; // Texto original del tiempo detectado
  bool _showCountdown = false;
  bool _isCountdownActive = false;
  bool _isCountdownPaused = false; // Control de pausa
  bool _showCountdownPending = false; // Mostrar tiempo detectado sin iniciar
  TextEditingController _customTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _diceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Initialize animations
    _diceRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 4.0, // 4 full rotations
    ).animate(CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _diceScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.elasticInOut,
    ));
    
    _resultFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultAnimationController,
      curve: Curves.easeIn,
    ));
    
    _loadSavedConfiguration();
  }

  @override
  void dispose() {
    _diceAnimationController.dispose();
    _resultAnimationController.dispose();
    _audioPlayer.dispose();
    _countdownTimer?.cancel();
    _customTimeController.dispose();
    super.dispose();
  }

  /// Load saved dice configuration from SharedPreferences
  Future<void> _loadSavedConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedConfig = prefs.getString('dice_configuration');
      
      debugPrint('Loading configuration: $savedConfig');
      
      if (savedConfig != null && savedConfig.isNotEmpty) {
        final configData = json.decode(savedConfig) as Map<String, dynamic>;
        final numberOfDice = configData['numberOfDice'] as int? ?? 3;
        final diceConfigs = configData['diceList'] as List<dynamic>? ?? [];
        
        debugPrint('Loaded numberOfDice: $numberOfDice');
        debugPrint('Loaded diceConfigs: $diceConfigs');
        
        setState(() {
          _numberOfDice = numberOfDice;
          _diceList = diceConfigs.map((config) {
            final configMap = config as Map<String, dynamic>;
            return Dice(
              title: configMap['title'] as String,
              options: List<String>.from(configMap['options'] as List),
            );
          }).toList();
          
          // Ensure we have at least the required number of dice
          while (_diceList.length < 3) {
            _diceList.add(Dice(
              title: 'Dado ${_diceList.length + 1}',
              options: ['Opción 1', 'Opción 2', 'Opción 3'],
            ));
          }
        });
        
        debugPrint('Configuration loaded successfully');
      } else {
        // No saved configuration, use defaults
        debugPrint('No saved configuration found, using defaults');
        _initializeDice();
      }
    } catch (e) {
      // If there's an error loading, fall back to defaults
      debugPrint('Error loading configuration: $e');
      _initializeDice();
    }
    
    // Clear results when loading and set loading to false
    setState(() {
      _rollResults = null;
      _isLoading = false;
    });
  }

  /// Save current dice configuration to SharedPreferences
  Future<void> _saveConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configData = {
        'numberOfDice': _numberOfDice,
        'diceList': _diceList.map((dice) => {
          'title': dice.title,
          'options': dice.options,
        }).toList(),
      };
      
      final jsonString = json.encode(configData);
      debugPrint('Saving configuration: $jsonString');
      
      final success = await prefs.setString('dice_configuration', jsonString);
      debugPrint('Save successful: $success');
      
      // Verify the save by reading it back
      final savedValue = prefs.getString('dice_configuration');
      debugPrint('Verification read: $savedValue');
      
    } catch (e) {
      // Handle save error with more detail
      debugPrint('Error saving configuration: $e');
    }
  }

  /// Initialize dice with default configurations
  void _initializeDice() {
    _diceList = [
      Dice(
        title: 'Acción',
        options: ['Besar', 'Lamer', 'Masajear', 'Tocar', 'Acariciar', 'Mordisquear'],
      ),
      Dice(
        title: 'Parte del Cuerpo',
        options: ['Cuello', 'Espalda', 'Genitales', 'Pezones', 'Culo', 'Labios'],
      ),
      Dice(
        title: 'Tiempo',
        options: ['30 seg', '1 min', '2 min', '3 min', '5 min', '?'],
      ),
    ];
    _rollResults = null;
  }

  /// Reset dice to default configurations
  void _resetToDefaults() async {
    setState(() {
      _initializeDice();
    });
    await _saveConfiguration();
  }

  /// Roll all active dice and update results with animation
  void _rollDice() async {
    setState(() {
      _isRolling = true;
      _rollResults = null;
    });
    
    // Play dice roll sound or vibrate as fallback
    try {
      await _audioPlayer.play(AssetSource('sounds/dice_roll.mp3'));
    } catch (e) {
      debugPrint('Error playing dice roll sound: $e');
      // Use haptic feedback as fallback
      try {
        await HapticFeedback.mediumImpact();
      } catch (hapticError) {
        debugPrint('Error with haptic feedback: $hapticError');
      }
    }
    
    // Start dice animation
    _diceAnimationController.reset();
    _diceAnimationController.forward();
    
    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Generate results
    final results = <String>[];
    for (int i = 0; i < _numberOfDice; i++) {
      results.add(_diceList[i].roll());
    }
    
    setState(() {
      _rollResults = results;
      _isRolling = false;
    });
    
    // Check if there's a time dice and configure countdown
    _checkAndConfigureCountdown(results);
    
    // Animate results appearance
    _resultAnimationController.reset();
    _resultAnimationController.forward();
  }

  /// Check if there's a time dice and configure countdown
  void _checkAndConfigureCountdown(List<String> results) {
    // Only check for countdown if we have 3 dice (traditional dice setup)
    if (results.length != 3) return;
    
    // Check if the third dice contains time values
    final timeDiceResult = results[2];
    _parseAndSetCountdown(timeDiceResult);
  }

  /// Parse time value and prepare countdown (don't start automatically)
  void _parseAndSetCountdown(String timeValue) {
    int seconds = 0;
    
    // Try to parse time in different formats
    if (timeValue == "?") {
      // Show dialog to input custom time
      _showCustomTimeDialog();
      return;
    }
    
    // Try to parse "X minuto(s) y Y segundo(s)" format or "X min Y seg" format
    final combinedMatch = RegExp(
      r'(\d+)\s*(?:minuto|min)(?:s)?\s*(?:y)?\s*(\d+)\s*(?:segundo|seg)(?:s)?',
      caseSensitive: false
    ).firstMatch(timeValue);
    
    if (combinedMatch != null) {
      final minutes = int.tryParse(combinedMatch.group(1) ?? '0') ?? 0;
      final secs = int.tryParse(combinedMatch.group(2) ?? '0') ?? 0;
      seconds = (minutes * 60) + secs;
    } else {
      // Try to parse "X min" or "X minuto(s)" format
      final minMatch = RegExp(r'(\d+)\s*(?:minuto|min)(?:s)?', caseSensitive: false).firstMatch(timeValue);
      if (minMatch != null) {
        final minutes = int.tryParse(minMatch.group(1) ?? '0') ?? 0;
        seconds = minutes * 60;
      } else {
        // Only try to parse seconds if no minutes were found
        // Try to parse "X seg" or "X segundo(s)" format
        final secMatch = RegExp(r'(\d+)\s*(?:segundo|seg)(?:s)?', caseSensitive: false).firstMatch(timeValue);
        if (secMatch != null) {
          seconds = int.tryParse(secMatch.group(1) ?? '0') ?? 0;
        } else {
          // Try to parse plain number (assume minutes)
          final number = int.tryParse(timeValue);
          if (number != null && number > 0 && number <= 60) {
            seconds = number * 60; // Convert to seconds
          }
        }
      }
    }
    
    if (seconds > 0) {
      // Don't start countdown automatically, just show the detected time
      setState(() {
        _detectedSeconds = seconds;
        _detectedTimeText = timeValue;
        _showCountdownPending = true;
        _showCountdown = false;
      });
    }
  }

  /// Start countdown with specified seconds
  void _startCountdown(int seconds) {
    _stopCountdown(); // Stop any existing countdown
    
    setState(() {
      _countdownSeconds = seconds;
      _showCountdown = true;
      _isCountdownActive = true;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
      });
      
      // Play countdown sound 3 seconds before finish (when audio starts)
      if (_countdownSeconds == 3) {
        _playCountdownFinishedSound();
      }
      
      // Countdown finished
      if (_countdownSeconds <= 0) {
        _stopCountdown();
        _showCountdownFinishedDialog();
      }
    });
  }

  /// Stop the countdown completely
  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    setState(() {
      _isCountdownActive = false;
      _isCountdownPaused = false;
    });
  }

  /// Pause the countdown
  void _pauseCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    setState(() {
      _isCountdownPaused = true;
    });
  }

  /// Resume the countdown
  void _resumeCountdown() {
    setState(() {
      _isCountdownPaused = false;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
      });
      
      // Play countdown sound 3 seconds before finish (when audio starts)
      if (_countdownSeconds == 3) {
        _playCountdownFinishedSound();
      }
      
      // Countdown finished
      if (_countdownSeconds <= 0) {
        _stopCountdown();
        _showCountdownFinishedDialog();
      }
    });
  }

  /// Play sound when countdown finishes
  void _playCountdownFinishedSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/countdown.mp3'));
    } catch (e) {
      debugPrint('Error playing countdown finished sound: $e');
      try {
        await HapticFeedback.heavyImpact();
      } catch (hapticError) {
        debugPrint('Error with haptic feedback: $hapticError');
      }
    }
  }

  /// Show dialog for custom time input
  void _showCustomTimeDialog() async {
    _customTimeController.clear();
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tiempo Personalizado'),
          content: TextField(
            controller: _customTimeController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              labelText: 'Segundos',
              hintText: 'Ingresa el tiempo en segundos',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                final seconds = int.tryParse(_customTimeController.text);
                if (seconds != null && seconds > 0) {
                  setState(() {
                    _detectedSeconds = seconds;
                    _detectedTimeText = '$seconds seg';
                    _showCountdownPending = true;
                    _showCountdown = false;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Show dialog when countdown finishes
  void _showCountdownFinishedDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Tiempo Terminado!'),
          content: const Text('El contador regresivo ha llegado a cero.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _showCountdown = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  /// Update the title of a specific dice
  void _updateDiceTitle(int index, String newTitle) async {
    // Input validation and sanitization
    final sanitizedTitle = _sanitizeInput(newTitle);
    if (sanitizedTitle.isEmpty || sanitizedTitle.length > 50) {
      return; // Ignore invalid input
    }
    
    setState(() {
      _diceList[index].title = sanitizedTitle;
    });
    await _saveConfiguration();
  }

  /// Update the options of a specific dice
  void _updateDiceOptions(int index, List<String> newOptions) async {
    // Input validation and sanitization
    final sanitizedOptions = newOptions
        .map((option) => _sanitizeInput(option))
        .where((option) => option.isNotEmpty && option.length <= 100)
        .take(20) // Limit to maximum 20 options
        .toList();
    
    setState(() {
      _diceList[index].options.clear();
      _diceList[index].options.addAll(sanitizedOptions);
      if (_diceList[index].options.isEmpty) {
        _diceList[index].options.add('Opción Predeterminada');
      }
    });
    await _saveConfiguration();
  }

  /// Sanitize user input to prevent security issues
  String _sanitizeInput(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'[<>"&]'), '') // Remove potentially dangerous characters
        .replaceAll(RegExp(r'\s+'), ' '); // Normalize whitespace
  }

  /// Show dialog to edit dice options
  Future<void> _showEditOptionsDialog(int index) async {
    final TextEditingController controller = TextEditingController();
    controller.text = _diceList[index].options.join('\n');

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Opciones para ${_diceList[index].title}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingresa cada opción en una nueva línea:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Opción 1\nOpción 2\nOpción 3',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                final newOptions = controller.text
                    .split('\n')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();
                
                if (newOptions.isNotEmpty) {
                  _updateDiceOptions(index, newOptions);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opciones guardadas exitosamente'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
                
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Show confirmation dialog for resetting to defaults
  Future<void> _showResetConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restaurar Valores Predeterminados'),
          content: const Text(
            'Esto restaurará todos los títulos y opciones de los dados a sus valores predeterminados. ¿Estás seguro?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Restaurar'),
              onPressed: () {
                _resetToDefaults();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dados restaurados a la configuración predeterminada'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Show debug dialog for persistence testing
  Future<void> _showDebugDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final savedConfig = prefs.getString('dice_configuration');
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Debug Persistencia'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Configuración guardada:'),
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    savedConfig ?? 'No hay configuración guardada',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Configuración actual:'),
                const SizedBox(height: 8),
                Text('Número de dados: $_numberOfDice'),
                for (int i = 0; i < _diceList.length; i++)
                  Text('Dado ${i + 1}: ${_diceList[i].title} - ${_diceList[i].options.join(", ")}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Guardar Ahora'),
              onPressed: () async {
                await _saveConfiguration();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configuración guardada manualmente')),
                );
              },
            ),
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Build a summary card showing current dice configuration
  Widget _buildDiceSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.casino, color: Colors.pink),
                const SizedBox(width: 8),
                const Text(
                  'Configuración Actual',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConfigurationPage(
                          diceList: _diceList,
                          numberOfDice: _numberOfDice,
                          onConfigurationChanged: (newDiceList, newNumberOfDice) {
                            setState(() {
                              _diceList = newDiceList;
                              _numberOfDice = newNumberOfDice;
                              _rollResults = null;
                            });
                            _saveConfiguration();
                          },
                          onResetToDefaults: () {
                            _resetToDefaults();
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings, size: 16),
                  label: const Text('Configurar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Dados activos: $_numberOfDice',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < _numberOfDice; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.pink.withOpacity(0.3)),
                      ),
                      child: Text(
                        _diceList[i].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_diceList[i].options.length}/6 opciones: ${_diceList[i].options.take(3).join(", ")}${_diceList[i].options.length > 3 ? "..." : ""}${_diceList[i].options.length < 6 ? " + ?" : ""}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDiceSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Reducido de 20.0 a 16.0
        child: Column(
          children: [
            // Solo mostrar los dados girando - el estado se muestra en el botón
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Cambiado de spaceEvenly a spaceAround
              children: [
                for (int i = 0; i < _numberOfDice; i++)
                  DiceWidget(
                    options: _diceList[i].fullOptions,
                    size: 110, // Reducido de 120 a 110
                    isRolling: true,
                    rotationAnimation: _diceRotationAnimation,
                    color: Colors.white,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados Eróticos'),
        elevation: 2,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'config') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ConfigurationPage(
                      diceList: _diceList,
                      numberOfDice: _numberOfDice,
                      onConfigurationChanged: (newDiceList, newNumberOfDice) {
                        setState(() {
                          _diceList = newDiceList;
                          _numberOfDice = newNumberOfDice;
                          _rollResults = null;
                        });
                        _saveConfiguration();
                      },
                      onResetToDefaults: () {
                        _resetToDefaults();
                      },
                    ),
                  ),
                );
              } else if (result == 'reset') {
                _showResetConfirmationDialog();
              } else if (result == 'debug') {
                _showDebugDialog();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'config',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Configuración'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Restaurar Valores Predeterminados'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'debug',
                child: Row(
                  children: [
                    Icon(Icons.bug_report),
                    SizedBox(width: 8),
                    Text('Debug Persistencia'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando tu configuración de dados...'),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Roll button - siempre visible en la misma posición
                    _buildRollButton(),
                    const SizedBox(height: 24),
                    
                    // Animated dice section - aparece debajo del botón
                    if (_isRolling) _buildAnimatedDiceSection(),
                    if (_isRolling) const SizedBox(height: 24),
                    
                    // Results display
                    if (_rollResults != null && !_isRolling) 
                      FadeTransition(
                        opacity: _resultFadeAnimation,
                        child: _buildResultsDisplay(),
                      ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  /// Build the dice configuration section with number selector
  Widget _buildDiceConfigurationSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Número de Dados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 3; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text('$i'),
                      selected: _numberOfDice == i,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _numberOfDice = i;
                            _rollResults = null; // Clear results when changing dice count
                          });
                          _saveConfiguration();
                        }
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build the dice display section showing active dice and their titles
  Widget _buildDiceDisplaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configuración de Dados',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < _numberOfDice; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildDiceCard(i),
          ),
      ],
    );
  }

  /// Build a card for an individual dice with editable title and options
  Widget _buildDiceCard(int index) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dado ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: _diceList[index].title,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) => _updateDiceTitle(index, value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Opciones:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar'),
                  onPressed: () => _showEditOptionsDialog(index),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _diceList[index].options.map((option) {
                  return Chip(
                    label: Text(
                      option,
                      style: const TextStyle(fontSize: 12),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the roll button
  Widget _buildRollButton() {
    return ElevatedButton(
      onPressed: _isRolling ? null : _rollDice,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        backgroundColor: _isRolling 
            ? Colors.grey 
            : Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isRolling)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else
            const Icon(Icons.casino, size: 28),
          const SizedBox(width: 12),
          Text(
            _isRolling ? 'Lanzando...' : 'Lanzar Dados',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsDisplay() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Reducido de 20.0 a 16.0
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '¡Resultado!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Cambiado de spaceEvenly a spaceAround
              children: [
                for (int i = 0; i < _rollResults!.length; i++)
                  Column(
                    children: [
                      DiceWidget(
                        options: _diceList[i].fullOptions,
                        size: 110, // Reducido de 120 a 110
                        isRolling: false,
                        selectedOption: _rollResults![i],
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 110),
                        child: Text(
                          _diceList[i].title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.pink,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            // Countdown timer display
            if (_showCountdown) _buildCountdownWidget(),
            // Show detected time before starting countdown
            if (_showCountdownPending) _buildCountdownPendingWidget(),
          ],
        ),
      ),
    );
  }

  /// Build countdown timer widget
  Widget _buildCountdownWidget() {
    final minutes = _countdownSeconds ~/ 60;
    final seconds = _countdownSeconds % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        elevation: 2,
        color: _isCountdownPaused 
            ? Colors.orange.shade50 
            : (_countdownSeconds <= 10 ? Colors.red.shade50 : Colors.blue.shade50),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCountdownPaused ? Icons.pause_circle_outline : Icons.timer,
                    color: _isCountdownPaused 
                        ? Colors.orange 
                        : (_countdownSeconds <= 10 ? Colors.red : Colors.blue),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isCountdownPaused ? 'Contador Pausado' : 'Contador Regresivo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isCountdownPaused 
                          ? Colors.orange 
                          : (_countdownSeconds <= 10 ? Colors.red : Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                timeString,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _isCountdownPaused 
                      ? Colors.orange 
                      : (_countdownSeconds <= 10 ? Colors.red : Colors.blue),
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_isCountdownActive && !_isCountdownPaused)
                    ElevatedButton.icon(
                      onPressed: _pauseCountdown,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pausar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (_isCountdownPaused)
                    ElevatedButton.icon(
                      onPressed: _resumeCountdown,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Reanudar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _stopCountdown();
                      setState(() {
                        _showCountdown = false;
                      });
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Cerrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build countdown pending widget (before starting)
  Widget _buildCountdownPendingWidget() {
    final minutes = _detectedSeconds ~/ 60;
    final seconds = _detectedSeconds % 60;
    final timeString = minutes > 0 
        ? (seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes} min')
        : '${seconds} seg';
    
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        elevation: 2,
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tiempo Detectado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Resultado: $_detectedTimeText',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                timeString,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Listo para comenzar el contador?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showCountdownPending = false;
                      });
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _confirmAndStartCountdown,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Confirm and start countdown
  void _confirmAndStartCountdown() {
    setState(() {
      _showCountdownPending = false;
    });
    _startCountdown(_detectedSeconds);
  }

}

/// Configuration page for managing dice settings
class ConfigurationPage extends StatefulWidget {
  final List<Dice> diceList;
  final int numberOfDice;
  final Function(List<Dice>, int) onConfigurationChanged;
  final VoidCallback onResetToDefaults;

  const ConfigurationPage({
    super.key,
    required this.diceList,
    required this.numberOfDice,
    required this.onConfigurationChanged,
    required this.onResetToDefaults,
  });

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  late List<Dice> _localDiceList;
  late int _localNumberOfDice;

  @override
  void initState() {
    super.initState();
    // Create local copies to work with
    _localDiceList = widget.diceList.map((dice) => Dice(
      title: dice.title,
      options: List<String>.from(dice.options),
    )).toList();
    _localNumberOfDice = widget.numberOfDice;
  }

  /// Sanitize user input to prevent security issues
  String _sanitizeInput(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'[<>"&]'), '') // Remove potentially dangerous characters
        .replaceAll(RegExp(r'\s+'), ' '); // Normalize whitespace
  }

  /// Update the title of a specific dice
  void _updateDiceTitle(int index, String newTitle) {
    final sanitizedTitle = _sanitizeInput(newTitle);
    if (sanitizedTitle.isEmpty || sanitizedTitle.length > 50) {
      return;
    }
    
    setState(() {
      _localDiceList[index].title = sanitizedTitle;
    });
  }

  /// Update the options of a specific dice
  void _updateDiceOptions(int index, List<String> newOptions) {
    final sanitizedOptions = newOptions
        .map((option) => _sanitizeInput(option))
        .where((option) => option.isNotEmpty && option.length <= 100)
        .take(6) // Limit to maximum 6 options for a dice
        .toList();
    
    setState(() {
      _localDiceList[index].options.clear();
      _localDiceList[index].options.addAll(sanitizedOptions);
      if (_localDiceList[index].options.isEmpty) {
        _localDiceList[index].options.add('Opción Predeterminada');
      }
    });
  }

  /// Show dialog to edit dice options
  Future<void> _showEditOptionsDialog(int index) async {
    final TextEditingController controller = TextEditingController();
    controller.text = _localDiceList[index].options.join('\n');

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Opciones para ${_localDiceList[index].title}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingresa cada opción en una nueva línea (máximo 6 opciones):',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Las opciones faltantes se mostrarán como "?" en el dado.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Opción 1\nOpción 2\nOpción 3\nOpción 4\nOpción 5\nOpción 6',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                final newOptions = controller.text
                    .split('\n')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();
                
                if (newOptions.isNotEmpty) {
                  _updateDiceOptions(index, newOptions);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opciones guardadas exitosamente'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
                
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Remove an option from a specific dice
  void _removeOption(int diceIndex, int optionIndex) {
    if (_localDiceList[diceIndex].options.length > 1) {
      setState(() {
        _localDiceList[diceIndex].options.removeAt(optionIndex);
      });
    }
  }

  /// Show dialog to add a new option
  Future<void> _showAddOptionDialog(int index) async {
    final TextEditingController controller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Opción a ${_localDiceList[index].title}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Nueva opción',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Agregar'),
              onPressed: () {
                final newOption = _sanitizeInput(controller.text);
                
                if (newOption.isNotEmpty && 
                    _localDiceList[index].options.length < 6 &&
                    !_localDiceList[index].options.contains(newOption)) {
                  setState(() {
                    _localDiceList[index].options.add(newOption);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opción "$newOption" agregada exitosamente'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                } else if (_localDiceList[index].options.contains(newOption)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Esta opción ya existe'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
                
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Build the dice configuration section with number selector
  Widget _buildDiceConfigurationSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Número de Dados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 3; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text('$i'),
                      selected: _localNumberOfDice == i,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _localNumberOfDice = i;
                          });
                        }
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build the dice display section showing active dice and their titles
  Widget _buildDiceDisplaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configuración de Dados',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < _localNumberOfDice; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildDiceCard(i),
          ),
      ],
    );
  }

  /// Build a card for an individual dice with editable title and options
  Widget _buildDiceCard(int index) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dado ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: _localDiceList[index].title,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) => _updateDiceTitle(index, value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Opciones:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar'),
                  onPressed: () => _showEditOptionsDialog(index),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  // Existing option chips with delete functionality
                  ..._localDiceList[index].options.asMap().entries.map((entry) {
                    int optionIndex = entry.key;
                    String option = entry.value;
                    return Chip(
                      label: Text(
                        option,
                        style: const TextStyle(fontSize: 12),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: _localDiceList[index].options.length > 1 
                          ? () => _removeOption(index, optionIndex)
                          : null, // Prevent deleting if only one option left
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                  // Add option chip (only show if less than 6 options)
                  if (_localDiceList[index].options.length < 6)
                    ActionChip(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 14),
                          SizedBox(width: 4),
                          Text('Agregar', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      onPressed: () => _showAddOptionDialog(index),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Colors.green[100],
                    ),
                  // Show question mark chips for empty slots
                  ...List.generate(
                    6 - _localDiceList[index].options.length,
                    (emptyIndex) => Chip(
                      label: const Text('?', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      backgroundColor: Colors.grey[200],
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Dados'),
        elevation: 2,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'reset') {
                widget.onResetToDefaults();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dados restaurados a la configuración predeterminada'),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Restaurar Valores Predeterminados'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dice configuration section
                _buildDiceConfigurationSection(),
                const SizedBox(height: 24),
                
                // Dice display section
                _buildDiceDisplaySection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Apply changes and go back
          widget.onConfigurationChanged(_localDiceList, _localNumberOfDice);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Configuración aplicada exitosamente'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.check),
        label: const Text('Aplicar Cambios'),
      ),
    );
  }
}

/// Kamasutra position model
class KamasutraPosition {
  final int id;
  final String name;
  final String image;
  final String description;

  KamasutraPosition({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory KamasutraPosition.fromJson(Map<String, dynamic> json) {
    return KamasutraPosition(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
    );
  }
}

/// Kamasutra dice page with image-based positions
class KamasutraPage extends StatefulWidget {
  const KamasutraPage({super.key});

  @override
  State<KamasutraPage> createState() => _KamasutraPageState();
}

class _KamasutraPageState extends State<KamasutraPage>
    with TickerProviderStateMixin {
  List<KamasutraPosition> _positions = [];
  KamasutraPosition? _currentPosition;
  bool _isLoading = false;
  bool _isRolling = false;
  
  late AnimationController _diceAnimationController;
  late AnimationController _resultAnimationController;
  late Animation<double> _diceRotationAnimation;
  late Animation<double> _diceScaleAnimation;
  late Animation<double> _resultFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadPositions();
  }

  void _initializeAnimations() {
    _diceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _diceRotationAnimation = Tween<double>(
      begin: 0,
      end: 4,
    ).animate(CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.easeInOut,
    ));

    _diceScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.elasticOut,
    ));

    _resultFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultAnimationController,
      curve: Curves.easeIn,
    ));
  }

  Future<void> _loadPositions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load positions from JSON file
      final String jsonString = await rootBundle.loadString('assets/kamasutra/positions.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> positionsJson = jsonData['positions'];
      
      _positions = positionsJson
          .map((json) => KamasutraPosition.fromJson(json))
          .toList();
          
      debugPrint('Loaded ${_positions.length} Kamasutra positions');
    } catch (e) {
      debugPrint('Error loading positions from JSON: $e');
      // Fallback to hardcoded positions if JSON loading fails
      _positions = [
        KamasutraPosition(id: 1, name: "Misionero", image: "missionary.svg", description: "Posición clásica cara a cara"),
        KamasutraPosition(id: 2, name: "Doggy Style", image: "doggy.svg", description: "Posición desde atrás"),
        KamasutraPosition(id: 3, name: "Cowgirl", image: "cowgirl.svg", description: "Ella arriba"),
        KamasutraPosition(id: 4, name: "Reverse Cowgirl", image: "reverse_cowgirl.svg", description: "Ella arriba mirando hacia los pies"),
        KamasutraPosition(id: 5, name: "Spooning", image: "spooning.svg", description: "De lado, ambos en la misma dirección"),
        KamasutraPosition(id: 6, name: "Standing", image: "standing.svg", description: "De pie, ella apoyada"),
      ];
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _rollDice() async {
    if (_positions.isEmpty) return;

    setState(() {
      _isRolling = true;
      _currentPosition = null;
    });

    _diceAnimationController.reset();
    _diceAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 2000));

    final random = Random();
    final selectedPosition = _positions[random.nextInt(_positions.length)];

    setState(() {
      _currentPosition = selectedPosition;
      _isRolling = false;
    });

    _resultAnimationController.reset();
    _resultAnimationController.forward();
  }

  @override
  void dispose() {
    _diceAnimationController.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  Future<bool> _checkImageExists(String imageName) async {
    try {
      await rootBundle.load('assets/kamasutra/$imageName');
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildImagePlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 268,
        height: 268,
        child: SvgPicture.asset(
          'assets/kamasutra/default.svg',
          fit: BoxFit.contain,
          placeholderBuilder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                size: 80,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 8),
              Text(
                'Imagen no disponible',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados Kamasutra'),
        centerTitle: true,
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.favorite,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Dados Kamasutra',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Descubre nuevas posiciones con cada lanzamiento',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Dice area
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _isRolling
                          ? _buildRollingAnimation()
                          : _currentPosition != null
                              ? _buildResult()
                              : _buildInitialState(),
                ),
                
                // Roll button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _isRolling ? null : _rollDice,
                    icon: _isRolling
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.casino),
                    label: Text(_isRolling ? 'Lanzando...' : '¡Lanzar Dado!'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app,
                size: 24,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 2),
              Text(
                '¡Lanza el dado para descubrir\nuna nueva posición!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRollingAnimation() {
    return Center(
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _diceAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _diceScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _diceRotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.shade400,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 18,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 2),
              const Text(
                '¡Descubriendo tu posición!',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preparándote una sorpresa...',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (_currentPosition == null) return const SizedBox();

    return FadeTransition(
      opacity: _resultFadeAnimation,
      child: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Position name
                  Text(
                    _currentPosition!.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Image placeholder (will show actual image if available)
                  Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.red.shade200,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: FutureBuilder(
                        future: _checkImageExists(_currentPosition!.image),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            // Show actual SVG image if it exists
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/kamasutra/${_currentPosition!.image}',
                                fit: BoxFit.contain,
                                placeholderBuilder: (context) => _buildImagePlaceholder(),
                              ),
                            );
                          } else {
                            // Show placeholder
                            return _buildImagePlaceholder();
                          }
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _currentPosition!.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
