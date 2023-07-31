import 'package:may_protect/view/login.dart';
import 'package:may_protect/view/stop.dart';
import 'package:may_protect/view/suspend.dart';
import 'package:may_protect/view/again.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:may_protect/Controllers/databasehelper.dart';
import 'package:may_protect/view/dashboard.dart';
import 'package:may_protect/methods/api.dart';
import 'package:may_protect/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Home extends StatefulWidget {
  final Map<String, dynamic>? updatedData; // 追加
  final Map<String, dynamic>? modeData; // 追加
  const Home({Key? key, this.updatedData, this.modeData}) : super(key: key);




  @override
  State<Home> createState() => _HomeState();
}

class EditData extends StatefulWidget {
  final List<dynamic> list;
  final int index;
  final SharedPreferences preferences;
  final Map<String, dynamic>? updatedData; // 追加


  const EditData({
    required this.list,
    required this.index,
    required this.preferences,
    this.updatedData, // 追加

  });


  @override
  _EditDataState createState() => _EditDataState();
}

class _HomeState extends State<Home> {
  late SharedPreferences preferences;
  bool isLoading = false;
  late int mode; // モードの状態を保持する変数を追加


  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {

    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
      // 編集後のデータを受け取り、状態を更新する
      if (widget.updatedData != null) {
        preferences.setString('name', widget.updatedData!['name']);
        preferences.setString('email', widget.updatedData!['email']);
        preferences.setString('tel1', widget.updatedData!['tel1']);
        preferences.setString('tel2', widget.updatedData!['tel2']);
        preferences.setString('mode', widget.modeData!['mode']); // modeDataを保存
      }

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
            : SingleChildScrollView(
               child: Column(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (int.parse(preferences.getString('mode') ?? '0') == 0)
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SuspendPage(
                list: [
                  {
                    'id': preferences.getInt('id'),
                    'name': preferences.getString('mode'),
                  }
                ],
                index: 0,
                preferences: preferences,
              ),
        ),
      );
    },
                          child: Text('一時停止画面に移動'),
                      ),
                      SizedBox(height: 10), // 空間を作成するためにSizedBoxを挿入
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                StopPage(
                                  list: [
                                    {
                                      'id': preferences.getInt('id'),
                                      'name': preferences.getString('mode'),
                                    }
                                  ],
                                  index: 0,
                                  preferences: preferences,
                                ),
                                  ),

                          );
                        },
                        child: Text('停止画面に移動'),
                      ),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            AgainPage(
                              list: [
                                {
                                  'id': preferences.getInt('id'),
                                  'name': preferences.getString('mode'),
                                }
                              ],
                              index: 0,
                              preferences: preferences,
                            ),
                          ),
                      );
                    },
                    child: Text('再開画面に移動'),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'id ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '${preferences.getInt('id').toString()}',
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '名前 ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '${preferences.getString('name').toString()}',
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'メールアドレス ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '${preferences.getString('email').toString()}',
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '連絡先① ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '${preferences.getString('tel1').toString()}',
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '連絡先② ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '${preferences.getString('tel2').toString()}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                      TableCell(child: Text('tue1: ${preferences.getInt(
                          'tue1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('tue2: ${preferences.getInt(
                          'tue2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('tue3: ${preferences.getInt(
                          'tue3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('水曜日')),
                      TableCell(child: Text('wed1: ${preferences.getInt(
                          'wed1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('wed2: ${preferences.getInt(
                          'wed2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('wed3: ${preferences.getInt(
                          'wed3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('木曜日')),
                      TableCell(child: Text('thu1: ${preferences.getInt(
                          'thu1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('thu2: ${preferences.getInt(
                          'thu2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('thu3: ${preferences.getInt(
                          'thu3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('金曜日')),
                      TableCell(child: Text('fri1: ${preferences.getInt(
                          'fri1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('fri2: ${preferences.getInt(
                          'fri2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('fri3: ${preferences.getInt(
                          'fri3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('土曜日')),
                      TableCell(child: Text('sat1: ${preferences.getInt(
                          'sat1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('sat2: ${preferences.getInt(
                          'sat2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('sat3: ${preferences.getInt(
                          'sat3')}' == 0 ? '連絡先①' : '連絡先②')),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(child: Text('日曜日')),
                      TableCell(child: Text('sun1: ${preferences.getInt(
                          'sun1')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('sun2: ${preferences.getInt(
                          'sun2')}' == 0 ? '連絡先①' : '連絡先②')),
                      TableCell(child: Text('sun3: ${preferences.getInt(
                          'sun3')}' == 0 ? '連絡先①' : '連絡先②')),
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
                  ).then((updatedData) {
                    if (updatedData != null) {
                      setState(() {
                        // 編集後のデータを受け取り、状態を更新する
                        preferences.setString('name', updatedData['name']);
                        preferences.setString('email', updatedData['email']);
                        preferences.setString('tel1', updatedData['tel1']);
                        preferences.setString('tel2', updatedData['tel2']);
                      });
                    }
                  });
                },
                 child: Text('ユーザー情報を編集'),
               ),
            ),
          ],
        ),
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
  TextEditingController modeController = TextEditingController();

  @override
  void initState() {
    preferences = widget.preferences; // 追加
    nameController = TextEditingController(text: widget.list[widget.index]['name']);
    emailController = TextEditingController(text: widget.list[widget.index]['email']);
    tel1Controller = TextEditingController(text: widget.list[widget.index]['tel1']);
    tel2Controller = TextEditingController(text: widget.list[widget.index]['tel2']);
    modeController = TextEditingController(text: widget.list[widget.index]['mode']);
    super.initState();
  }

  void loadUserData() {
    nameController.text = widget.preferences.getString('name') ?? '';
    emailController.text = widget.preferences.getString('email') ?? '';
    tel1Controller.text = widget.preferences.getString('tel1') ?? '';
    tel2Controller.text = widget.preferences.getString('tel2') ?? '';
    modeController.text = widget.preferences.getString('mode') ?? '';
  }

  void saveUserData() {
    setState(() {
      preferences.setString('name', nameController.text);
      preferences.setString('email', emailController.text);
      preferences.setString('tel1', tel1Controller.text);
      preferences.setString('tel2', tel2Controller.text);
      preferences.setString('mode', modeController.text); // modeDataを保存

    });

    Navigator.pop(context, {
      'name': nameController.text,
      'email': emailController.text,
      'tel1': tel1Controller.text,
      'tel2': tel2Controller.text,
    });
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
                Future<void> updateData() async {
                  int userId = widget.list[widget.index]['id'] ?? 0;
                    String idValue = userId.toString();
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
                        route: '/api/update_user_fl/$userId', data: requestData,
                      );
                      setState(() {
                        preferences.setString('name', nameController.text);
                        preferences.setString('email', emailController.text);
                        preferences.setString('tel1', tel1Controller.text);
                        preferences.setString('tel2', tel2Controller.text);
                      });

                      Navigator.pop(context, {
                        'name': nameController.text,
                        'email': emailController.text,
                        'tel1': tel1Controller.text,
                        'tel2': tel2Controller.text,
                      });

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
class StopPage extends StatefulWidget {
  List list;
  int index;
  final SharedPreferences preferences;


  StopPage({required this.list, required this.index, required this.preferences});

  @override
  _StopPageState createState() => _StopPageState();
}

class _StopPageState extends State<StopPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サービス停止確認画面'),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('紛失等の為にサービスを停止しますか？'),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  updateMode(context);

                },
                child: Text('停止する'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateMode(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    int userId = widget.list[widget.index]['id'] ?? 0;
    String idValue = userId.toString();
    if (userId != null) {
      final data = {
        'id': idValue,
        'mode': '1', // モードを0から1に変更するために、'1'と指定
      };

      // モードの変更リクエストを作成
      final result = await API().postRequest(route: '/api/lost/stop/$idValue', data: data);
      final response = jsonDecode(result.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );

      // モードの変更に成功した場合、home.dartに遷移する
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        ),
      );

    } else {
      // モードの変更に失敗した場合、エラーメッセージを表示するなどの処理を行う
      print('モードの変更に失敗しました');
    }
    setState(() {
      isLoading = false;
    });
  }
}


class SuspendPage extends StatefulWidget {
  List list;
  int index;
  final SharedPreferences preferences;

  SuspendPage({required this.list, required this.index, required this.preferences});

  @override
  _SuspendPageState createState() => _SuspendPageState();
}

class _SuspendPageState extends State<SuspendPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サービス一時停止確認画面'),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('紛失等の為にサービスを一時停止しますか？'),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  updateMode(context);

                },
                child: Text('一時停止する'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateMode(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    int userId = widget.list[widget.index]['id'] ?? 0;
    String idValue = userId.toString();
    if (userId != null) {
      final data = {
        'id': idValue,
        'mode': '1', // モードを0から1に変更するために、'1'と指定
      };

      // モードの変更リクエストを作成
      final result = await API().postRequest(route: '/api/lost/suspend/$idValue', data: data);
      final response = jsonDecode(result.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
        // モードの変更に成功した場合、home.dartに遷移する
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        ),
      );
      } else {
        // モードの変更に失敗した場合、エラーメッセージを表示するなどの処理を行う
        print('モードの変更に失敗しました');
      }
    setState(() {
      isLoading = false;
    });
    }
  }

class AgainPage extends StatefulWidget {
  List list;
  int index;
  final SharedPreferences preferences;

  AgainPage({required this.list, required this.index, required this.preferences});

  @override
  _AgainPageState createState() => _AgainPageState();
}

class _AgainPageState extends State<AgainPage> {
  bool isLoading = false;
  late SharedPreferences preferences; // 追加

  TextEditingController modeController = TextEditingController();


  @override
  void initState() {
    preferences = widget.preferences; // 追加
    modeController = TextEditingController(text: widget.list[widget.index]['mode']);
    super.initState();
  }
  void loadUserData() {
    modeController.text = widget.preferences.getString('mode') ?? '';
  }
  void saveUserData() {
    setState(() {
      preferences.setString('mode', modeController.text); // modeDataを保存
    });

    Navigator.pop(context, {
      'mode': modeController.text,
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サービス再開確認画面'),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('サービスを再開しますか？'),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  updateMode(context);
                },
                child: Text('再開する'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateMode(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    int userId = widget.list[widget.index]['id'] ?? 0;
    String idValue = userId.toString();
    if (userId != null) {
      final data = {
        'id': idValue,
        'mode': '0', // モードを0から1に変更するために、'1'と指定
      };
      final Map<String, String> requestData = data.map((key, value) => MapEntry(key, value.toString()));


      // モードの変更リクエストを作成
      final result = await API().postRequest(route: '/api/lost/again/$idValue', data: data);
      final response = jsonDecode(result.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      setState(() {
        preferences.setString('mode', modeController.text);
      });
      // モードの変更に成功した場合、login.dartに遷移する
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        ),
      );
    } else {
      // モードの変更に失敗した場合、エラーメッセージを表示するなどの処理を行う
      print('モードの変更に失敗しました');
    }
  }
}



