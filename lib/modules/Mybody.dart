import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:manager/dataDependence/Provider.dart';
import 'package:manager/dataDependence/dataOne.dart';
import 'package:manager/dataDependence/dataTwo.dart';
import 'package:manager/macroWidget/convenient.dart';
import 'package:manager/modules/MyAppBar.dart';
import 'package:manager/modules/pages/MyContest.dart';

class Mybody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WindowBorder(
        color: Colors.white10,
        child: ChangeNotifierProvider<BodyModel>(
            data: myBodyModel,
            child: ChangeNotifierProvider<ManagerModel>(
                data: myManagerModel,
                child: Row(
                  children: [
                    _leftNavigation(),
                    Expanded(
                        child: Column(
                      children: [
                        const MyAppBar(),
                        Expanded(child: Builder(
                          builder: (BuildContext context) {
                            var id =
                                ChangeNotifierProvider.of<BodyModel>(context)
                                    .buttonId;
                            if (id == 0) {
                              return _homeWindow();
                            } else if (id == 1) {
                              return _contestWindow();
                            } else {
                              return _managerWindow();
                            }
                          },
                        ))
                      ],
                    ))
                  ],
                ))));
  }
}

class _leftNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int len =
        ChangeNotifierProvider.of<BodyModel>(context).managerName == "root"
            ? 3
            : 2;
    return Column(
      children: [
        _managerCell(),
        Expanded(
            child: Container(
                width: 150,
                margin:
                    const EdgeInsets.only(left: 6, top: 6, bottom: 8, right: 6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black45,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0)
                    ]),
                child: Column(
                    children: List.generate(len, (index) {
                  List<String> text = ["home", "contest", "manager", "test"];
                  return ElevatedButton(
                      onPressed: () async {
                        ChangeNotifierProvider.of<BodyModel>(context)
                            .switchWindow(index);
                        if (index == 1) {
                          //这里可以加载主页需要的数据
                          ChangeNotifierProvider.of<BodyModel>(context)
                              .update();
                        } else if (index == 2) {
                          ChangeNotifierProvider.of<ManagerModel>(context)
                              .queryManagers();
                        }
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero)),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => index !=
                                      ChangeNotifierProvider.of<BodyModel>(context)
                                          .buttonId
                                  ? Colors.white
                                  : Colors.black12),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                          shadowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                          minimumSize:
                              MaterialStateProperty.all(const Size(double.infinity, 60))),
                      child: Text(
                        text[index],
                        style: const TextStyle(color: Colors.black),
                      ));
                }).toList())))
      ],
    );
  }
}

class _homeWindow extends StatelessWidget {
  _homeWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}

class _contestWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int length = ChangeNotifierProvider.of<BodyModel>(context).contests.length;
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: length,
            itemExtent: 100,
            itemBuilder: (BuildContext context, int index) {
              return _contestCell(id: index);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String text = await MyDialogs.singleField(
              context, "Enter the name of the competition");
          if (text == "null" || text == "") {
            return;
          }
          if (text.contains(' ')) {
            MyDialogs.hintMessage(context, "cannot contain spaces", true);
            return;
          }
          bool flag = await ChangeNotifierProvider.of<BodyModel>(context)
              .addANewContest(text);
          final String? hintText;
          if (flag) {
            hintText = "successfully added the match";
          } else {
            hintText = "Failed to add the match";
          }
          MyDialogs.hintMessage(context, hintText, true);
        },
        backgroundColor: Colors.purpleAccent.shade100,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _contestCell extends StatelessWidget {
  _contestCell({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    contest _contest =
        ChangeNotifierProvider.of<BodyModel>(context).contests[id];
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: MyPopupMenuExample(
            id: id,
          ),
          // child:
        ),
        Expanded(
            child: Card(
                color: Colors.purple[50],
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () async {
                    ChangeNotifierProvider.of<BodyModel>(context, listen: false)
                        .switchContest(id);
                    MyDialogs.loadingWidget(context);
                    List<dynamic> list =
                        await ChangeNotifierProvider.of<BodyModel>(context)
                            .requestProblemInfo();
                    myContestModel.fromList(list);
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MyContestRoute();
                    }));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _contest.contestName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "created : ${_contest.createTime}",
                        textScaleFactor: 0.8,
                      ),
                      Text(
                        "from ${_contest.startTime} to ${_contest.endTime}",
                        textScaleFactor: 0.9,
                      ),
                    ],
                  ),
                )))
      ],
    );
  }
}

class _managerWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int len = ChangeNotifierProvider.of<ManagerModel>(context).managers.length;
    return Scaffold(
      body: SizedBox(
        height: 450,
        child: ListView.builder(
            itemExtent: 100,
            itemCount: len,
            itemBuilder: (BuildContext context, int index) {
              return _managerRow(
                id: index,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic res =
              await MyDialogs.multiField(context, ["manager name", "password"]);
          bool flag = true;
          if (res.toString() == "null") {
            flag = false;
          }
          for (int i = 0; i < res.length; i++) {
            if (res[i] == "" || res[i].contains(' ')) {
              flag = false;
              break;
            }
          }
          if (!flag) {
            MyDialogs.hintMessage(context, "formal error", true);
            return;
          }
          flag = await ChangeNotifierProvider.of<ManagerModel>(context)
              .addManager(res);
          String text = "operator fail";
          if (flag) {
            text = "operator succeed";
          }
          MyDialogs.hintMessage(context, text, true);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _managerCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 150,
      margin: const EdgeInsets.only(left: 6, top: 3, right: 6),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage("assets/images/picture6.jpg"),
          ),
          Text(ChangeNotifierProvider.of<BodyModel>(context).managerName),
        ],
      ),
    );
  }
}

class _managerRow extends StatelessWidget {
  _managerRow({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  Widget build(BuildContext context) {
    manager _manager =
        ChangeNotifierProvider.of<ManagerModel>(context).managers[id];
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: MyManagerPopupMenu(
            managerName: _manager.managerName,
          ),
          // child:
        ),
        Expanded(
            child: Card(
                color: Colors.purple[50],
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'manager name : ${_manager.managerName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "password : ${_manager.password}",
                        textScaleFactor: 0.8,
                      ),
                      Text(
                        "create contest : ${_manager.createProblemNumber}",
                        textScaleFactor: 0.9,
                      ),
                    ],
                  ),
                )))
      ],
    );
  }
}
