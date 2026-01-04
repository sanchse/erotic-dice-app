import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
      home: const DiceRollerPage(),
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
    return options[_random.nextInt(options.length)];
  }
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
  
  // Animation state and controllers
  bool _isRolling = false;
  late AnimationController _diceAnimationController;
  late AnimationController _resultAnimationController;
  late Animation<double> _diceRotationAnimation;
  late Animation<double> _diceScaleAnimation;
  late Animation<double> _resultFadeAnimation;

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
        title: 'Acciones',
        options: ['Besar', 'Lamer', 'Masajear', 'Tocar', 'Acariciar', 'Mordisquear'],
      ),
      Dice(
        title: 'Parte del Cuerpo',
        options: ['Cuello', 'Espalda', 'Genitales', 'Pezones', 'Culo', 'Labios'],
      ),
      Dice(
        title: 'Tiempo',
        options: ['5 segundos', '10 segundos', '30 segundos', '1 minuto', '2 minutos'],
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
    
    // Animate results appearance
    _resultAnimationController.reset();
    _resultAnimationController.forward();
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
                        '${_diceList[i].options.length} opciones: ${_diceList[i].options.take(3).join(", ")}${_diceList[i].options.length > 3 ? "..." : ""}',
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

  /// Build animated dice section during rolling
  Widget _buildAnimatedDiceSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              '¡Lanzando dados!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < _numberOfDice; i++)
                  AnimatedBuilder(
                    animation: _diceAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _diceScaleAnimation.value,
                        child: Transform.rotate(
                          angle: _diceRotationAnimation.value * 2 * 3.14159,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.pink.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.pink,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.casino,
                              size: 32,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              backgroundColor: Colors.pink.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
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
                    // Dice summary card
                    _buildDiceSummaryCard(),
                    const SizedBox(height: 24),
                    
                    // Animated dice section
                    if (_isRolling) _buildAnimatedDiceSection(),
                    if (_isRolling) const SizedBox(height: 24),
                    
                    // Roll button
                    _buildRollButton(),
                    const SizedBox(height: 32),
                    
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

  /// Build the results display section
  Widget _buildResultsDisplay() {
    return Card(
      elevation: 4,
      color: Colors.pink[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Resultado',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < _rollResults!.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _diceList[i].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.arrow_forward, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _rollResults![i],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
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
        .take(20)
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
    controller.text = _localDiceList[index].options.join('\\n');

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
                  'Ingresa cada opción en una nueva línea:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Opción 1\\nOpción 2\\nOpción 3',
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
                    .split('\\n')
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
                children: _localDiceList[index].options.map((option) {
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
