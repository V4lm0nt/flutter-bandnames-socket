// ignore_for_file: avoid_print, constant_identifier_names, unused_field, library_prefixes, prefer_final_fields

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


enum ServerStatus{
  Online,
  Offline,
  Connecting

}

class SocketService with ChangeNotifier{


  ServerStatus _serverStatus = ServerStatus.Connecting;

  late IO.Socket _socket; 

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;  

  SocketService(){
  
    _initConfig();

  }

  void _initConfig(){
  
    _socket = IO.io('http://10.0.2.2:3000/',{
    
      'transports':['websocket'],
      'autoConnect': true

    });
    
    
    
    
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect( (_){
    _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //_socket.on('nuevo-mensaje', ( payload ){
    //  print( 'nuevo-mensaje: $payload' );
    //  print( "nombre: ${payload['nombre']}" );
    //  print( "ocupacion: ${payload['ocupacion']}" );
    //  print(payload.containsKey('mensaje') ? "mensaje: ${payload['mensaje']}" : 'mensaje: no hay' );
    //});

    

  }



}