import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:math';

import '../models/kamasutra_position.dart';
import '../l10n/app_localizations.dart';

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

    // Define all positions with localization keys
    _positions = [
      KamasutraPosition(id: 1, name: "Missionary", nameKey: "positionMissionary", descKey: "positionMissionaryDesc", image: "missionary.svg", description: "Classic face-to-face position, he on top"),
      KamasutraPosition(id: 2, name: "Doggy Style", nameKey: "positionDoggy", descKey: "positionDoggyDesc", image: "doggy.svg", description: "Position from behind"),
      KamasutraPosition(id: 3, name: "Cowgirl", nameKey: "positionCowgirl", descKey: "positionCowgirlDesc", image: "cowgirl.svg", description: "She on top"),
      KamasutraPosition(id: 4, name: "Reverse Cowgirl", nameKey: "positionReverseCowgirl", descKey: "positionReverseCowgirlDesc", image: "reverse_cowgirl.svg", description: "She on top facing his feet"),
      KamasutraPosition(id: 5, name: "Stand and Carry", nameKey: "positionStandAndCarry", descKey: "positionStandAndCarryDesc", image: "stand_and_carry.svg", description: "He standing holding her"),
      KamasutraPosition(id: 6, name: "Bodyguard", nameKey: "positionBodyguard", descKey: "positionBodyguardDesc", image: "bodyguard.svg", description: "He behind hugging her"),
      KamasutraPosition(id: 7, name: "69", nameKey: "position69", descKey: "position69Desc", image: "69.svg", description: "Both enjoying orally"),
      KamasutraPosition(id: 8, name: "Kneeling Blow Job", nameKey: "positionKneelingBlowJob", descKey: "positionKneelingBlowJobDesc", image: "kneeling_blow_job.svg", description: "He standing, she kneeling in front performing oral"),
      KamasutraPosition(id: 9, name: "Prone", nameKey: "positionProne", descKey: "positionProneDesc", image: "prone.svg", description: "She face down, he on top"),
      KamasutraPosition(id: 10, name: "Anvil", nameKey: "positionAnvil", descKey: "positionAnvilDesc", image: "anvil.svg", description: "She with legs very elevated, he on top"),
      KamasutraPosition(id: 11, name: "Zeus", nameKey: "positionZeus", descKey: "positionZeusDesc", image: "zeus.svg", description: "She kneeling performing oral while he stands holding her head"),
      KamasutraPosition(id: 12, name: "Hungry", nameKey: "positionHungry", descKey: "positionHungryDesc", image: "hungry.svg", description: "She lying down and he between her legs performing oral"),
      KamasutraPosition(id: 13, name: "Dancer", nameKey: "positionDancer", descKey: "positionDancerDesc", image: "dancer.svg", description: "He standing, she standing facing him with one leg elevated around his waist"),
      KamasutraPosition(id: 14, name: "Side Missionary", nameKey: "positionManMissionary", descKey: "positionManMissionaryDesc", image: "man_missionary.svg", description: "Both lying on their side, he behind her"),
    ];
    
    debugPrint('Loaded ${_positions.length} Kamasutra positions');

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
    final l10n = AppLocalizations.of(context)!;
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
                l10n.imageNotAvailable,
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.kamasutraTitle),
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
                        Text(
                          l10n.kamasutraTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.discoverNewPositions,
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
                    label: Text(_isRolling ? l10n.rolling : l10n.rollDice),
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
    final l10n = AppLocalizations.of(context)!;
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
                l10n.launchDiceToDiscover,
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
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
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
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.red.shade400,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 40,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                l10n.discoveringPosition,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.preparingSurprise,
                style: TextStyle(
                  fontSize: 14,
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

    final l10n = AppLocalizations.of(context)!;
    
    // Get localized name and description
    String localizedName = _currentPosition!.name;
    String localizedDesc = _currentPosition!.description;
    
    // Use localization keys if available
    if (_currentPosition!.nameKey != null) {
      localizedName = _getLocalizedString(l10n, _currentPosition!.nameKey!) ?? _currentPosition!.name;
    }
    if (_currentPosition!.descKey != null) {
      localizedDesc = _getLocalizedString(l10n, _currentPosition!.descKey!) ?? _currentPosition!.description;
    }

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
                    localizedName,
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
                      localizedDesc,
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

  // Helper method to get localized string by key
  String? _getLocalizedString(AppLocalizations l10n, String key) {
    switch (key) {
      case 'positionMissionary': return l10n.positionMissionary;
      case 'positionMissionaryDesc': return l10n.positionMissionaryDesc;
      case 'positionDoggy': return l10n.positionDoggy;
      case 'positionDoggyDesc': return l10n.positionDoggyDesc;
      case 'positionCowgirl': return l10n.positionCowgirl;
      case 'positionCowgirlDesc': return l10n.positionCowgirlDesc;
      case 'positionReverseCowgirl': return l10n.positionReverseCowgirl;
      case 'positionReverseCowgirlDesc': return l10n.positionReverseCowgirlDesc;
      case 'positionStandAndCarry': return l10n.positionStandAndCarry;
      case 'positionStandAndCarryDesc': return l10n.positionStandAndCarryDesc;
      case 'positionBodyguard': return l10n.positionBodyguard;
      case 'positionBodyguardDesc': return l10n.positionBodyguardDesc;
      case 'position69': return l10n.position69;
      case 'position69Desc': return l10n.position69Desc;
      case 'positionKneelingBlowJob': return l10n.positionKneelingBlowJob;
      case 'positionKneelingBlowJobDesc': return l10n.positionKneelingBlowJobDesc;
      case 'positionProne': return l10n.positionProne;
      case 'positionProneDesc': return l10n.positionProneDesc;
      case 'positionAnvil': return l10n.positionAnvil;
      case 'positionAnvilDesc': return l10n.positionAnvilDesc;
      case 'positionZeus': return l10n.positionZeus;
      case 'positionZeusDesc': return l10n.positionZeusDesc;
      case 'positionHungry': return l10n.positionHungry;
      case 'positionHungryDesc': return l10n.positionHungryDesc;
      case 'positionDancer': return l10n.positionDancer;
      case 'positionDancerDesc': return l10n.positionDancerDesc;
      case 'positionManMissionary': return l10n.positionManMissionary;
      case 'positionManMissionaryDesc': return l10n.positionManMissionaryDesc;
      default: return null;
    }
  }
}
