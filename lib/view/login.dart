import 'package:flutter/material.dart';
import 'package:may_protect/Controllers/databasehelper.dart';
import 'package:may_protect/view/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState  createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final Color secondaryTextColor = Colors.grey;


  Future<void> read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? '';
    if(value != '0'){
      Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => new Dashboard(title: 'Dashboard'),
          )
      );
    }
  }

  @override
  initState(){
    read();
  }




  DatabaseHelper databaseHelper = new DatabaseHelper();
  String msgStatus = '';

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();


  _onPressed(){
    setState(() {
      if(_emailController.text.trim().toLowerCase().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty ){
        databaseHelper.loginData(_emailController.text.trim().toLowerCase(),
            _passwordController.text.trim()).whenComplete((){
          if(databaseHelper.status){
            _showDialog();
            msgStatus = 'Check email or password';
          }else{
            Navigator.pushReplacementNamed(context, '/dashboard');


          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        appBar: AppBar(
          title:  Text('Login'),
        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(top: 62,left: 12.0,right: 12.0,bottom: 12.0),
            children: <Widget>[
              Container(
                height: 50,
                child: new TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'メールアドレスを入力してください',
                    icon: new Icon(Icons.email),
                  ),
                ),
              ),

              Container(
                height: 50,
                child: new TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'パスワードを入力してください',
                    icon: new Icon(Icons.vpn_key),
                  ),
                ),
              ),
              new Padding(padding: new EdgeInsets.only(top: 44.0),),

              Container(
                height: 50,
                child: TextButton(
                  onPressed: _onPressed,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: new Text(
                    'Login',
                    style: new TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.blue),),
                ),
              ),
              new Padding(padding: new EdgeInsets.only(top: 44.0),),

              Container(
                height: 50,
                child: new Text(
                  '$msgStatus',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new Padding(padding: new EdgeInsets.only(top: 44.0),),
              Row(
                children: [
                  Text(
                    'Your first time?',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 4), // スペーサーウィジェットの追加
                  InkWell(
                    onTap: () {
                      _launchURL();
                    },
                    child: const Text(
                      '新規登録はこちらから',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



  void _showDialog(){
    showDialog(
        context:context ,
        builder:(BuildContext context){
          return AlertDialog(
            title: new Text('Failed'),
            content:  new Text('Check your email or password'),
            actions: <Widget>[
              ElevatedButton(

                child: new Text(
                  'Close',
                ),

                onPressed: (){
                  Navigator.of(context).pop();
                },

              ),
            ],
          );
        }
    );
  }

  void _launchURL() async {
    const url = 'https://itcha50.com/register';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



}














