import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const EroticDiceApp());
}

/// Main application widget
class EroticDiceApp extends StatelessWidget {
  const EroticDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Erotic Dice',
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

class _DiceRollerPageState extends State<DiceRollerPage> {
  // Number of dice to display (1-3)
  int _numberOfDice = 3;
  
  // List of dice with their titles and options
  late List<Dice> _diceList;
  
  // Results from the last roll
  List<String>? _rollResults;

  @override
  void initState() {
    super.initState();
    _initializeDice();
  }

  /// Initialize dice with default configurations
  void _initializeDice() {
    _diceList = [
      Dice(
        title: 'Actions',
        options: ['Kiss', 'Lick', 'Massage'],
      ),
      Dice(
        title: 'Body Area',
        options: ['Neck', 'Back', 'Hand'],
      ),
      Dice(
        title: 'Time',
        options: ['5 seconds', '10 seconds', '30 seconds'],
      ),
    ];
    _rollResults = null;
  }

  /// Roll all active dice and update results
  void _rollDice() {
    setState(() {
      _rollResults = [];
      for (int i = 0; i < _numberOfDice; i++) {
        _rollResults!.add(_diceList[i].roll());
      }
    });
  }

  /// Update the title of a specific dice
  void _updateDiceTitle(int index, String newTitle) {
    setState(() {
      _diceList[index].title = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erotic Dice'),
        elevation: 2,
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
                
                // Roll button
                _buildRollButton(),
                const SizedBox(height: 32),
                
                // Results display
                if (_rollResults != null) _buildResultsDisplay(),
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
              'Number of Dice',
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
          'Dice Configuration',
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

  /// Build a card for an individual dice with editable title
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
                  'Dice ${index + 1}',
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
                      labelText: 'Title',
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
            const SizedBox(height: 8),
            Text(
              'Options: ${_diceList[index].options.join(', ')}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
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
      onPressed: _rollDice,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.casino, size: 28),
          SizedBox(width: 12),
          Text(
            'Roll Dice',
            style: TextStyle(
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
                  'Result',
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
