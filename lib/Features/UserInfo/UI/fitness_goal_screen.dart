import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Goals',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const FitnessGoalScreen(),
    );
  }
}

class FitnessGoalScreen extends StatefulWidget {
  const FitnessGoalScreen({super.key});

  @override
  FitnessGoalScreenState createState() => FitnessGoalScreenState();
}

class FitnessGoalScreenState extends State<FitnessGoalScreen> {
  String? _selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What\'s Your Goal?'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'This helps us create your personalized plan',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Goal options
            _buildGoalOption('Get Fitter'),
            _buildGoalOption('Gain Weight'),
            _buildGoalOption('Lose Weight'),
            _buildGoalOption('Building Muscles'),
            _buildGoalOption('Improving Endurance'),
            _buildGoalOption('Learn the Basics'),
            const Spacer(),
            // Next Button
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalOption(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoal = title; // Update selected goal on tap
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedGoal == title ? Colors.purple : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Checkbox(
              value: _selectedGoal == title,
              onChanged: (bool? value) {
                setState(() {
                  _selectedGoal = value! ? title : null;
                });
              },
              activeColor: Colors.purple,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  color: _selectedGoal == title ? Colors.purple : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedGoal == null
            ? null
            : () {
                // Add action here
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded edges
          ),
          textStyle: const TextStyle(fontSize: 20.0),
        ),
        child: const Text('Next'),
      ),
    );
  }
}
