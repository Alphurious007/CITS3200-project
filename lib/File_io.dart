library file_io;


import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';



String generate_file_name(uniqueID) {
  String filename = "${DateTime.now()}_${DateTime.now().timeZoneOffset}_${uniqueID}.csv";
  return filename;
}


Future<String> get_unique_id() async {
  final Directory? directory = await getExternalStorageDirectory();
  var new_file = '${directory!.path}/userdata/uniqueid.txt';
  final File file = await File(new_file).create(recursive: true);
  final data = await file.readAsString();
  if(await data == ''){
    var uuid = Uuid();
    final sink = file.openWrite();
    sink.write(await uuid.v4());
    sink.close();
    return await file.readAsString();
  }
  return await file.readAsString();
}


Future<String> delete_file(filename, folder) async {
  final Directory? directory = await getExternalStorageDirectory();
  var new_file = '${directory!.path}/${folder}/${filename}';
  bool fileExists = await File(new_file). exists();
  if(fileExists) {
    final file = File(new_file);
    final content = await file.readAsString();
    try {
      await file.delete();
      return content;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
  return '${filename} does not exist';
}


Future<String> read_file(filename, folder) async {
  final Directory? directory = await getExternalStorageDirectory();
  var new_file = '${directory!.path}/${folder}/${filename}';
  bool fileExists = await File(new_file). exists();
  if(fileExists) {
    try {
      final file = File(new_file);
      final content = await file.readAsString();
      return content;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
  return '${filename} does not exist';
}


//Jamir write
Future<String> write_file(
    data_array, data_type, filename, folder, uniqueID) async {
  final Directory? directory = await getExternalStorageDirectory();
  var new_file = '${directory!.path}/${folder}/${filename}';
  //print(new_file);
  final File file = await File(new_file).create(recursive: true);

  final data = await file.readAsString();
  final sink = file.openWrite();
  if(data_type == '') {
    sink.write(data_array);
  }
  else {
    sink.write(data +
        "${uniqueID}, ${DateTime.now()}, ${DateTime
            .now()
            .timeZoneOffset}, $data_type, ${data_array.join(",")}/n");
  }
  sink.close();
  return await file.readAsString();
}


Future<String> move_file(
    source_filename, source_folder, sink_filename, sink_folder) async {
  String content = await read_file(source_filename, source_folder);
  if (content == '${source_filename} does not exist') {
    //print('heres content:');
    //print(content);
    return content;
  }
  else {
    //print('heres content:');
    //print(content);
    String result = await write_file(content, '', sink_filename, sink_folder, '');
    delete_file(source_filename, source_folder);
    print('yeet 2');
    return result;
  }
}



////////////////////////////////////////////////////////


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

///Generates a file named "currentDate_CurrentTime_inputId.csv" in specified folder
Future<String> GenerateFile(inputId, folder) async {
  DateTime datetime = DateTime.now();
  String date = (DateTime.now().toString()).split(" ")[0];
  String time = '${datetime.hour}-${datetime.minute}';
  String filename = "${'${date}_${time}_' + inputId}.csv";
  String filepath = folder + "/" + filename;
  await new File(filepath).create(recursive: true);
  String newdata = "\nLatitude,Longitude,X axis,Y axis,Z axis,Date,Time";
  File(filepath).writeAsString(newdata);
  return (filename);
}

Future<String> ReadFile(filename, folder) async {
  String filepath = folder + '/' + filename;
  if (!File(filepath).existsSync()) {
    print("File does not exist!");
  }
  String contents = await File(filepath).readAsString();
  return (contents);
}
