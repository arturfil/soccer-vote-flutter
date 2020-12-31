import 'dart:io';

import 'package:band_names/models/team.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> teams = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-teams', _handleActiveTeams);
    super.initState();
  }

  _handleActiveTeams(dynamic payload) {
    this.teams = (payload as List).map((team) => Team.fromMap(team)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Futbol Teams",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red[300]),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (BuildContext context, int i) {
                return _teamTile(teams[i]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewTeam,
      ),
    );
  }

  Widget _teamTile(Team team) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(team.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-team', {'id': team.id}),
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete Band',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(team.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(team.name),
        trailing: Text(
          '${team.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () => socketService.emit('vote-team', {'id': team.id}),
      ),
    );
  }

  addNewTeam() {
    final TextEditingController textController = new TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('New Team to add:'),
        content: TextField(
          controller: textController,
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text('Add'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () {
              addTeamToList(textController.text);
            },
          )
        ],
      ),
    );
  }

  void addTeamToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-team', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();

    teams.forEach((team) {
      dataMap.putIfAbsent(team.name, () => team.votes.toDouble());
    });

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        chartType: ChartType.ring,
      ),
    );
  }
}
