// ignore_for_file: avoid_print

import 'dart:io';

import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/models.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<Band> bands=[];

  @override
  void initState() {

    final socketService = Provider.of<SocketService>(context, listen: false);
    
    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }


  void _handleActiveBands(dynamic payload){
    bands = (payload as List).map( (band) => Band.fromMap(band) ).toList();
      setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context);
    socketService.socket.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context).serverStatus;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BandsNames', style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService == ServerStatus.Online)
                   ? Icon(Icons.check_circle, color: Colors.blue[300],)
                   : const Icon(Icons.offline_bolt, color: Colors.red,)
          )
        ],
      ),
      body: Column(
        children: [

          _showGraph(),

          Expanded(child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, i) => bandsTile( bands[i] ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget bandsTile(Band band) {

    final socketService = Provider.of<SocketService>(context);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => socketService.socket.emit('delete-band', {'id': band.id}),
      background: Container(
      color: Colors.lightBlue,
      padding: const EdgeInsets.only(left: 25.0),
      child: const Align(
      alignment: Alignment.centerLeft,
      child: Icon(Icons.delete, color: Colors.white,)),),
      child: ListTile(
          leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0,2)),
          ),
          title: Text(band.name),
          trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20),),
          onTap: () => socketService.socket.emit('vote-band', { 'id': band.id }),
        ),
    );
  }

  addNewBand(){

    final textController = TextEditingController();

    if(Platform.isAndroid){
      // Android
      return showDialog(
        context: context, 
        builder: (_) => AlertDialog(
            title: const Text('New Band Name'),
            content:  TextField(
              
              controller: textController,
            ),
            actions: [
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                child: const Text('Add'),
                onPressed: () => addBandToList(textController.text)
              )
            ],
          )
        
      );
    
    }

    showCupertinoDialog(
      context: context,
      builder: ( _ ) => CupertinoAlertDialog(
          title: const Text('New Band Name'),
          content: CupertinoTextField(controller: textController),
          actions:  [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () => addBandToList(textController.text), 
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Dismiss'),
              onPressed: () => Navigator.pop(context), 
            ),
            
          ],
        )
      
    );


  }

  void addBandToList(String name){
    if(name.length > 1){
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name': name});
      
    }

    Navigator.pop(context);

  }

Widget _showGraph(){


Map<String, double> dataMapSecuryti = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };


Map<String, double> dataMap = {};


  for (var element in bands) {
  //dataMap.putIfAbsent('Flutter', ()=> 5);
    dataMap.putIfAbsent(element.name, ()=> element.votes.toDouble());
  }

  
   

    
    



  return Container(
    margin: const EdgeInsets.only(top: 20),
    width: double.infinity,
    height: 200,
    child: PieChart(
      dataMap: (dataMap.isNotEmpty)?dataMap:dataMapSecuryti,
      chartType: ChartType.ring,
    ),
  ); 


}

}