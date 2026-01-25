import 'package:flutter/material.dart';

import '../models/dice.dart';

/// Configuration page for editing dice settings
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
                  for (var entry in _localDiceList[index].options.asMap().entries)
                    Chip(
                      label: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 12),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: _localDiceList[index].options.length > 1 
                          ? () => _removeOption(index, entry.key)
                          : null,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
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
