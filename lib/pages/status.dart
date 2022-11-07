import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';


class StatusPage extends StatelessWidget {
  const StatusPage({super.key});


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);


    return Scaffold(
      body: Center(
        //child: (socketService.serverStatus == ServerStatus.Online)
        //        ? const FlutterLogo()
        //        : const Text('hola')
        child: Text('ServerStatus: ${socketService.serverStatus}'),
     ),
     floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.message),
      onPressed: (){
        //EMITIR MENSAJE
        // MENSAJE : {nombre: 'flutter' , mensaje: 'hola desde flutter'}
          Map<String,String> mensaje = {
          'nombre'  : 'Flutter', 
          'mensaje' : 'Hola desde Flutter'
          };
          //  Map<String,String> mensaje2 = {
          //  'nombre'  : 'Ivanita', 
          //  'mensaje' : 'Hola desde UX/UI'
          //  };
          //  Map<String,String> mensaje3 = {
          //  'nombre'  : 'Franco', 
          //  'mensaje' : 'Hola desde Programador'
          //  };
          
          //enviar el mensaje
          socketService.socket.emit('emitir-mensaje',  mensaje);
          //  socketService.socket.emit('emitir-mensaje',  mensaje2);
          //  socketService.socket.emit('emitir-mensaje',  mensaje3);

          //  print('mensaje enviado');

        

      }
     ),
   );
  }
}