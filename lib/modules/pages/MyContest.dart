import 'package:flutter/material.dart';
import 'package:manager/dataDependence/Provider.dart';
import 'package:manager/dataDependence/dataTwo.dart';
import 'package:manager/macroWidget/convenient.dart';

class MyContestRoute extends StatefulWidget {
  const MyContestRoute({Key? key}) : super(key: key);

  @override
  State<MyContestRoute> createState() => _MyContestRouteState();
}

class _MyContestRouteState extends State<MyContestRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
          data: myContestModel,
          child: Row(
            children: const [_leftNavigation(), _rightNavigation()],
          )),
    );
  }
}

class _leftNavigation extends StatelessWidget {
  const _leftNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 6, top: 6, bottom: 8, right: 6),
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
          children: List.generate(6, (index) {
        List<String> text = [
          "back",
          "problem",
          "rank",
          "status",
          "news",
          "contestant",
        ];
        return ElevatedButton(
            onPressed: () async {
              ChangeNotifierProvider.of<ContestModel>(context)
                  .switchButtonId(index);
              if (index == 0) {
                ChangeNotifierProvider.of<ContestModel>(context, listen: false)
                    .switchButtonId(1);
                Navigator.pop(context);
              } else if (index == 1) {}
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero)),
                backgroundColor: MaterialStateColor.resolveWith((states) =>
                    index !=
                            ChangeNotifierProvider.of<ContestModel>(context)
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
      }).toList()),
    );
  }
}

class _rightNavigation extends StatelessWidget {
  const _rightNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Builder(
      builder: (BuildContext context) {
        int id = ChangeNotifierProvider.of<ContestModel>(context).buttonId;
        if (id == 1) {
          return _problemList();
        } else if (id == 5) {
          return _contestant();
        }
        return Container();
      },
    ));
  }
}

class _problemList extends StatelessWidget {
  const _problemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int length =
        ChangeNotifierProvider.of<ContestModel>(context).problems.length;
    return Scaffold(
      body: ListView.builder(
          itemCount: length,
          itemExtent: 100,
          itemBuilder: (BuildContext context, int index) {
            return _problemCell(id: index);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String text = await MyDialogs.singleField(
              context, "Enter the name of the problem");
          if (text == "null" || text == "") {
            return;
          }
          if (text.contains(' ')) {
            MyDialogs.hintMessage(context, "cannot contain spaces", true);
            return;
          }
          bool flag = await ChangeNotifierProvider.of<ContestModel>(context)
              .createANewProblem(text);
          final String? hintText;
          if (flag) {
            hintText = "Successfully added the problem";
          } else {
            hintText = "Failed to add the problem";
          }
          MyDialogs.hintMessage(context, hintText, true);
        },
        backgroundColor: Colors.purpleAccent.shade100,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _problemCell extends StatelessWidget {
  const _problemCell({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    problem _problem =
        ChangeNotifierProvider.of<ContestModel>(context).problems[id];
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: MyProblemPopupMenu(
            problemId: id,
          ),
        ),
        Expanded(
            child: Card(
                color: (_problem.ioFiles == "null" || _problem.problemDescription == "null")
                    ? Colors.red[100]:Colors.green[100],
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () async {
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _problem.problemName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "created : ${_problem.createTime}",
                        textScaleFactor: 0.8,
                      ),
                      Text(
                        "time : ${_problem.time}ms / memory : ${_problem.memory}MB / maxSubmitFile : ${_problem.maxSubmitFile}MB",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                )))
      ],
    );
  }
}

class _contestant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> functions = [
      "add user to contest",
      "delete user from contest",
      "upload list",
      "download list"
    ];
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(functions.length, (index) {
          return SizedBox(
            width: 200,
            height: 50,
            child: Card(
                color: Colors.purple[50],
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () async {
                      String text = "operate fail";
                      if (index == 0) {
                        dynamic user = await MyDialogs.multiField(
                            context, ["student_number", "name", "password"]);
                        bool flag = true;
                        if (user.toString() == "null") {
                          flag = false;
                        }
                        for (int i = 0; i < user.length; i++) {
                          if (user[i] == "" || user[i].contains(' ')) {
                            flag = false;
                            break;
                          }
                        }
                        if (!flag) {
                          MyDialogs.hintMessage(context, "formal error", true);
                          return;
                        }
                        flag = await ChangeNotifierProvider.of<ContestModel>(
                                context)
                            .addUser(user);
                        if (flag) {
                          text = "add user succeed";
                        }
                      } else if (index == 1) {
                        String studentNumber = await MyDialogs.singleField(
                            context, "student number");
                        if (studentNumber == "null") {
                          return;
                        }
                        if (studentNumber == "" ||
                            studentNumber.contains(' ')) {
                          MyDialogs.hintMessage(context, "formal error", true);
                          return;
                        }
                        bool flag =
                            await ChangeNotifierProvider.of<ContestModel>(
                                    context)
                                .deleteUser(studentNumber);
                        if (flag) {
                          text = "delete user succeed";
                        }
                      } else if (index == 2) {
                        bool flag =
                            await ChangeNotifierProvider.of<ContestModel>(
                                    context)
                                .addUsersFromFile();
                        if (flag) {
                          text = 'upload list succeed';
                        }

// try {
// Dio dio = Dio();
// Response response = await dio.post(
// myConfigInfo.getPath() + '/uploadFile',
// data: formData,
// onSendProgress: (int sentBytes, int totalBytes) {
// double progress = sentBytes / totalBytes * 100;
// print('upload progress: $progress');
// });
// print("response : ${response}");
// } catch (error) {
// print(error);
// }

                      } else {
                        bool flag =
                            await ChangeNotifierProvider.of<ContestModel>(
                                    context)
                                .downloadUsers();
                        if (flag) {
                          text = 'download list succeed';
                        }
                      }
                      MyDialogs.hintMessage(context, text, true);
                    },
                    child: Center(
                      child: Text(functions[index]),
                    ))),
          );
        }));
  }
}
