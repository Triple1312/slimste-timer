import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smt/PlayerStats.dart';
import 'package:uuid/uuid.dart';
import 'dart:html' as html;
import 'dart:convert';

part 'state_event.dart';
part 'state_state.dart';

class StateBloc extends Bloc<StateEvent, StateState> {
  Timer? timer;

  StateBloc() : super(StateInitial.load()) {
    on<StateAddPlayer>((event, emit) {
      state.players.add(PlayerStats(const Uuid().v4(), "Player ${state.players.length + 1}", 60));
      emit(StateInitial.copy(state));
    });

    on<StateRemovePlayer>((event, emit) {
      state.players.removeWhere((player) => player.id == event.playerId);
      emit(StateInitial.copy(state));
    });

    on<StateChangePlayerName>((event, emit) {
      final player = state.players.firstWhere((player) => player.id == event.playerId);
      player.name = event.name;
      emit(StateInitial.copy(state));
    });

    on<StateAddPlayerTime>((event, emit) {
      final player = state.players.firstWhere((player) => player.id == event.playerId);
      player.time += event.time;
      emit(StateInitial.copy(state));
    });

    on<StateRemovePlayerTime>((event, emit) {
      final player = state.players.firstWhere((player) => player.id == event.playerId);
      player.time -= event.time;
      if (player.time < 0) {
        player.time = 0;
        timer?.cancel();
      }
      emit(StateInitial.copy(state));
    });

    on<StateDecrementPlayerTime>((event, emit) {
      final player = state.players.firstWhere((player) => player.id == event.playerId);
      player.time--;
      if (player.time < 0) {
        player.time = 0;
        timer?.cancel();
      }
      emit(StateInitial.copy(state));
    });

    on<StartPlayerCountDown>((event, emit) {
      timer?.cancel();
      state.playerCountDown = event.playerId;
      emit(StateInitial.copy(state));
      this.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(StateDecrementPlayerTime(event.playerId)); // same as state.playerCountDown
      });
    });

    on<StopPlayerCountDown>((event, emit) {
      if (state.playerCountDown == event.playerId) {
        state.playerCountDown = null;
      }
      else {
        throw Exception("Player not in countdown");
      }
      emit(StateInitial.copy(state));
      timer?.cancel();
      timer = null;
    });

    on<StateReset>((event, emit) {
      state.players.clear();
      state.playerCountDown = null;
      emit(StateInitial.copy(state));
      timer?.cancel();
      timer = null;
    });

  }

  @override
  void emit(StateState state) {
    print("emit");
    super.emit(state);
    state.store();
  }
}
