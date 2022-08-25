import 'dart:io';

Future<String> deleteFile(String filename, String folder) async {
  final file = File('$folder/$filename');
  final content = file.readAsString();
  try {
    if (await file.exists()) {
      await file.delete();
      return content;
    }
    return '';
  } catch (e) {
    return e.toString();
  }
}

///Input data parameter should be "Latitude,longitude,x,y,z".
///dataType is "data" for gps and accelermonter data and "user" for user data
Future<String> WriteData(filename, data, dataType, folder) async {
  String filepath = folder + "/" + filename;
  if (dataType == "data") {
    String date = (DateTime.now().toString()).split(" ")[0];
    String time = (DateTime.now().toString()).split(" ")[1];
    if (!File(filepath).existsSync()) {
      new File(filepath).create(recursive: true);
      String newdata =
          "\nLatitude,Longitude,X axis,Y axis,Z axis,Date,Time" '\n' +
              data +
              ',' +
              date +
              ',' +
              time;
      new File(filepath).writeAsString(newdata);
    } else {
      String newdata = await File(filepath).readAsString() +
          '\n' +
          data +
          ',' +
          date +
          ',' +
          time;
      new File(filepath).writeAsString(newdata);
    }
  } else if (dataType == "user") {
    if (!File(filepath).existsSync()) {
      new File(filepath).create(recursive: true);
      String newdata =
          data + "\nLatitude,Longitude,X axis,Y axis,Z axis,Date,Time";
      new File(filepath).writeAsString(newdata);
    } else {
      String newdata = data + await File(filepath).readAsString();
      new File(filepath).writeAsString(newdata);
    }
  }
  return (data);
}

Future<String> ReadFile(filename, folder) async {
  String filepath = folder + '/' + filename;
  if (!File(filepath).existsSync()) {
    print("File does not exist!");
  }
  String contents = await File(filepath).readAsString();
  return (contents);
}
