import 'package:flutter/material.dart';
import 'package:manager/dataDependence/events.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class LoginModel extends ChangeNotifier {
  //现在是调试阶段，假设已经登陆了
  bool isLogin = true;
  LoginModel();
  bool get isLoginSuccess => isLogin;
  void loginSuccess() {
    myConfigInfo.setHostUserName();
    isLogin = true;
    notifyListeners();
  }

  Future<bool> getResponseData(String managerName, String password) async {
    myBodyModel.managerName = managerName;
    Map requestData = {
      "requestType": "managerOperate",
      "info": ['login', managerName, password]
    };
    bool response = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: requestData)
        .then((value) {
      return value.data['status'] == "succeed" ? true : false;
    });
    //   .catchError((onError) {
    //     print("hello world "+onError.toString());
    // if (onError != null) {
    //   return false;
    // }
    // return true;});
    return response;
  }
}

class manager {
  late String managerName;
  late String password;
  late String createProblemNumber;
  manager(
      {required this.managerName,
      required this.password,
      required this.createProblemNumber});
  factory manager.fromList(List<dynamic> list) {
    return manager(
        managerName: list[0], password: list[1], createProblemNumber: list[2]);
  }
}

ManagerModel myManagerModel = ManagerModel(
    managers: List.generate(0, (index) {
  return manager(
      managerName: "manager name",
      password: "password",
      createProblemNumber: "create contest");
}));

class ManagerModel extends ChangeNotifier {
  late List<manager> managers;
  bool alreadyQueryData = false;
  ManagerModel({required this.managers});

  Future<bool> addManager(List<String> newManager) async {
    newManager.insert(0, 'addManager');
    Map request = {'requestType': 'managerOperate', 'info': newManager};
    bool flag = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: request)
        .then((value) {
      if (value.data['status'] == 'succeed') {
        return true;
      }
      return false;
    });
    if (flag) {
      managers.add(manager(
          managerName: newManager[1],
          password: newManager[2],
          createProblemNumber: "0"));
      notifyListeners();
    }
    return flag;
  }

  Future<bool> queryManagers() async {
    if (alreadyQueryData) {
      return true;
    }
    Map request = {
      'requestType': 'managerOperate',
      'info': ["queryManagers"]
    };
    Response response =
        await dio.post('${myConfigInfo.getPath()}/managerJson', data: request);
    if (response.data['status'] == 'succeed') {
      alreadyQueryData = true;
      List<dynamic> list = response.data['managerList'];
      managers = List.generate(list.length, (index) {
        //这里可能要出问题？dynamic传List<dynamic>
        return manager.fromList(list[index] as List<dynamic>);
      });
      //将名为root的第一个管理员移到最前面
      for (int i = 0; i < managers.length; i++) {
        if (managers[i].managerName == "root") {
          manager m = managers.removeAt(i);
          managers.insert(0, m);
          break;
        }
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteManager(String managerName) async {
    Map request = {
      'requestType': 'managerOperate',
      'info': ['deleteManager', managerName]
    };
    bool flag = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: request)
        .then((value) {
      return value.data['status'] == 'succeed' ? true : false;
    });
    if (flag) {
      for (int i = 0; i < managers.length; i++) {
        if (managers[i].managerName == managerName) {
          managers.removeAt(i);
          break;
        }
      }
      notifyListeners();
    }
    return flag;
  }

  Future<bool> updatePassword(String managerName, String password) async {
    Map request = {
      'requestType': 'managerOperate',
      'info': ['updatePassword', managerName, password]
    };
    bool flag = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: request)
        .then((value) {
      return value.data['status'] == 'succeed' ? true : false;
    });
    if (flag) {
      for (int i = 0; i < managers.length; i++) {
        if (managers[i].managerName == managerName) {
          managers[i].password =
              password; //late String 类型的数据有setter方法吗，可以直接赋值吗？
          break;
        }
      }
      notifyListeners();
    }
    return flag;
  }

}

class contest {
  late String contestName;
  late String createTime;
  late String startTime;
  late String endTime;

  contest(
      {required this.contestName,
      required this.startTime,
      required this.endTime,
      required this.createTime});
  String? getContestName() {
    return contestName;
  }

  //将列表中的数据解析到结构体成员中
  factory contest.fromList(List<dynamic> list) {
    return contest(
      contestName: list[0],
      startTime: list[1],
      endTime: list[2],
      createTime: list[3],
    );
  }
  //改变相关成员的值
  void setFieldValue(String field, String value) {
    if (field == 'contestName') {
      contestName = value;
    } else if (field == 'startTime') {
      startTime = value;
    } else {
      endTime = value;
    }
  }

