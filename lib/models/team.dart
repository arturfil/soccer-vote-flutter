class Team {
  String id;
  String name;
  int votes;

  Team({this.id, this.name, this.votes});

  factory Team.fromMap(Map<String, dynamic> obj) {
    return Team(
        id: obj.containsKey('id') ? obj['id'] : 'no-id',
        name: obj.containsKey('name') ? obj['name'] : 'no-name',
        votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes');
  }
}
