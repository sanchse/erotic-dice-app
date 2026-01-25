import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/dice.dart';
import '../widgets/dice_widget.dart';
import 'configuration_page.dart';

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
  late Animation<double> _resultFadeAnimation;
  
  // Countdown timer functionality
  Timer? _countdownTimer;
  int _countdownSeconds = 0;
  int _detectedSeconds = 0;
  String _detectedTimeText = '';
  bool _showCountdown = false;
  bool _isCountdownActive = false;
  bool _isCountdownPaused = false;
  bool _showCountdownPending = false;
  final TextEditingController _customTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    _diceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _diceRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 4.0,
    ).animate(CurvedAnimation(
      parent: _diceAnimationController,
      curve: Curves.easeInOut,
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
          
          while (_diceList.length < 3) {
            _diceList.add(Dice(
              title: 'Dado ${_diceList.length + 1}',
              options: ['Opción 1', 'Opción 2', 'Opción 3'],
            ));
          }
        });
        
        debugPrint('Configuration loaded successfully');
      } else {
        debugPrint('No saved configuration found, using defaults');
        _initializeDice();
      }
    } catch (e) {
      debugPrint('Error loading configuration: $e');
      _initializeDice();
    }
    
    setState(() {
      _rollResults = null;
      _isLoading = false;
    });
  }

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
      
      final savedValue = prefs.getString('dice_configuration');
      debugPrint('Verification read: $savedValue');
      
    } catch (e) {
      debugPrint('Error saving configuration: $e');
    }
  }

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

  void _resetToDefaults() async {
    setState(() {
      _initializeDice();
    });
    await _saveConfiguration();
  }

  void _rollDice() async {
    setState(() {
      _isRolling = true;
      _rollResults = null;
    });
    
    try {
      await _audioPlayer.play(AssetSource('sounds/dice_roll.mp3'));
    } catch (e) {
      debugPrint('Error playing dice roll sound: $e');
      try {
        await HapticFeedback.mediumImpact();
      } catch (hapticError) {
        debugPrint('Error with haptic feedback: $hapticError');
      }
    }
    
    _diceAnimationController.reset();
    _diceAnimationController.forward();
    
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final results = <String>[];
    for (int i = 0; i < _numberOfDice; i++) {
      results.add(_diceList[i].roll());
    }
    
    setState(() {
      _rollResults = results;
      _isRolling = false;
    });
    
    _checkAndConfigureCountdown(results);
    
    _resultAnimationController.reset();
    _resultAnimationController.forward();
  }

  void _checkAndConfigureCountdown(List<String> results) {
    if (results.length != 3) return;
    
    final timeDiceResult = results[2];
    _parseAndSetCountdown(timeDiceResult);
  }

  void _parseAndSetCountdown(String timeValue) {
    int seconds = 0;
    
    if (timeValue == "?") {
      _showCustomTimeDialog();
      return;
    }
    
    final combinedMatch = RegExp(
      r'(\d+)\s*(?:minuto|min)(?:s)?\s*(?:y)?\s*(\d+)\s*(?:segundo|seg)(?:s)?',
      caseSensitive: false
    ).firstMatch(timeValue);
    
    if (combinedMatch != null) {
      final minutes = int.tryParse(combinedMatch.group(1) ?? '0') ?? 0;
      final secs = int.tryParse(combinedMatch.group(2) ?? '0') ?? 0;
      seconds = (minutes * 60) + secs;
    } else {
      final minMatch = RegExp(r'(\d+)\s*(?:minuto|min)(?:s)?', caseSensitive: false).firstMatch(timeValue);
      if (minMatch != null) {
        final minutes = int.tryParse(minMatch.group(1) ?? '0') ?? 0;
        seconds = minutes * 60;
      } else {
        final secMatch = RegExp(r'(\d+)\s*(?:segundo|seg)(?:s)?', caseSensitive: false).firstMatch(timeValue);
        if (secMatch != null) {
          seconds = int.tryParse(secMatch.group(1) ?? '0') ?? 0;
        } else {
          final number = int.tryParse(timeValue);
          if (number != null && number > 0 && number <= 60) {
            seconds = number * 60;
          }
        }
      }
    }
    
    if (seconds > 0) {
      setState(() {
        _detectedSeconds = seconds;
        _detectedTimeText = timeValue;
        _showCountdownPending = true;
        _showCountdown = false;
      });
    }
  }

  void _startCountdown(int seconds) {
    _stopCountdown();
    
    setState(() {
      _countdownSeconds = seconds;
      _showCountdown = true;
      _isCountdownActive = true;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
      });
      
      if (_countdownSeconds == 3) {
        _playCountdownFinishedSound();
      }
      
      if (_countdownSeconds <= 0) {
        _stopCountdown();
        _showCountdownFinishedDialog();
      }
    });
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    setState(() {
      _isCountdownActive = false;
      _isCountdownPaused = false;
    });
  }

  void _pauseCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    setState(() {
      _isCountdownPaused = true;
    });
  }

  void _resumeCountdown() {
    setState(() {
      _isCountdownPaused = false;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
      });
      
      if (_countdownSeconds == 3) {
        _playCountdownFinishedSound();
      }
      
      if (_countdownSeconds <= 0) {
        _stopCountdown();
        _showCountdownFinishedDialog();
      }
    });
  }

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

  void _showResetConfirmationDialog() async {
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

  void _showDebugDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final savedConfig = prefs.getString('dice_configuration');
    
    if (!mounted) return;
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
                const Text('Configuración guardada:'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    savedConfig ?? 'No hay configuración guardada',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Configuración actual:'),
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
                if (!context.mounted) return;
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

  Widget _buildAnimatedDiceSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < _numberOfDice; i++)
                  DiceWidget(
                    options: _diceList[i].fullOptions,
                    size: 110,
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
                    _buildRollButton(),
                    const SizedBox(height: 24),
                    
                    if (_isRolling) _buildAnimatedDiceSection(),
                    if (_isRolling) const SizedBox(height: 24),
                    
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
        padding: const EdgeInsets.all(16.0),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < _rollResults!.length; i++)
                  Column(
                    children: [
                      DiceWidget(
                        options: _diceList[i].fullOptions,
                        size: 110,
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
            if (_showCountdown) _buildCountdownWidget(),
            if (_showCountdownPending) _buildCountdownPendingWidget(),
          ],
        ),
      ),
    );
  }

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

  Widget _buildCountdownPendingWidget() {
    final minutes = _detectedSeconds ~/ 60;
    final seconds = _detectedSeconds % 60;
    final timeString = minutes > 0 
        ? (seconds > 0 ? '${minutes}m ${seconds}s' : '$minutes min')
        : '$seconds seg';
    
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        elevation: 2,
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: Colors.green,
                    size: 24,
                  ),
                  SizedBox(width: 8),
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
                style: const TextStyle(
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
                    onPressed: () {
                      setState(() {
                        _showCountdownPending = false;
                      });
                      _startCountdown(_detectedSeconds);
                    },
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
}
