import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';
import 'package:tic_tac_toe/resources/game_methods.dart';
import 'package:tic_tac_toe/resources/socket_client.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/utils/utils.dart';

class SocketMethods{
  final _socketClient = SocketClient.instance.socket!;
  Socket get socketClient => _socketClient;
  // Emits
  void createRoom(String nickname){
    if(nickname.isNotEmpty){
      _socketClient.emit('createRoom',{
        'nickname':nickname
      });
    }
  }
  void joinRoom(String nickname, String roomId){
    if(nickname.isNotEmpty && roomId.isNotEmpty){
      _socketClient.emit('joinRoom',{
        'nickname':nickname,
        'roomId':roomId
      });
    }
  }

  void tapGrid(int index, String roomId, List<String>displayElements){
    if(displayElements[index]==''){
      _socketClient.emit('tap',{
        'index':index,
        'roomId':roomId
      });
    }
  }

  // Listners
  void createRoomSuccessListener(BuildContext context){
    _socketClient.on('createRoomSuccess', (roomData) {
      Provider.of<RoomDataProvider>(context,listen: false).updateRoomData(roomData);
      print(roomData);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListener(BuildContext context){
    _socketClient.on('joinRoomSuccess', (roomData) {
      Provider.of<RoomDataProvider>(context,listen: false).updateRoomData(roomData);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccuredListener(BuildContext context){
    _socketClient.on('errorOccured', (error){
      showSnackBar(context, error);
    });
  }

  void updatePlayerStateListener(BuildContext context){
    _socketClient.on('updatePlayers', (playersData){
      Provider.of<RoomDataProvider>(context,listen: false).updatePlayer1(playersData[0]);
      Provider.of<RoomDataProvider>(context,listen: false).updatePlayer2(playersData[1]);
    });
  }

  void updateRoomListener(BuildContext context) {
    _socketClient.on('updateRoom', (data){
      Provider.of<RoomDataProvider>(context,listen: false).updateRoomData(data);
    });
  }

  void tappedListener(BuildContext context){
    _socketClient.on('tapped', (data) {
      Provider.of<RoomDataProvider>(context,listen: false).updateDisplayElements(data['index'], data['choice']);
      Provider.of<RoomDataProvider>(context,listen: false).updateRoomData(data['room']);
      // Check Winner
      GameMethods().checkWinner(context, _socketClient);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    _socketClient.on('pointIncrease', (playerData) {
      var roomDataProvider =
      Provider.of<RoomDataProvider>(context, listen: false);
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
        print(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListener(BuildContext context) {
    _socketClient.on('endGame', (playerData) {
      showGameDialog(context, '${playerData['nickname']} won the game!');
      Navigator.popUntil(context, (route) => false);
    });
  }
}