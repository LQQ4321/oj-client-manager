import 'package:flutter/material.dart';
import 'package:manager/dataDependence/dataOne.dart';
import 'package:manager/dataDependence/events.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class problem {
  late String problemName;
  late String createTime;
  late String problemDescription;
  late String ioFiles;
  late String time;
  late String memory;
  late String maxSubmitFile;

  problem({
    required this.problemName,
    required this.createTime,
    required this.problemDescription,
    required this.ioFiles,
    required this.time,
    required this.memory,
    required this.maxSubmitFile,
  });
  factory problem.fromList(List<dynamic> list) {
    return problem(
        problemName: list[0],
        createTime: list[1],
        problemDescription: list[2],
        ioFiles: list[3],
        time: list[4],
        memory: list[5],
        maxSubmitFile: list[6]);
  }
}

ContestModel myContestModel = ContestModel(
    problems: List.generate(0, (index) {
  return problem(
      problemName: '两数之和',
      createTime: '2023-8-3 15:22',
      problemDescription: "null",
      ioFiles: "null",
      time: "1000",
      memory: "128",
      maxSubmitFile: "10");
}));

class ContestModel extends ChangeNotifier {
  late List<problem> problems;
  int buttonId = 1;
  bool giveProblemsData = false;
  ContestModel({required this.problems});
  void switchButtonId(int id) {
    if (buttonId != id) {
      buttonId = id;
      notifyListeners();
    }
  }

  void fromList(List<dynamic> list) {
    problems = List.generate(list.length, (index) {
      return problem.fromList(list[index]);
    });
  }

//  =================local up==================database down=====================
//请求所有的题目基本信息
  Future<bool> createANewProblem(String problemName) async {
    DateTime now = DateTime.now();
    String createTime = now.year.toString() +
        '-' +
        now.month.toString() +
        '-' +
        now.day.toString() +
        ' ' +
        now.hour.toString() +
        ':' +
        now.minute.toString();
    Map request = {
      "requestType": "createANewProblem",
      "info": [
        myBodyModel.contests[myBodyModel.curContestId].contestName,
        problemName,
        createTime
      ]
    };
    bool flag = await dio
        .post("${myConfigInfo.getPath()}/managerJson", data: request)
        .then((value) => value.data['status'] == 'succeed');
    if (flag) {
      problems.insert(
          0,
          problem(
              problemName: problemName,
              createTime: createTime,
              problemDescription: "null",
              ioFiles: "null",
              time: "1000",
              memory: "256",
              maxSubmitFile: "10"));
      notifyListeners();
    }
    return flag;
  }

  Future<bool> deleteProblem(int id) async {
    Map request = {
      'requestType': 'deleteAProblem',
      'info': [
        myBodyModel.contests[myBodyModel.curContestId].contestName,
        problems[id].problemName,
      ]
    };
    bool flag = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: request)
        .then((value) {
      return value.data['status'] == 'succeed';
    });
    if (flag) {
      problems.removeAt(id);
      notifyListeners();
    }
    return flag;
  }

  Future<bool> addUser(List<String> newUser) async {
    Map request = {
      'requestType': 'aboutPermission',
      'info': [
        myBodyModel.contests[myBodyModel.curContestId].contestName,
        'addUser',
        newUser[0],
        newUser[1],
        newUser[2],
      ]
    };
    bool flag = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: request)
        .then((value) {
      return value.data['status'] == 'succeed';
    });
    return flag;
  }

  Future<bool> deleteUser(String studentNumber) async {
    Map request = {
      'requestType': 'aboutPermission',
      'info': [
        myBodyModel.contests[myBodyModel.curContestId].contestName,
        'deleteUser',
        studentNumber
      ]
    };
    bool flag = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: request)
        .then((value) {
      return value.data['status'] == 'succeed';
    });
    return flag;
  }

  Future<bool> addUsersFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    bool flag = false;
    if (result != null) {
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;
// String fileSize = result.files.single.size.toString();
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'requestType': 'addUsersFromFile',
        'contestName':
            myBodyModel.contests[myBodyModel.curContestId].contestName
      });
      flag = await dio
          .post('${myConfigInfo.getPath()}/managerForm', data: formData)
          .then((value) {
        return value.data['status'] == 'succeed';
      });
    }
    return flag;
  }

  Future<bool> changeRestrictions(int problemId,List<String> list) async{
    List<String> info = [problems[problemId].time,problems[problemId].memory,problems[problemId].maxSubmitFile];
    for(int i = 0;i < list.length;i++){
      if(list[i] != ""){
        info[i] = list[i];
      }
    }
    info.insert(0, problems[problemId].problemName);
    info.insert(0, myBodyModel.contests[myBodyModel.curContestId].contestName);
    info.insert(0, 'restrictions');
    Map request = {
      'requestType':'changeInfoNotFile',
      'info':info
    };
    bool flag = await dio.post('${myConfigInfo.getPath()}/managerJson',data: request).then((value){
      return value.data['status'] == 'succeed';
    });
    if(flag){
      for(int i = 0;i < list.length;i++){
        if(list[i] != ""){
          if(i == 0){
            problems[problemId].time = list[i];
          }else if(i == 1){
            problems[problemId].memory = list[i];
          }else if(i == 2){
            problems[problemId].maxSubmitFile = list[i];
          }
        }
      }
      notifyListeners();
    }
    return flag;
  }

  void openFolder(String dirPath) async {
    final url = Uri(scheme: 'file', path: dirPath);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("open dir error");
    }
  }

  Future<bool> uploadProblemFiles(int problemId,String option) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    bool flag = false;
    if (result != null) {//如果没有选中文件，那么result为空
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;
// String fileSize = result.files.single.size.toString();
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'requestType': 'uploadProblemFiles',
        'option':option,
        'contestName':
        myBodyModel.contests[myBodyModel.curContestId].contestName,
        'problemName':problems[problemId].problemName
      });
      flag = await dio
          .post('${myConfigInfo.getPath()}/managerForm', data: formData)
          .then((value) {
        return value.data['status'] == 'succeed';
      });
    }
    if(flag){
      if(option == "pdf"){
        problems[problemId].problemDescription = "exist";
      }else if (option == "zip"){
        problems[problemId].ioFiles = "exist";
      }
      notifyListeners();
    }
    return flag;
  }

  Future<bool> downloadUsers() async {
    Map request = {
      'requestType': 'downloadFiles',
      'info': [
        'users',
        myBodyModel.contests[myBodyModel.curContestId].contestName
      ]
    };
    return await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: request)
        .then((value) async {
      if (value.data['status'] != 'succeed') {
        return false;
      }
      DateTime now = DateTime.now();
      String curTime = '${now.month}_${now.day}_${now.hour}_${now.minute}';
      String filePath = '${curTime}list.txt';
      final file = File('${myConfigInfo.downloadFilePath}$filePath');
      await file.writeAsString(value.data['file']);
      openFolder(myConfigInfo.downloadFilePath);
      return true;
    });
  }
}

Future<bool> uploadFiles() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  bool flag = false;

  if (result != null) {
    String filePath = result.files.single.path!;
    String fileName = result.files.single.name;
// String fileSize = result.files.single.size.toString();
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'requestType': 'uploadFiles',
      'option': 'zip',
      'contestName': '广西大学第一届校赛',
      'problemName': '两数之和'
    });
    flag = await dio
        .post('${myConfigInfo.getPath()}/managerForm', data: formData)
        .then((value) {
      return value.data['status'] == 'succeed';
    });
  }
  return flag;
}
