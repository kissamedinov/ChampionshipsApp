import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';               // ← Добавили

import '../models/user_match.dart';
import '../providers/match_provider.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({Key? key}) : super(key: key);

  @override
  _CreateMatchScreenState createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _homeController = TextEditingController();
  final _awayController = TextEditingController();
  final _stadiumController = TextEditingController();
  DateTime _pickedDate = DateTime.now();

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    _stadiumController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _pickedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_pickedDate),
    );
    if (time == null) return;
    setState(() {
      _pickedDate = DateTime(
        date.year, date.month, date.day, time.hour, time.minute
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Match')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _homeController,
                decoration: const InputDecoration(labelText: 'Home Team'),
                validator: (v) => v!.isEmpty ? 'Enter home team' : null,
              ),
              TextFormField(
                controller: _awayController,
                decoration: const InputDecoration(labelText: 'Away Team'),
                validator: (v) => v!.isEmpty ? 'Enter away team' : null,
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _pickDateTime,
                child: Text('Pick Date & Time: ${_pickedDate.toLocal()}'),
              ),
              TextFormField(
                controller: _stadiumController,
                decoration: const InputDecoration(labelText: 'Stadium'),
                validator: (v) => v!.isEmpty ? 'Enter stadium' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final match = UserMatch(
                      homeTeam: _homeController.text,
                      awayTeam: _awayController.text,
                      dateTime: _pickedDate,
                      stadium: _stadiumController.text,
                    );
                    Provider.of<MatchProvider>(context, listen: false)
                        .addMatch(match);
                    context.pop();  // теперь работает
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
