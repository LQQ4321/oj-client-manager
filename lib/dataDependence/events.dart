import 'package:dio/dio.dart';
import 'package:platform/platform.dart';

var dio = Dio();

ConfigModel myConfigInfo = ConfigModel();

class ConfigModel {
  late String netPath;
  late String hostUserName = 'QQ123456';
  late String downloadFilePath = 'C:\\Users\\QQ123456\\Downloads\\';
  void setPath(String path) {
    netPath = 'http://$path';
  }

  String getPath() {
    return 'http://175.178.57.154:5051';
    return netPath;
  }

  void setHostUserName() {
    Platform platform = LocalPlatform();
    if (platform.isWindows) {
      hostUserName = platform.environment['USERNAME']!;
      downloadFilePath = 'C:\\Users\\$hostUserName\\Downloads\\';
    }
  }

  String getHostUserName(){
    return hostUserName;
  }
}

var MyBus = MyEventBus();

//subscriber callback signature
typedef void MyEventCallback(arg);

class MyEventBus {
  //private constructors
  MyEventBus._internal();
  //saving singletons
  static MyEventBus _singleton = MyEventBus._internal();
  //factory constructors
  factory MyEventBus() => _singleton;
  //save the event subscriber queue,key:eventName,value:subscriber queue for the corresponding event
  final _emap = Map<Object, List<MyEventCallback>?>();
  //add a subscriber
  void on(eventName, MyEventCallback f) {
    _emap[eventName] ??= <MyEventCallback>[];
    _emap[eventName]!.add(f);
  }

  //delete subscriber
  void off(eventName, [MyEventCallback? f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  //emit event
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}
