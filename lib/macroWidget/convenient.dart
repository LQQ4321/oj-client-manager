import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manager/dataDependence/Provider.dart';
import 'package:manager/dataDependence/dataTwo.dart';
import 'package:manager/dataDependence/events.dart';
import 'package:manager/dataDependence/dataOne.dart';
import 'package:manager/macroWidget/specializedWidgets.dart';
import 'dart:async';

enum sampleItem { contestName, startTime, endTime, deleteContest }

class MyPopupMenuExample extends StatefulWidget {
  const MyPopupMenuExample({super.key, required this.id});
  @override
  _MyPopupMenuExampleState createState() => _MyPopupMenuExampleState();
  final int id;
}

class _MyPopupMenuExampleState extends State<MyPopupMenuExample> {
  @override
  void initState() {
    MyBus.on('contestName', (arg) {});
    super.initState();
  }

  @override
  void dispose() {
    MyBus.off('contestName');
    super.dispose();
  }

  sampleItem? _items;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.deepOrangeAccent,
          size: 20,
        ),
        tooltip: "change info",
        initialValue: _items,
        onSelected: (sampleItem item) async {
          setState(() {
            _items = item;
          });
          String? res;
          String? field;
          if (item == sampleItem.contestName) {
            res = await MyDialogs.singleField(context, "change contest name");
            if (res == "null" || res == "") {
              return;
            }
            if (res!.contains(' ')) {
              MyDialogs.hintMessage(context, "cannot contain spaces", true);
              return;
            }
            field = "contest_name";
          } else if (item == sampleItem.deleteContest) {
            bool flag = await MyDialogs.hintMessage(
                context,
                "Are you sure you want to delete all data related to this match",
                false);
            if (!flag) {
              return;
            }
            flag = await ChangeNotifierProvider.of<BodyModel>(context)
                .deleteAContest(widget.id);
            String text = "delete contest successful";
            if (!flag) {
              text = "delete contest failed";
            }
            MyDialogs.hintMessage(context, text, true);
            return;
          } else {
            res = await MyDialogs.selectTime(context);
            if (res == "null") {
              return;
            }
            field = "start_time";
            if (item == sampleItem.endTime) {
              field = "end_time";
            }
          }
          bool flag = await ChangeNotifierProvider.of<BodyModel>(context)
              .changeContestInfo(widget.id, field, res!);
          String text = "Modification of data successful";
          if (!flag) {
            text = "Modification of data failed";
          }
          MyDialogs.hintMessage(context, text, true);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<sampleItem>>[
              const PopupMenuItem<sampleItem>(
                  value: sampleItem.contestName, child: Text('contest name')),
              const PopupMenuItem<sampleItem>(
                  value: sampleItem.startTime, child: Text('start time')),
              const PopupMenuItem<sampleItem>(
                  value: sampleItem.endTime, child: Text('end time')),
              const PopupMenuItem<sampleItem>(
                  value: sampleItem.deleteContest,
                  child: Text(
                    'delete contest',
                    style: TextStyle(color: Colors.red),
                  )),
            ]);
  }
}

enum managerItem { delete, updatePassword }

class MyManagerPopupMenu extends StatefulWidget {
  const MyManagerPopupMenu({Key? key, required this.managerName})
      : super(key: key);
  final String? managerName;
  @override
  State<MyManagerPopupMenu> createState() => _MyManagerPopupMenuState();
}

