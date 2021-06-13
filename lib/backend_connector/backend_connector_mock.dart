
import 'package:blackbeards_board/error_handling/app_exeption.dart';
import 'package:blackbeards_board/models/blackboard.dart';
import 'abstract_backend_connector.dart';

class BackendConnectorMock implements BackendConnector{

  Function(String) onMessage;

  BackendConnectorMock({Function(String) onMessage,Function(String) onLog}){
    this.onMessage = onMessage;
  }

  List<Blackboard> data = [];

  @override
  Future createBlackboard(Blackboard blackboard) async {
    await Future.delayed(Duration(milliseconds: 2000));
    data.add(blackboard);
    onMessage("Board created successfully");
    onBoardsAddedCallback([blackboard.name]);
  }

  @override
  Future<Blackboard> getBoard(String name) async {

    await Future.delayed(Duration(milliseconds: 2000));

    for(Blackboard blackboard in data){
      if(blackboard.name == name){
        return blackboard;
      }
    }
    throw NotFoundException('There is no board with this name');
  }

  @override
  Future<List<String>> getAllBlackboardNames() async{

    await Future.delayed(Duration(milliseconds: 2000));

    List<String> names = [];

    for(Blackboard blackboard in data){
      names.add(blackboard.name);
    }

    return names;
  }


  @override
  Future updateBlackboard(Blackboard blackboardToUpdate) async {

    await Future.delayed(Duration(milliseconds: 2000));

    String nameToUpdate = blackboardToUpdate.name;

    for(Blackboard blackboard in data){
      if(nameToUpdate == blackboard.name){
        int index = data.indexOf(blackboard);
        data[index] = blackboardToUpdate;

        if(onBoardChangedName == nameToUpdate){
          onBoardChangedCallback(blackboardToUpdate);
        }

        return null;
      }
    }

    throw NotFoundException('There is no board with this name');

  }

  @override
  Future deleteBlackboard(String name) async {

    await Future.delayed(Duration(milliseconds: 2000));

    for(Blackboard blackboard in data){
      if(blackboard.name == name){

        data.remove(blackboard);
        onBoardsRemovedCallback([blackboard.name]);

        return null;
      }
    }

    throw NotFoundException('There is no board with this name');
  }

  @override
  Future deleteAllBlackboards() async{

    await Future.delayed(Duration(milliseconds: 2000));
    List<String> names = [];
    for(Blackboard blackboard in data){
      names.add(blackboard.name);
    }

    onBoardsRemovedCallback(names);

    data = [];
  }



  String onBoardChangedName;
  Function(Blackboard blackboard) onBoardChangedCallback;
  Function(List<String> name) onBoardsAddedCallback;
  Function(List<String> name) onBoardsRemovedCallback;

  @override
  void registerOnBoardChange(String name,Function(Blackboard blackboard) callback){
    onBoardChangedName = name;
    onBoardChangedCallback = callback;
  }

  @override
  void registerOnBoardsAdded(Function(List<String> name) callback){
    onBoardsAddedCallback = callback;
  }

  @override
  void registerOnBoardsRemoved(Function(List<String> name) callback){
    onBoardsRemovedCallback = callback;
  }

  @override
  Future<bool> checkBlackboardLock(String name) {
    // TODO: implement checkBlackboardLock
    throw UnimplementedError();
  }



}

