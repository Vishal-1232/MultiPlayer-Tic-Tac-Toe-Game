require('dotenv').config();
const express = require('express');
const { default: mongoose } = require('mongoose');
const { createServer } = require('node:http');
const { Server } = require('socket.io');

const app = express();
const server = createServer(app);
const Room = require('./models/room');
const { Console } = require('node:console');
const io = new Server(server);
const DB ="mongodb+srv://kaushikvishal479:GTQwSLSc6ytcI72L@cluster0.d3ynypg.mongodb.net/";

app.use(express.json());

app.get('/', (req, res) => {
  res.send('<h1>Hello world</h1>');
});

io.on('connection', (socket) => {
    console.log(`a user connected with socketId ${socket.id}`);

    socket.on('disconnect', () => {
        console.log('user disconnected');
      });

    socket.on("createRoom",async({nickname})=>{
      try{
        console.log(`create Room By: ${nickname}`);
        // Create Room
        let room = new Room();
        // Player is stored in Room
        let player = {
          socketID: socket.id,
          nickname,
          playerType:'X',
        }
        room.players.push(player);
        room.turn = player;
        room = await room.save();
        const roomId = room._id.toString();
        socket.join(roomId);
        // tell client room has been created, goto next page
        io.to(roomId).emit("createRoomSuccess",room);
      }catch (e){
          console.log(e);
      }
      
    });

    socket.on("joinRoom",async ({nickname,roomId})=>{
        try{
            if(!roomId.match( /^[0-9a-fA-F]{24}$/)){
              socket.emit('errorOccured','Please Enter a Valid room Id');
              return;
            }

            let room = await Room.findById(roomId);
            if(room.isJoin==false){
              socket.emit('errorOccured','The Game Is in Progress!!');
              return;
            }

            let player = {
              nickname,
              socketID:socket.id,
              playerType:'O'
            };
            socket.join(roomId);
            room.players.push(player);
            room.isJoin = false;
            room = await room.save();

            io.to(roomId).emit('joinRoomSuccess',room);
            io.to(roomId).emit('updatePlayers',room.players);
            io.to(roomId).emit('updateRoom',room);

        }catch (e){
          console.log(e);
        }
    });

    socket.on('tap',async ({index,roomId})=>{
        try{
            let room = await Room.findById(roomId);
            let choice = room.turn.playerType;

            if(room.turnIndex==0){
              room.turnIndex = 1;
              room.turn = room.players[1];
            }else{
              room.turnIndex = 0;
              room.turn = room.players[0];
            }

            room = await room.save();
            io.to(roomId).emit('tapped',{
              index,
              choice,
              room
            });

        } catch (e){
          console.log(e);
        }
    });

    socket.on('winner',async ({winnerSocketId, roomId})=>{
      try{
        let room = await Room.findById(roomId);
        
        let player = room.players.find(
          (playerr) => playerr.socketID == winnerSocketId
        );
        
        player.points += 1;
        room = await room.save();
        console.log(room);

        if(player.points >= room.maxRounds){
          io.to(roomId).emit('endGame',player);
        }else{
          io.to(roomId).emit('pointIncrease',player);
        }

      }catch (e){
        console.log(e);
      }
    });

  });

server.listen(3000,"0.0.0.0", () => {
  console.log('server running at http://localhost:3000');
});


mongoose.connect(DB).then(()=>{
    console.log("Connection Successful To DB!");
}).catch((e)=>{
    console.log(e);
})
