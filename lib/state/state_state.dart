part of 'state_bloc.dart';

@immutable
sealed class StateState {
  List<PlayerStats> players = [];
  String? playerCountDown = null;

  void store() {
    html.window.localStorage['smt'] = "${players.map((e) => '{"id": "${e.id}", "name": "${e.name}", "time": ${e.time}}').toList()}";
  }

  StateState(this.players, this.playerCountDown);
}

final class StateInitial extends StateState {
  StateInitial(super.players, super.playerCountDown);

  StateInitial.copy(StateState prev) : super(
    List.from(prev.players),
    prev.playerCountDown,
  );

  StateInitial.empty() : super([], null);

  StateInitial.load(): super([], null) {
    // Load from local storage
    final String? jsonString = html.window.localStorage['smt'];
    if (jsonString != null) {
      List<dynamic> json = jsonDecode(jsonString);
      players = json.map((e) => PlayerStats.json(e)).toList();
    }
  }
}