class _MyManagerPopupMenuState extends State<MyManagerPopupMenu> {
  managerItem? _items;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.deepOrangeAccent,
          size: 20,
        ),
        tooltip: "change info",
        initialValue: _items,
        onSelected: (managerItem item) async {
          setState(() {
            _items = item;
          });
          if (item == managerItem.updatePassword) {
            String newPassword =
                await MyDialogs.singleField(context, 'new password');
            if (newPassword == "null" || newPassword == "") {
              return;
            }
            if (newPassword.contains(' ')) {
              MyDialogs.hintMessage(context, "cannot contain spaces", true);
              return;
            }
            bool flag = await ChangeNotifierProvider.of<ManagerModel>(context)
                .updatePassword(widget.managerName!, newPassword);
            String text = "update password fail";
            if (flag) {
              text = "update password succeed";
            }
            MyDialogs.hintMessage(context, text, true);
          } else if (item == managerItem.delete) {
            if (widget.managerName == "root") {
              MyDialogs.hintMessage(
                  context, "The root user cannot be deleted.", true);
              return;
            }
            bool flag = await MyDialogs.hintMessage(context,
                'Are you sure to delete ${widget.managerName} ?', false);
            if (!flag) {
              return;
            }
            flag = await ChangeNotifierProvider.of<ManagerModel>(context)
                .deleteManager(widget.managerName!);
            String text = "delete fail";
            if (flag) {
              text = "delete succeed";
            }
            MyDialogs.hintMessage(context, text, true);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<managerItem>>[
              const PopupMenuItem<managerItem>(
                  value: managerItem.updatePassword, child: Text('password')),
              const PopupMenuItem<managerItem>(
                  value: managerItem.delete,
                  child: Text(
                    'delete manager',
                    style: TextStyle(color: Colors.red),
                  )),
            ]);
  }
}

enum contestItem { permission }

class ContestPopupMenu extends StatefulWidget {
  const ContestPopupMenu({super.key});

  @override
  State<ContestPopupMenu> createState() => _ContestPopupMenuState();
}

