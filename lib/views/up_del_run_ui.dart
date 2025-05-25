import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_run_record_app/models/run.dart';

class UpDelRunUI extends StatefulWidget {
  //สร้างตัวแปรรับข้อมูลเพื่อที่จะมาแสดงที่หน้าจอ
  int? runId;
  String? runLocation;
  double? runDistance;
  int? runTime;

  //เอาตัวแปรที่สร้างมารับข้อมูลที่ส่งมาจากหน้าก่อนหน้า
  UpDelRunUI({
    super.key,
    this.runId,
    this.runLocation,
    this.runDistance,
    this.runTime,
  });

  @override
  State<UpDelRunUI> createState() => _UpDelRunUIState();
}

class _UpDelRunUIState extends State<UpDelRunUI> {
  //สร้างตัวควบคุม TexField
  TextEditingController runLocationCtrl = TextEditingController();
  TextEditingController runDistanceCtrl = TextEditingController();
  TextEditingController runTimeCtrl = TextEditingController();

  //ไดอะล็อกแสดงคำเตือน
  Future<void> _showWarningDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คำเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //ไดอะล็อกแสดงผลการทำงาน
  Future<void> _showResultDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ผลการทำงาน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //ตอนหน้าจอถูกเปิดเอาค่าที่ส่งมาจากหน้าก่อนหน้า มาแสดงที่ TextField ผ่านตัวควบคุม TextField
  @override
  void initState() {
    runLocationCtrl.text = widget.runLocation!;
    runDistanceCtrl.text = widget.runDistance.toString();
    runTimeCtrl.text = widget.runTime.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text(
          'แก้ไข/ลบการวิ่งของฉัน',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 40.0,
          right: 40.0,
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60.0,
              ),
              Image.asset(
                'assets/images/running.png',
                width: 180.0,
              ),
              SizedBox(
                height: 40.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'สถานที่วิ่ง',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: runLocationCtrl,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกสถานที่วิ่ง',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ระยะทางที่วิ่ง (กิโลเมตร)',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: runDistanceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกระยะทางที่วิ่ง',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'เวลาที่ใช้ในการวิ่ง (นาที)',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: runTimeCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกเวลาที่ใช้ในการวิ่ง',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  //ตรวจสอบว่ามีการกรอกข้อมูลครบถ้วนหรือไม่
                  if (runLocationCtrl.text.isEmpty) {
                    //แสดงไดอะล็อกคำเตือน
                    await _showWarningDialog('กรุณากรอกสถานที่ิวิ่งด้วย');
                  } else if (runDistanceCtrl.text.isEmpty) {
                    await _showWarningDialog('กรุณากรอกระยะทางวิ่งด้วย');
                  } else if (runTimeCtrl.text.isEmpty) {
                    await _showWarningDialog('กรุณาระยะเวลาในการวิ่งด้วย');
                  } else {
                    //ส่งข้อมูลไปบันทึกที่ฐานข้อมูล ผ่าน API
                    //แพ็กข้อมูลที่จะส่ง
                    Run run = Run(
                      runLocation: runLocationCtrl.text,
                      runDistance: double.parse(runDistanceCtrl.text),
                      runTime: int.parse(runTimeCtrl.text),
                    );

                    //ส่งข้อมูลโดยเอาข้อมูลที่จะส่งมาทำให้เป็น JSON
                    final result = await Dio().put(
                      'http://10.1.1.86:8888/api/run/${widget.runId}',
                      data: run.toJson(),
                    );

                    //ตรวจสอบผลการทำงานจาก result
                    if (result.statusCode == 200) {
                      await _showResultDialog('บันทึกแก้ไขการวิ่งเรียบร้อยแล้ว')
                          .then((value) {
                        //เมื่อกดตกลงในไดอะล็อกแล้ว ให้กลับไปที่หน้าจอการวิ่งของฉัน
                        Navigator.pop(context);
                      });
                    } else {
                      await _showWarningDialog(
                          'ไม่สามารถบันทึกแก้ไขการวิ่งได้');
                    }
                  }
                },
                child: Text(
                  'บันทึกแก้ไขการวิ่ง',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  fixedSize: Size(
                    MediaQuery.of(context).size.width,
                    60.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  //ส่งข้อมูลโดยเอาข้อมูลที่จะส่งมาทำให้เป็น JSON
                  final result = await Dio().delete(
                    'http://10.1.1.86:8888/api/run/${widget.runId}',
                  );

                  //ตรวจสอบผลการทำงานจาก result
                  if (result.statusCode == 200) {
                    await _showResultDialog('ลบการวิ่งเรียบร้อยแล้ว')
                        .then((value) {
                      //เมื่อกดตกลงในไดอะล็อกแล้ว ให้กลับไปที่หน้าจอการวิ่งของฉัน
                      Navigator.pop(context);
                    });
                  } else {
                    await _showWarningDialog('ลบการวิ่งได้');
                  }
                },
                child: Text(
                  'ลบการวิ่ง',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width,
                    60.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
