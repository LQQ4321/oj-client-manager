import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:manager/dataDependence/Provider.dart';
import 'package:manager/dataDependence/dataOne.dart';
import 'package:manager/modules/MyLogin.dart';
import 'package:manager/modules/Mybody.dart';

void main() {
  runApp(MyApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1000, 700);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.show();
  });
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
        data: LoginModel(),//难道用构造函数就可以在同一个组件里面获取元素，用全局变量就不行？？？
        child: Builder(
          builder: (context) {
            bool isLoginSuccess =
                ChangeNotifierProvider.of<LoginModel>(context).isLoginSuccess;
            return !isLoginSuccess ? const MyLogin() : Mybody();
          },
        ));
  }
}

// class ProviderRoute extends StatefulWidget {
//   @override
//   _ProviderRouteState createState() => _ProviderRouteState();
// }
//
// class _ProviderRouteState extends State<ProviderRoute> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ChangeNotifierProvider<CartModel>(
//           data: CartModel(),
//           child: Builder(
//             builder: (context) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   MyConsumer<CartModel>(builder: (context, cart) {
//                     return Text("${cart!.totalPrice}");
//                   }),
//                   Builder(builder: (context) {
//                     //在后面优化部分会用到
//                     print("ElevatedButton build");
//                     return ElevatedButton(
//                         onPressed: () {
//                           ChangeNotifierProvider.of<CartModel>(context)
//                               .add(Item(20.0, 1));
//                         },
//                         child: const Text("添加商品"));
//                   })
//                 ],
//               );
//             },
//           )),
//     );
//   }
// }
