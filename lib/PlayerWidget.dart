
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smt/PlayerStats.dart';
import 'package:smt/ShadedTextButton.dart';
import 'package:smt/state/state_bloc.dart';

class PlayerWidget extends StatelessWidget {
  final PlayerStats player;
  String name = "";

  PlayerWidget({super.key, required this.player});


  @override
  Widget build(BuildContext context) {
    return(
    SizedBox(
        height: 350,
        child:
      Container(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<StateBloc, StateState>(
          builder: (context, state) {
            // FocusNode focusNode = FocusNode();
            return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded( child: PopupInput(
                        name: player.name,
                        onSubmit: (value) {
                          context.read<StateBloc>().add(StateChangePlayerName(player.id, value));
                        },
                      )
                        // GestureDetector(
                        //   onTap: () => focusNode.requestFocus(),
                        //   child: TextField(
                        //     focusNode: focusNode,
                        //     controller: TextEditingController(text: player.name),
                        //     onSubmitted: (value) {
                        //       context.read<StateBloc>().add(StateChangePlayerName(player.id, value));
                        //       focusNode.unfocus();
                        //     },
                        //     decoration: const InputDecoration(
                        //       labelText: "Player Name",
                        //       border: UnderlineInputBorder(),
                        //     ),
                        //   ),
                        // )
                      ),
                      IconButton(
                          onPressed: () => context.read<StateBloc>().add(StateRemovePlayer(player.id)),
                          icon: const Icon(Icons.delete),
                          tooltip: "Delete Player"
                      ),
                    ],
                  ),
                  Text(
                    player.time.toString(),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Add more player stats here
                  Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        child: ShadedTextButton(
                            onPressed: () => state.playerCountDown != player.id? context.read<StateBloc>().add(StartPlayerCountDown(player.id)) : context.read<StateBloc>().add(StopPlayerCountDown(player.id)),
                            text: state.playerCountDown == player.id ? "Stop" : "Start"
                          ),
                        )
                      ),
                    ]
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: ShadedTextButton(
                            onPressed: () => context.read<StateBloc>().add(StateAddPlayerTime(player.id, 20)),
                            text: "+20",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: ShadedTextButton(
                            onPressed: () => context.read<StateBloc>().add(StateRemovePlayerTime(player.id, 20)),
                            text: "-20"
                          ),
                        ),
                      ),
                    ]
                  ),
                ],
            );
          },
        ),
      )
    )
    );
  }
}


// class InputFix extends StatefulWidget {
//   const InputFix({super.key, required this.onSubmit});
//   final void Function(String) onSubmit;
//
//   @override
//   _InputFixState createState() => _InputFixState();
// }
//
// class _InputFixState extends State<InputFix> {
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//
//   _InputFixState();
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() {
//       if (!_focusNode.hasFocus) {
//         // Attempt to regain focus after losing it
//         Future.delayed(Duration(milliseconds: 50), () {
//           if (!_focusNode.hasFocus) {
//             _focusNode.requestFocus();
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: TextField(
//           controller: _controller,
//           focusNode: _focusNode,
//           onSubmitted: widget.onSubmit,
//           decoration: const InputDecoration(
//             labelText: "Enter Text",
//             border: UnderlineInputBorder(),
//           ),
//         ),
//       ),
//     );
//   }
// }



class PopupInput extends StatefulWidget {
  const PopupInput({super.key, required this.onSubmit, required this.name});
  final void Function(String) onSubmit;
  final String name;

  @override
  _PopupInputState createState() => _PopupInputState();
}

class _PopupInputState extends State<PopupInput> {
  String inputValue = "No input yet";

  void _showInputPopup(BuildContext context) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text("Enter Your Text"),
          content: TextField(
            controller: controller,
            autofocus: true,
            onSubmitted: ((String name){
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
              if (name.isNotEmpty) {
                widget.onSubmit(name);
              }
            }),
            decoration: const InputDecoration(
              labelText: "Your text",
              hintText: "Type something...",
            ),
          ),
          actions: [
            ShadedTextButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              }, text: 'Cancel',
            ),
            ShadedTextButton(
              text:"Submit",
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  widget.onSubmit(controller.text);
                }
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        inputValue = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: widget.name),
      onTap: () => _showInputPopup(context),
      decoration: const InputDecoration(
        labelText: "Change Player Name",
        hintText: "name",
        border: UnderlineInputBorder(),
      ),
    );
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     ElevatedButton(
    //       onPressed: () => _showInputPopup(context),
    //       child: Text("Open Popup Input"),
    //     ),
    //     SizedBox(height: 20),
    //     Text(
    //       "Entered Text: $inputValue",
    //       style: TextStyle(fontSize: 18),
    //     ),
    //   ],
    // );
  }
}