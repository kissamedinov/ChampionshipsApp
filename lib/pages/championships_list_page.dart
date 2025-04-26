import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/upcoming_matches_widget.dart';

class ChampionshipsListPage extends StatelessWidget {
  final List<Map<String, String>> championships = [
    {'title': 'Kazakhstan Premier League', 'code': '152', 'stadium': 'https://www.footballgroundmap.com/data/articles/largest-football-stadiums-in-europe.jpg'},
    {'title': 'English Premier League', 'code': '39', 'stadium': 'https://www.footballgroundmap.com/data/headers/Juventus%20header%201.jpg'},
    {'title': 'La Liga', 'code': '140', 'stadium': 'https://www.footballgroundmap.com/data/headers/Portugal%20Luz.jpg'},
    {'title': 'Serie A', 'code': '135', 'stadium': 'https://www.footballgroundmap.com/data/headers/Germany%20Westfalen.jpg'},
    {'title': 'Bundesliga', 'code': '78', 'stadium': 'https://www.footballgroundmap.com/data/headers/Germany%20Allianz%20Arena.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(height: 200, autoPlay: true),
            items: championships.map((champ) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(champ['stadium']!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: championships.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            championships[index]['title']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChampionshipDetailPage(
                                  title: championships[index]['title']!,
                                  leagueCode: championships[index]['code']!,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // 🔥 Добавлено без удаления — блок с матчами
                  UpcomingMatchesWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChampionshipDetailPage extends StatefulWidget {
  final String title;
  final String leagueCode;

  ChampionshipDetailPage({required this.title, required this.leagueCode});

  @override
  _ChampionshipDetailPageState createState() => _ChampionshipDetailPageState();
}

class _ChampionshipDetailPageState extends State<ChampionshipDetailPage> {
  int selectedSeasonIndex = 0;
  final List<String> seasons = ['2020', '2021', '2022', '2023', '2024'];
  late Future<List<Map<String, String>>> standings;

  @override
  void initState() {
    super.initState();
    standings = fetchStandings(seasons[selectedSeasonIndex]);
  }

  Future<List<Map<String, String>>> fetchStandings(String season) async {
    final url = Uri.parse('https://v3.football.api-sports.io/standings?league=${widget.leagueCode}&season=$season');
    final response = await http.get(url, headers: {'x-apisports-key': '649d13dd2a3635bd2090c740187ba01a'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['response'].isEmpty) return [];

      List<Map<String, String>> table = [];
      for (var team in data['response'][0]['league']['standings'][0]) {
        table.add({
          'position': team['rank'].toString(),
          'team': team['team']['name'],
          'played': team['all']['played'].toString(),
          'won': team['all']['win'].toString(),
          'draw': team['all']['draw'].toString(),
          'lost': team['all']['lose'].toString(),
          'goals_for': team['all']['goals']['for'].toString(),
          'goals_against': team['all']['goals']['against'].toString(),
          'goal_diff': (team['all']['goals']['for'] - team['all']['goals']['against']).toString(),
          'points': team['points'].toString(),
        });
      }
      return table;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: seasons.map((season) {
              int index = seasons.indexOf(season);
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedSeasonIndex = index;
                      standings = fetchStandings(seasons[selectedSeasonIndex]);
                    });
                  },
                  child: Text(season),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: index == selectedSeasonIndex ? Colors.blue : Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: standings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error loading data"));
                } else if (snapshot.data!.isEmpty) {
                  return Center(child: Text("No standings available"));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Team')),
                      DataColumn(label: Text('P')),
                      DataColumn(label: Text('W')),
                      DataColumn(label: Text('D')),
                      DataColumn(label: Text('L')),
                      DataColumn(label: Text('GF')),
                      DataColumn(label: Text('GA')),
                      DataColumn(label: Text('GD')),
                      DataColumn(label: Text('Pts')),
                    ],
                    rows: snapshot.data!.map((team) {
                      return DataRow(cells: [
                        DataCell(Text(team['position']!)),
                        DataCell(Text(team['team']!)),
                        DataCell(Text(team['played']!)),
                        DataCell(Text(team['won']!)),
                        DataCell(Text(team['draw']!)),
                        DataCell(Text(team['lost']!)),
                        DataCell(Text(team['goals_for']!)),
                        DataCell(Text(team['goals_against']!)),
                        DataCell(Text(team['goal_diff']!)),
                        DataCell(Text(team['points']!, style: TextStyle(fontWeight: FontWeight.bold))),
                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
