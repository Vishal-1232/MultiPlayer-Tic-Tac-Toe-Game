import 'package:flutter/material.dart';
import 'package:tic_tac_toe/resources/socket_methods.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/responsive.dart';
class JoinRoomScreen extends StatefulWidget {
  static String routeName = "/join-room-screen";
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final _nameController = TextEditingController();
  final _gameIdControoler = TextEditingController();
  final _socketMethods = SocketMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketMethods.joinRoomSuccessListener(context);
    _socketMethods.errorOccuredListener(context);
    _socketMethods.updatePlayerStateListener(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _gameIdControoler.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(shadows: [
                Shadow(
                    color: Colors.blue,
                    blurRadius: 40
                )
              ], text: "Join Room", fontSize: 70),
              SizedBox(height: size.height*0.08,),
              CustomTextField(controller: _nameController, hintText: "Enter your Nickname"),
              SizedBox(height: size.height*0.045,),
              CustomTextField(controller: _gameIdControoler, hintText: "Enter Game ID"),
              SizedBox(height: size.height*0.045,),
              CustomButton(onTap: () => _socketMethods.joinRoom(_nameController.text, _gameIdControoler.text), text: "Join")
            ],
          ),
        ),
      ),
    );
  }
}
