part of 'state_bloc.dart';

sealed class StateEvent {}

final class StateAddPlayer extends StateEvent {}

final class StateRemovePlayer extends StateEvent {
  final String playerId;

  StateRemovePlayer(this.playerId);
}

final class StateChangePlayerName extends StateEvent {
  final String playerId;
  final String name;

  StateChangePlayerName(this.playerId, this.name);
}

final class StateAddPlayerTime extends StateEvent {
  final String playerId;
  final int time;

  StateAddPlayerTime(this.playerId, this.time);
}

final class StateRemovePlayerTime extends StateEvent {
  final String playerId;
  final int time;

  StateRemovePlayerTime(this.playerId, this.time);
}

final class StateDecrementPlayerTime extends StateEvent {
  final String playerId;

  StateDecrementPlayerTime(this.playerId);
}

final class StartPlayerCountDown extends StateEvent {
  final String playerId;

  StartPlayerCountDown(this.playerId);
}

final class StopPlayerCountDown extends StateEvent {
  final String playerId;

  StopPlayerCountDown(this.playerId);
}

final class StateReset extends StateEvent {}
