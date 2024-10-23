import 'package:flutter/material.dart';
import 'fish.dart';
import 'database_helper.dart';
import 'fish_model.dart';

class AquariumScreen extends StatefulWidget {
  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<FishModel> fishList = [];
  Color selectedColor = Colors.red;
  double selectedSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _loadSettings();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await DatabaseHelper.instance.getSettings();
    setState(() {
      if (settings != null) {
        selectedColor = Color(settings['color']);
        selectedSpeed = settings['speed']?.toDouble() ?? 1.0;
        int fishCount = settings['fishCount'] ?? 0;
        for (int i = 0; i < fishCount; i++) {
          fishList.add(FishModel(color: selectedColor, speed: selectedSpeed));
        }
      }
    });
  }

  Future<void> _saveSettings() async {
    await DatabaseHelper.instance
        .saveSettings(fishList.length, selectedSpeed, selectedColor.value);
  }

  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(FishModel(color: selectedColor, speed: selectedSpeed));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Aquarium'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(),
                color: Colors.lightBlue[50],
              ),
              child: Stack(
                children: fishList
                    .map((fish) => Fish(color: fish.color, speed: fish.speed))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addFish,
                  child: Text('Add Fish'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _saveSettings,
                  child: Text('Save Settings'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Select Speed:'),
            Slider(
              value: selectedSpeed,
              min: 0.5,
              max: 5.0,
              divisions: 9,
              label: selectedSpeed.toString(),
              onChanged: (value) {
                setState(() {
                  selectedSpeed = value;
                });
              },
            ),
            Text('Select Color:'),
            DropdownButton<Color>(
              value: selectedColor,
              items: [
                DropdownMenuItem(value: Colors.red, child: Text('Red')),
                DropdownMenuItem(value: Colors.green, child: Text('Green')),
                DropdownMenuItem(value: Colors.blue, child: Text('Blue')),
                DropdownMenuItem(value: Colors.yellow, child: Text('Yellow')),
              ],
              onChanged: (color) {
                setState(() {
                  selectedColor = color!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
