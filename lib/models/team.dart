class Team {
  String id;
  String name;
  int votes;

  Team({this.id, this.name, this.votes});

  factory Team.fromMap(Map<String, dynamic> obj) {
    return Team(id: obj['id'], name: obj['name'], votes: obj['votes']);
  }
}
