import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../models/kamasutra_position.dart';

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
