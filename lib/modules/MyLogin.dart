import 'package:flutter/material.dart';
import 'package:manager/dataDependence/Provider.dart';
import 'package:manager/macroWidget/convenient.dart';
import 'package:manager/dataDependence/dataOne.dart';
import 'package:manager/dataDependence/events.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({
    Key? key,
  }) : super(key: key);
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final List<TextEditingController> _textList =
      List.generate(3, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned.fill(
              child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/picture2.jpg"),
                    fit: BoxFit.cover)),
          )),
          Center(
            child: Container(
              width: 350,
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white70,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black45,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0)
                  ]),
              child: Column(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      TextField(
                        controller: _textList[0],
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: "manager name",
                        ),
                      ),
                      // const Padding(padding: EdgeInsets.only(bottom: 10)),
                      TextField(
                        controller: _textList[1],
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: "password",
                        ),
                      ),
                      TextField(
                        controller: _textList[2],
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: "127.0.0.1:8080",
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 20)),
                      OutlinedButton(
                          onPressed: () async {
                            for (int i = 0; i < _textList.length; i++) {
                              if (_textList[i].text == "" ||
                                  _textList[i].text.contains(' ')) {
                                MyDialogs.hintMessage(
                                    context, 'formal error', true);
                                return;
                              }
                            }
                            String managerName = _textList[0].text;
                            String password = _textList[1].text;
                            myConfigInfo.setPath(_textList[2].text);

                            bool status =
                                await ChangeNotifierProvider.of<LoginModel>(
                                        context,
                                        listen: false)
                                    .getResponseData(managerName, password);
                            if (status) {
                              // 加上await就会等待异步函数执行完成，不加就直接过掉它，先执行下面的语句
                              MyDialogs.hintMessage(
                                  context, "login success", true);
                              //是不是要执行完下面的延时函数才执行更下面的代码？
                              //还是说不加await关键字，直接就暂时跳过了下面的代码，转而去执行更下面的代码
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.pop(context); //这个pop好像没有必要啊
                                ChangeNotifierProvider.of<LoginModel>(context,
                                        listen: false)
                                    .loginSuccess();
                              });
                              //这里可以加载主页需要的数据
                              // List<dynamic> list =
                              //     await BodyModel.requestContestInfo();
                              // //这里修改过了，还没测试
                              // myBodyModel.contests =
                              //     BodyModel.fromTwoDimensionalArray(list);
                            } else {
                              MyDialogs.hintMessage(
                                  context, "login fail", true);
                              Future.delayed(const Duration(seconds: 2), () {
                                //
                                Navigator.pop(context);
                              });
                            }
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(120, 60))),
                          child: const Text("login")),
                    ],
                  )),
                  const Text("The software picture resource author : Wlop"),
                  const Padding(padding: EdgeInsets.only(bottom: 5))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
