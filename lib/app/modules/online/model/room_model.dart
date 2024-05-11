class Room {
  String id;
  String name;
  List<Object?> players;
  Game game;

  Room(this.id, this.name, this.players, this.game);

  static Room fromJson(Map value) {
    return Room(
      value['id'],
      value['name'],
      value['players'],
      Game.fromJson(value['game']),
    );
  }
}

class Game {
  // {game: {currentTurn: O, winner: nill, nextTurn: X, draw: false, id: xVZltOfUfgeIzKlmW09MXzxxIc43, gameOver: false, board: [, , , , , , , , ]}, players: [xVZltOfUfgeIzKlmW09MXzxxIc43], name: My Room, id: xVZltOfUfgeIzKlmW09MXzxxIc43}
  String nextTurn;
  String currentTurn;
  String winner;
  bool draw = false;
  bool gameOver = false;
  List<Object?> board = ['', '', '', '', '', '', '', '', ''];

  Game(this.nextTurn, this.currentTurn, this.winner, this.draw, this.board,
      this.gameOver);

  static Game fromJson(Map value) {
    return Game(
      value['nextTurn'],
      value['currentTurn'],
      value['winner'],
      value['draw'],
      value['board'] as List<Object?>,
      value['gameOver'],
    );
  }
}
