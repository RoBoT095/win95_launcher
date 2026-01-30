import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';

import 'package:win95_launcher/components/tile_item_95.dart';

class TileCounter extends StatefulWidget {
  final double initialValue;
  final double minValue;
  final double maxValue;
  final Function(double value) onSave;

  const TileCounter({
    super.key,
    this.initialValue = 50,
    this.minValue = 0,
    this.maxValue = 100,
    required this.onSave,
  });

  @override
  State<TileCounter> createState() => _TileCounter();
}

class _TileCounter extends State<TileCounter> {
  late double _currentValue;

  @override
  void initState() {
    _currentValue = widget.initialValue;
    super.initState();
  }

  void _increment() {
    if (_currentValue < widget.maxValue) {
      setState(() {
        _currentValue++;
      });
    }
  }

  void _decrement() {
    if (_currentValue > widget.minValue) {
      setState(() {
        _currentValue--;
      });
    }
  }

  void _handleSave() {
    widget.onSave(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Elevation95(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: _increment, icon: Icon(Icons.add)),
            Container(
              constraints: const BoxConstraints(minWidth: 60),
              child: Text(
                _currentValue.toInt().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(onPressed: _decrement, icon: Icon(Icons.remove)),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: tileItem95(
                label: 'Save',
                onTap: (context) => _handleSave(),
              ),
            ),
            // TextButton(onPressed: _handleSave, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
