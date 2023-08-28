// import 'package:platform/platform.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:dio/dio.dart';
// import 'dart:io';
// if (index == 2) {
// FilePickerResult? result =
// await FilePicker.platform.pickFiles();
// if (result != null) {
// String filePath = result.files.single.path!;
// String fileName = result.files.single.name;
// // String fileSize = result.files.single.size.toString();
// FormData formData = FormData.fromMap({
// 'file': await MultipartFile.fromFile(filePath,
// filename: fileName),
// 'problem': 'standardCode'
// });
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
// }
// } else if (index == 3) {
// print(
//     'C:\\Users\\QQ123456\\Desktop\\test\\postmanFiles\\main.cpp');
// Dio dio = Dio();
// Map request = {'downloadFileName': 'problem.pdf'};
// Response response = await dio.post(
// '${myConfigInfo.getPath()}/managerRelatedToTheDocument',
// data: request);
// if (response.statusCode == 200) {
// // final file = File(
// //     'C:\\Users\\QQ123456\\Desktop\\test\\postmanFiles\\main.cpp');
// final file = File(
// 'C:\\Users\\QQ123456\\Downloads\\main.cpp');
// print(response);
// print("hello world !");
// await file.writeAsString(response.data['file']);

//   Platform platform = LocalPlatform();
//   if(platform.isWindows){
//     String? userName = platform.environment['USERNAME'];
//     print('$userName');
//   }
// }
//======================================================
// Dio dio = Dio();
// Response response = await dio.post(
//     myConfigInfo.getPath() + '/managerRelatedToTheDocument',
//     options: Options(responseType: ResponseType.stream));
// // Map<String, dynamic> responseData = response.data;
// print(response);
// print(response.data);
// String filePath =
//     'C:\\Users\\QQ123456\\Desktop\\test\\postmanFiles\\main.cpp';
// File file = File(filePath);
// response.data.stream.pipe(file.openWrite());
// }
// }