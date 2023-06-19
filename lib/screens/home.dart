import 'package:may_protect/view/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:may_protect/Controllers/databasehelper.dart';
import 'package:may_protect/view/dashboard.dart';
import '../../methods/api.dart';
import 'package:may_protect/helper/constant.dart';






class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class EditData extends StatefulWidget {
  final List<dynamic> list;
  final int index;
  final SharedPreferences preferences;

  const EditData({
    required this.list,
    required this.index,
    required this.preferences,
  });


  @override
  _EditDataState createState() => _EditDataState();
}

class _HomeState extends State<Home> {
  late SharedPreferences preferences;
  bool isLoading = false;



  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;

    });
  }

  void logout() {
    preferences.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(),

      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                logout();
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.red,
                  child: Text(
                    'logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.all(40.0),

              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.grey[200],
                            child: Text(
                              'id ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.grey[200],
                            child: Text(
                              '名前 ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.grey[200],
                            child: Text(
                              'メールアドレス ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.grey[200],
                            child: Text(
                              '連絡先① ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.grey[200],
                            child: Text(
                              '連絡先② ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                '${preferences.getInt('id').toString()}'),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                '${preferences.getString('name').toString()}'),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                '${preferences.getString('email').toString()}'),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                '${preferences.getString('tel1').toString()}'),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                '${preferences.getString('tel2').toString()}'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(child: Text('曜日')),
                      TableCell(child: Text('朝6～12時')),
                      TableCell(child: Text('昼12~19時')),
                      TableCell(child: Text('夜19～6時')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('月曜日')),
                      TableCell(child: Text('mon1: ${preferences.getInt(
                          'mon1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon2: ${preferences.getInt(
                          'mon2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon3: ${preferences.getInt(
                          'mon3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('火曜日')),
                      TableCell(child: Text('mon1: ${preferences.getInt(
                          'mon1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon2: ${preferences.getInt(
                          'mon2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon3: ${preferences.getInt(
                          'mon3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('水曜日')),
                      TableCell(child: Text('mon1: ${preferences.getInt(
                          'mon1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon2: ${preferences.getInt(
                          'mon2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon3: ${preferences.getInt(
                          'mon3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('木曜日')),
                      TableCell(child: Text('mon1: ${preferences.getInt(
                          'mon1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon2: ${preferences.getInt(
                          'mon2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon3: ${preferences.getInt(
                          'mon3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('金曜日')),
                      TableCell(child: Text('mon1: ${preferences.getInt(
                          'mon1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon2: ${preferences.getInt(
                          'mon2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon3: ${preferences.getInt(
                          'mon3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('土曜日')),
                      TableCell(child: Text('mon1: ${preferences.getInt(
                          'mon1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon2: ${preferences.getInt(
                          'mon2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon3: ${preferences.getInt(
                          'mon3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('日曜日')),
                      TableCell(child: Text('mon1: ${preferences.getInt(
                          'mon1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon2: ${preferences.getInt(
                          'mon2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('mon3: ${preferences.getInt(
                          'mon3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // ユーザー情報編集画面に移動するボタンを追加
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditData(
                        list: [
                          {
                            'id': preferences.getInt('id'), // getInt('id')の結果をそのまま代入
                          'name': preferences.getString('name'),
                            'email': preferences.getString('email'),
                            'tel1': preferences.getString('tel1'),
                            'tel2': preferences.getString('tel2'),
                          }
                        ], // 空のリストを渡すか、適切なデータを渡す

                        index: 0, // 適切なインデックスを渡す
                        preferences: preferences,
                      ),
                    ),
                  );
                },
                child: Text('Edit Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _EditDataState extends State<EditData> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  late SharedPreferences preferences; // 追加


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController tel1Controller = TextEditingController();
  TextEditingController tel2Controller = TextEditingController();

  @override
  void initState() {
    preferences = widget.preferences; // 追加
    nameController = TextEditingController(text: widget.list[widget.index]['name']);
    emailController = TextEditingController(text: widget.list[widget.index]['email']);
    tel1Controller = TextEditingController(text: widget.list[widget.index]['tel1']);
    tel2Controller = TextEditingController(text: widget.list[widget.index]['tel2']);
    super.initState();
  }

  void loadUserData() {
    nameController.text = widget.preferences.getString('name') ?? '';
    emailController.text = widget.preferences.getString('email') ?? '';
    tel1Controller.text = widget.preferences.getString('tel1') ?? '';
    tel2Controller.text = widget.preferences.getString('tel2') ?? '';
  }

  void saveUserData() {
    widget.preferences.setString('name', nameController.text);
    widget.preferences.setString('email', emailController.text);
    widget.preferences.setString('tel1', tel1Controller.text);
    widget.preferences.setString('tel2', tel2Controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '連絡先 1',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: tel1Controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '連絡先 2',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: tel2Controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  void updateData() async {
                    int userId = widget.list[widget.index]['id'] ?? 0;
                    String idValue = userId != null ? userId.toString() : '';
                    if (userId != null) {
                      final data = {
                        'id': userId.toString(),
                        'name': nameController.text.trim(),
                        'email': emailController.text.trim(),
                        'tel1': tel1Controller.text.trim(),
                        'tel2': tel2Controller.text.trim(),
                      };
                      final Map<String, String> requestData = data.map((key, value) => MapEntry(key, value.toString()));

                      final result = await API().putRequest(
                        route: '/update_user_fl/$userId', data: requestData,
                      );

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Dashboard(title: 'Dashboard'),
                        ),
                      );
                    } else {
                      return print('Some error has Occurred');
                    }


                  }
                  // 呼び出し元のコード内でupdateData()を呼び出す
                  updateData();
                },
                child: Text('変更内容を送信'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}