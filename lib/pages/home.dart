// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<Band> bands=[
    Band(id: '1', name: 'Led Zeppelin', votes: 10),
    Band(id: '2', name: 'The Doors', votes: 8),
    Band(id: '3', name: 'Bob Dylan', votes: 7),
    Band(id: '4', name: 'Black Sabbath', votes: 5),
    Band(id: '5', name: 'Bad Bunny', votes: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandsNames', style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => bandsTile( bands[i] ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget bandsTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        // print('direction: $direction');
        // print('band: ${band.name}');
        //TODO: llamar el borrado en el server
      },
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
          onTap: () {print(band.name);}, //print(band.name),
        ),
    );
  }

  addNewBand(){

    final textController = TextEditingController();

    if(Platform.isAndroid){
      // Android
      return showDialog(
        context: context, 
        builder: (context){
          return  AlertDialog(
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
          );
        }
      );
    
    }

    showCupertinoDialog(
      context: context,
      builder: ( _ ){
        return CupertinoAlertDialog(
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
        );
      }
    );


  }

  void addBandToList(String name){
    if(name.length > 1){
      //podemos agregar
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);

  }


}