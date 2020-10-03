import 'package:band_names/models/team.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> teams = [
    Team(id: '1', name: 'Manchester United', votes: 3),
    Team(id: '2', name: 'Real Madrid', votes: 6),
    Team(id: '3', name: 'Barcelona', votes: 2),
    Team(id: '4', name: 'Bayern Munich', votes: 2),
    Team(id: '5', name: 'Borussia Dortmund', votes: 1)
  ];

  @override
  Widget build(BuildContext context) {
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
      ),
      body: ListView.builder(
        itemCount: teams.length,
        itemBuilder: (BuildContext context, int i) {
          return _bandTile(teams[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewTeam,
      ),
    );
  }

  Widget _bandTile(Team team) {
    return Dismissible(
      key: Key(team.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('direction: $direction');
        print('id: ${team.id}');
      },
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
        onTap: () => print(team.name),
      ),
    );
  }

  addNewTeam() {
    final TextEditingController textController = new TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
        );
      },
    );
  }

  void addTeamToList(String name) {
    print(name);
    if (name.length > 1) {
      this
          .teams
          .add(new Team(id: DateTime.now().toString(), name: name, votes: 0));
    }

    setState(() {});

    Navigator.pop(context);
  }
}
