// lib/screens/match_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../models/user_match.dart';
import '../providers/match_provider.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({Key? key}) : super(key: key);

  @override
  _MatchListScreenState createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initial = isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    setState(() {
      if (isStart) _startDate = date;
      else _endDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MatchProvider>(context);
    List<UserMatch> matches = provider.matches;
    if (_startDate != null) {
      matches = matches.where((m) => !m.dateTime.toLocal().isBefore(_startDate!)).toList();
    }
    if (_endDate != null) {
      matches = matches.where((m) => !m.dateTime.toLocal().isAfter(_endDate!)).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Matches'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(context, true),
                    child: Text(
                      _startDate == null
                          ? 'From'
                          : _startDate!.toLocal().toString().split(' ')[0],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(context, false),
                    child: Text(
                      _endDate == null
                          ? 'To'
                          : _endDate!.toLocal().toString().split(' ')[0],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _startDate = null;
                      _endDate = null;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: matches.isEmpty
                ? const Center(child: Text('No matches found.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final m = matches[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            '${m.homeTeam} vs ${m.awayTeam}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              '${m.dateTime.toLocal().toString().split(" ")[0]} at ${m.stadium}'),
                          onTap: () => context.push('/tasks/edit/${m.id}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              provider.deleteMatch(m.id!);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/create'),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MatchSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            Provider.of<MatchProvider>(context, listen: false)
                .filterMatches(query);
          },
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) {
    Provider.of<MatchProvider>(context, listen: false).filterMatches(query);
    close(context, '');
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Provider.of<MatchProvider>(context, listen: false).filterMatches(query);
    final matches = Provider.of<MatchProvider>(context).matches;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final m = matches[index];
        return ListTile(
          title: Text('${m.homeTeam} vs ${m.awayTeam}'),
          onTap: () {
            close(context, '');
            context.push('/tasks/edit/${m.id}');
          },
        );
      },
    );
  }
}
