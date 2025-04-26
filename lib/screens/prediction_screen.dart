import 'package:flutter/material.dart';
import '../models/match.dart';

class PredictionScreen extends StatefulWidget {
  final Match match;
  const PredictionScreen({super.key, required this.match});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? userName;
  String? prediction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Match Prediction")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                '${widget.match.team1} vs ${widget.match.team2}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
                onSaved: (val) => userName = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Your Prediction (e.g. 2:1)'),
                validator: (val) => val == null || val.isEmpty ? 'Please enter your prediction' : null,
                onSaved: (val) => prediction = val,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Thank you, $userName! Your prediction: $prediction')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
