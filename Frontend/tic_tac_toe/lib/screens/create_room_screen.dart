import 'package:flutter/material.dart';
import 'package:tic_tac_toe/resources/socket_methods.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';
import 'package:tic_tac_toe/widgets/custom_text.dart';
import 'package:tic_tac_toe/widgets/custom_textfield.dart';
import 'package:tic_tac_toe/widgets/responsive.dart';
class CreateRoomScreen extends StatefulWidget {
  static String routeName = "/create-room-screen";
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nameController = TextEditingController();
  final _socketMethods = SocketMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketMethods.createRoomSuccessListener(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
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
              ], text: "Create Room", fontSize: 70),
              SizedBox(height: size.height*0.08,),
              CustomTextField(controller: _nameController, hintText: "Enter your Nickname"),
              SizedBox(height: size.height*0.045,),
              CustomButton(onTap: () => _socketMethods.createRoom(_nameController.text), text: "Create")
            ],
          ),
        ),
      ),
    );
  }
}
