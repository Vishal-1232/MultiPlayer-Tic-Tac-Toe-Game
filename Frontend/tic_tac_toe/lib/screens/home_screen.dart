import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/create_room_screen.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';
import 'package:tic_tac_toe/widgets/responsive.dart';

import 'join_room_screen.dart';
class HomeScreen extends StatelessWidget {
  static String routeName = '/home-screen';
  const HomeScreen({super.key});

  createRoom(BuildContext context){
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }
  joinRoom(BuildContext context){
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(onTap: () => createRoom(context), text: "Create Room"),
            const SizedBox(height: 20,),
            CustomButton(onTap: () => joinRoom(context), text: "Join Room"),
          ],
        ),
      ),
    );
  }
}