  //==================local up==========database down===============================
  //contest_name,'广西大学第二届校赛'(可以优化一下，如果value的值和原来一样，那就不用进行网络请求)
  Future<bool> changeField(String field, String value) async {
    List<String> list = [field, contestName, value];
    Map requestData = {
      'requestType': 'changeInfoNotFile',
      'info': list,
    };
    bool flag = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: requestData)
        .then((value) {
      if (value.data['status'] == 'succeed') {
        return true;
      }
      return false;
    });
    if (flag) {
      if (field == 'contest_name') {
        contestName = value;
      } else if (field == 'start_time') {
        startTime = value;
      } else {
        endTime = value;
      }
    }
    return flag;
  }
}

BodyModel myBodyModel = BodyModel(
    contests: List.generate(
        0,
        (index) => contest(
            contestName: "广西大学第一届校赛",
            startTime: '2023-10-21 10:00',
            endTime: '2023-10-21 17:00',
            createTime: '2023-10-20 20:00')).toList());

class BodyModel extends ChangeNotifier {
  late List<contest> contests;
  //从0改为1，方便调试
  int buttonId = 0;
  int curContestId = -1;
  bool whetherToObtainData = false;
  String managerName = "root";
  //切换主页面的按钮
  void switchWindow(int id) {
    if (buttonId != id) {
      buttonId = id;
      notifyListeners();
    }
  }

  //切换主页面的比赛id
  void switchContest(int id) {
    curContestId = id;
    notifyListeners();
  }

  //将新添加的比赛插入到本地第一个的位置
  void add(contest contest) {
    contests!.insert(0, contest);
    notifyListeners();
  }

//  仅限debug的时候使用(可以考虑将下面两个函数合二为一)
  Future<void> update() async {
    if (whetherToObtainData) {
      return;
    }
    //下面的代码还可以优化
    List<dynamic> list = await myBodyModel.requestContestInfo();
    debugPrint(list.toString());
    //把myBodyModel直接改变了好像不行，只能改变它的成员
    contests = fromTwoDimensionalArray(list);
    notifyListeners();
  }

//用得到的所有的比赛基本信息来构造一个结构体
  static List<contest> fromTwoDimensionalArray(List<dynamic> contestInfo) {
    return List.generate(contestInfo.length, (index) {
      return contest.fromList(contestInfo[index]);
    });
  }

  BodyModel({required this.contests});
  //============local up================database down=========================
  //获取所有的比赛基本信息
  Future<List<dynamic>> requestContestInfo() async {
    Map request = {
      "requestType": "requestInfoList",
      "info": ["contest", managerName]
    };
    Response responseData =
        await dio.post('${myConfigInfo.getPath()}/managerJson', data: request);
    if (responseData.data['status'] == 'succeed') {
      whetherToObtainData = true;
      return responseData.data['info'];
    }
    return [];
  }

  //添加一个新的比赛
  Future<bool> addANewContest(String contestName) async {
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
    List<String> list = [
      contestName,
      createTime,
      createTime,
      createTime,
      managerName,
    ];
    Map requestData = {'requestType': 'createANewContest', 'info': list};
    bool flag = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: requestData)
        .then((value) {
      if (value.data['status'] == 'succeed') {
        return true;
      }
      return false;
    });
    if (flag) {
      contests.insert(0, contest.fromList(list));
      notifyListeners();
    }
    return flag;
  }

  //改变比赛信息
  Future<bool> changeContestInfo(int id, String field, String value) async {
    bool flag = await contests[id].changeField(field, value);
    if (flag) {
      notifyListeners();
    }
    return flag;
  }

//  删除一个比赛
  Future<bool> deleteAContest(int id) async {
    Map requestData = {
      'requestType': 'deleteAContest',
      'info': [contests[id].contestName]
    };
    bool flag = await dio
        .post('${myConfigInfo.getPath()}/managerJson', data: requestData)
        .then((value) {
      if (value.data['status'] == 'succeed') {
        return true;
      }
      return false;
    });
    if (flag) {
      contests.removeAt(id);
      notifyListeners();
    }
    return flag;
  }

  // 获取指定比赛的题目列表
  Future<List<dynamic>> requestProblemInfo() async {
    Map request = {
      "requestType": "requestInfoList",
      "info": ["problem", contests[curContestId].contestName]
    };
    Response responseData =
        await dio.post("${myConfigInfo.getPath()}/managerJson", data: request);
    if (responseData.data['status'] == 'succeed') {
      return responseData.data['info'];
    }
    return [];
  }
}
