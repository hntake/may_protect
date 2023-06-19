import 'dart:convert';

import 'package:may_protect/helper/constant.dart';
import 'package:may_protect/screens/home.dart';
import 'package:may_protect/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../methods/api.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> saveToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', token);
  }

  void loginUser() async {
    final data = {
      'email': email.text.toString(),
      'password': password.text.toString(),
    };
    final result = await API().postRequest(route: '/login', data: data);
    final response = jsonDecode(result.body);
    if (response['status'] == 200) {
      // トークンを保存
      String token = response['token'];
      await saveToken(token);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('id', response['lost']['id']);
      await preferences.setString('name', response['lost']['name']);
      await preferences.setString('email', response['lost']['email']);
      await preferences.setString('tel1', response['lost']['tel1']);
      await preferences.setString('tel2', response['lost']['tel2']);
      await preferences.setInt('mon1', int.parse(response['lost']['mon1']));
      await preferences.setInt('mon2', int.parse(response['lost']['mon2']));
      await preferences.setInt('mon3', int.parse(response['lost']['mon3']));
      await preferences.setInt('tue1', int.parse(response['lost']['tue1']));
      await preferences.setInt('tue2', int.parse(response['lost']['tue2']));
      await preferences.setInt('tue3', int.parse(response['lost']['tue3']));
      await preferences.setInt('wed1', int.parse(response['lost']['wed1']));
      await preferences.setInt('wed2', int.parse(response['lost']['wed2']));
      await preferences.setInt('wed3', int.parse(response['lost']['wed3']));
      await preferences.setInt('thu1', int.parse(response['lost']['thu1']));
      await preferences.setInt('thu2', int.parse(response['lost']['thu2']));
      await preferences.setInt('thu3', int.parse(response['lost']['thu3']));
      await preferences.setInt('fri1', int.parse(response['lost']['fri1']));
      await preferences.setInt('fri2', int.parse(response['lost']['fri2']));
      await preferences.setInt('fri3', int.parse(response['lost']['fri3']));
      await preferences.setInt('sat1', int.parse(response['lost']['sat1']));
      await preferences.setInt('sat2', int.parse(response['lost']['sat2']));
      await preferences.setInt('sat3', int.parse(response['lost']['sat3']));
      await preferences.setInt('sun1', int.parse(response['lost']['sun1']));
      await preferences.setInt('sun2', int.parse(response['lost']['sun2']));
      await preferences.setInt('sun3', int.parse(response['lost']['sun3']));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              primaryColor,
              secondaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spancer(h: height * 0.1),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    spancer(
                      w: width * 0.05,
                    ),
                    Container(
                      width: width * 0.5,
                      child: const Text(
                        'お守りバッジ - may protect you',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                spancer(
                  h: height * 0.15,
                ),
                InputField(
                  width: width,
                  controller: email,
                  hintText: 'メールアドレス',
                ),
                spancer(
                  h: height * 0.01,
                ),
                InputField(
                  width: width,
                  controller: password,
                  hintText: 'パスワード',
                  isObscure: true,
                ),
                spancer(
                  h: height * 0.03,
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: InkWell(
                    onTap: () {
                      _launchURL2();
                    },
                    child: const Text(
                      'パスワードを忘れましたか？',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),

                spancer(
                  h: height * 0.1,
                ),
                InkWell(
                  onTap: () {
                    loginUser();
                  },
                  child: Container(
                    width: double.maxFinite,
                    alignment: Alignment.centerRight,
                    padding: spacing(
                      h: 20,
                    ),
                    child: Container(
                        width: width * 0.3,
                        padding: spacing(
                          h: 20,
                          v: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child:Text(
                                'ログイン',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_right_alt_rounded,
                              color: primaryColor,
                            )
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Row(
                  children: [
                    Text(
                      'Your first time?',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 18,
                      ),
                    ),
                    spancer(w: 4),
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
      ),
    );
  }
}

void _launchURL() async {
  const url = 'https://itcha50.com/register';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
void _launchURL2() async {
  const url = 'https://itcha50.com/password/reset';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