class _ContestPopupMenuState extends State<ContestPopupMenu> {
  contestItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<contestItem>(
      initialValue: selectedMenu,
      tooltip: "",
      // Callback that sets the selected popup menu item.
      onSelected: (contestItem item) {
        setState(() {
          selectedMenu = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<contestItem>>[
        const PopupMenuItem<contestItem>(
          value: contestItem.permission,
          child: Text('permission'),
        ),
      ],
    );
  }
}

enum _problemItem { pdf,zip, limit,delete ,}

class MyProblemPopupMenu extends StatefulWidget {
  const MyProblemPopupMenu({super.key, required this.problemId});
  final int problemId;
  @override
  State<MyProblemPopupMenu> createState() => _MyProblemPopupMenuState();
}

class _MyProblemPopupMenuState extends State<MyProblemPopupMenu> {
  _problemItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_problemItem>(
      initialValue: selectedMenu,
      tooltip: "",
      // Callback that sets the selected popup menu item.
      onSelected: (_problemItem item) async {
        setState(() {
          selectedMenu = item;
        });
        if (item == _problemItem.pdf) {
          bool flag = await ChangeNotifierProvider.of<ContestModel>(context)
              .uploadProblemFiles(widget.problemId, 'pdf');
          String text = "upload pdf file fail";
          if (flag) {
            text = "upload pdf file succeed";
          }
          MyDialogs.hintMessage(context, text, true);
        }else if(item == _problemItem.zip){
          bool flag = await ChangeNotifierProvider.of<ContestModel>(context)
              .uploadProblemFiles(widget.problemId, 'zip');
          String text = "upload zip file fail";
          if (flag) {
            text = "upload zip file succeed";
          }
          MyDialogs.hintMessage(context, text, true);
        }else if(item == _problemItem.limit){
          dynamic res = await MyDialogs.fillNumberField(context, ['time','memory','maxSubmitFile']);
          if(res.toString() == "null"){
            return;
          }
          bool flag = await ChangeNotifierProvider.of<ContestModel>(context).changeRestrictions(widget.problemId, res);
          String text = "change restrictions fail";
          if (flag) {
            text = "change restrictions succeed";
          }
          MyDialogs.hintMessage(context, text, true);
        } else if (item == _problemItem.delete){
          bool flag = await ChangeNotifierProvider.of<ContestModel>(context)
              .deleteProblem(widget.problemId);
          String text = "delete problem fail";
          if (flag) {
            text = "delete problem succeed";
          }
          MyDialogs.hintMessage(context, text, true);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_problemItem>>[
        const PopupMenuItem<_problemItem>(
          value: _problemItem.pdf,
          child: Center(child: Text('pdf'),),
        ),
        const PopupMenuItem<_problemItem>(
          value: _problemItem.zip,
          child: Center(child: Text('zip'),),
        ),const PopupMenuItem<_problemItem>(
          value: _problemItem.limit,
          child: Center(child: Text('limit'),),
        ),
        const PopupMenuItem<_problemItem>(
          value: _problemItem.delete,
          child: Center(child: Text('delete',style: TextStyle(color: Colors.red),),),
        ),
      ],
    );
  }
}

class MyDialogs {
  static Future<dynamic> showMyDialog(
      BuildContext context, Widget widget) async {
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(content: widget);
        });
  }

  static Future<dynamic> multiField(BuildContext context, List<String> texts) {
    return showMyDialog(context, Builder(builder: (context) {
      List<TextEditingController> controllers =
          List.generate(texts.length, (index) {
        return TextEditingController();
      });
      Widget textFields = Container(
        child: Column(
            children: List.generate(texts.length, (index) {
          return TextField(
            controller: controllers[index],
            decoration: InputDecoration(hintText: texts[index]),
          );
        }).toList()),
      );
      return SizedBox(
          width: 500,
          height: 150 + texts.length * 50,
          child: Column(
            children: [
              textFields,
              const Padding(padding: EdgeInsets.only(bottom: 40)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, "null");
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 50))),
                      child: const Text("cancel")),
                  ElevatedButton(
                      onPressed: () {
                        //没有填写的部分的值是什么？
                        List<String> list =
                            List.generate(texts.length, (index) {
                          return controllers[index].text;
                        });
                        Navigator.pop(context, list);
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 50))),
                      child: const Text("confirm")),
                ],
              )
            ],
          ));
    }));
  }


  static Future<dynamic> singleField(
      BuildContext context, String promptMessage) {
    return showMyDialog(context, Builder(builder: (context) {
      TextEditingController controller = TextEditingController();
      return SizedBox(
          width: 500,
          height: 150,
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(hintText: promptMessage),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 40)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, "null");
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 50))),
                      child: const Text("cancel")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, controller.text);
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 50))),
                      child: const Text("confirm")),
                ],
              )
            ],
          ));
    }));
  }

  static Future<dynamic> fillNumberField(
      BuildContext context, List<String> promptMessages) {
    return showMyDialog(context, Builder(builder: (context) {
      List<TextEditingController> controllers = List.generate(promptMessages.length, (index){
        return TextEditingController();
      });
      Widget NumberFields = Container(
        width: 300,
        child: Column(
          children: List.generate(promptMessages.length, (index){
            return TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              controller: controllers[index],
              decoration: InputDecoration(hintText: promptMessages[index]),
            );
          }),
        ),
      );
      return SizedBox(
          width: 500,
          height: 100 + promptMessages.length * 50,
          child: Column(
            children: [
              Center(
                child: NumberFields,
              ),
              const Padding(padding: EdgeInsets.only(bottom: 40)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, "null");
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 50))),
                      child: const Text("cancel")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, [controllers[0].text,controllers[1].text,controllers[2].text]);
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 50))),
                      child: const Text("confirm")),
                ],
              )
            ],
          ));
    }));
  }

  static Future<dynamic> hintMessage(
      BuildContext context, String promptMessage, bool isOneButton) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
        width: 500,
        height: 150,
        child: Column(
          children: [
            Text(promptMessage),
            const Padding(padding: EdgeInsets.only(bottom: 60)),
            Row(
                mainAxisAlignment: isOneButton
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: List.generate(isOneButton ? 1 : 2, (index) {
                  final String? text;
                  if (isOneButton || index == 1) {
                    text = "confirm";
                  } else {
                    text = "cancel";
                  }
                  return ElevatedButton(
                      onPressed: () {
                        if (text == "cancel") {
                          Navigator.pop(context, false);
                        } else {
                          Navigator.pop(context, true);
                        }
                      },
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 50))),
                      child: Text(text));
                }).toList())
          ],
        ),
      );
    }));
  }

  static Future<dynamic> selectTime(BuildContext context) {
    return showMyDialog(context, Builder(builder: (context) {
      return SizedBox(
        width: 500,
        height: 300,
        child: DateTimePicker(),
      );
    }));
  }

  static Future<void> loadingWidget(BuildContext context) {
    return showMyDialog(context, Builder(builder: (context) {
      return Container(
        width: 100,
        height: 200,
        color: Colors.transparent,
        child: const CircularProgressIndicator(),
      );
    }));
  }
}

class MyShowBottomSheet extends StatelessWidget {
  void _ShowBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Center(
              child: Text(
                "this is a BottomSheet",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _ShowBottomSheet(context);
        },
        child: Text("show"));
  }
}
