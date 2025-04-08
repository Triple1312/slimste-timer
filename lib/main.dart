import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smt/PlayerWidget.dart';
import 'package:smt/ShadedTextButton.dart';
import 'package:smt/state/state_bloc.dart';

import 'dart:html' as html;

void main() {
  final StateBloc stateBloc = StateBloc();
  // html.document.documentElement?.requestFullscreen();
  runApp(
    BlocProvider(
        create: (BuildContext context) => stateBloc,
        child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(232, 182, 59, 1)),
        useMaterial3: true,
      ),
      home: Container(
        height: MediaQuery.of(context).size.height,
        // color: Color.fromRGBO(222,32,10, 1),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 183, 21, 19), Color.fromARGB(255, 246, 71, 40)],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          )
        ),
        child: BlocBuilder<StateBloc, StateState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromRGBO(232, 182, 59, 1), Color.fromARGB(255, 183, 21, 19)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                    )
                  ),
                  child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShadedTextButton(onPressed: () => context.read<StateBloc>().add(StateAddPlayer()), text:("Add Player")),
                    const Text("Slimste Timer", style: const TextStyle(fontSize: 32, color: Colors.white, decoration: TextDecoration.none),),
                    IconButton(onPressed: () => context.read<StateBloc>().add(StateReset()), icon: const Icon(Icons.refresh), tooltip: "Reset"),
                  ],
                ),
                ),
                Expanded(
                  child: ListView(
                    children: (() {
                      List<Widget> widgets = [];
                      int split = MediaQuery.of(context).orientation == Orientation.portrait ? 2 :  MediaQuery.of(context).size.width ~/250;
                      for (int i = 0; i <= state.players.length ~/ split; i++) {
                        widgets.add(
                         Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: ((){
                              List<Widget> widgets = [];
                              for (int j = 0; j < split && i * split + j < state.players.length; j++) {
                                widgets.add(
                                  Card(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width / split -8 ,
                                      height: 250,
                                      child: PlayerWidget(player: state.players[i * split + j]),
                                    )
                                  ),
                                );
                              }
                              return widgets;//widgets;
                            })(),
                          )
                        );
                      }
                      return widgets;
                    })(),
                  )



                  // height: MediaQuery.of(context).size.height-100,
                  // child: GridView.count(
                  // crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 :  MediaQuery.of(context).size.width ~/250,
                  // children: state.players.map((player) {
                  //   return Card(
                  //       child: PlayerWidget(player: player),
                  //   );
                  //   }).toList(),
                  // ),
                ),
                // GridView.count(
                //   crossAxisCount: 2,
                //   children: state.players.map((player) {
                //     return Card(child: PlayerWidget(player: player),);
                //   }).toList(),
                // ),
              ]
            );
          }
        )
      )
    );
  }
}

