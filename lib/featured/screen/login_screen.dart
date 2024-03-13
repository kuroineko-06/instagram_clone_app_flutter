// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/featured/classes/language.dart';
import 'package:instagram_clone/featured/classes/language_constaits.dart';
import 'package:instagram_clone/featured/screen/register_page.dart';
import 'package:instagram_clone/main.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void Login() async {
    if (_formKey.currentState!.validate()) {
      try {
        var url = 'https://65b35d69770d43aba4799b17.mockapi.io/api/user';
        var response = await http.get(
          Uri.parse(url),
        );
        print(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          final List<dynamic> dataList = jsonDecode(response.body);
          for (var data in dataList) {
            String user_data = data['email'];
            String user_pass = data['password'];
            print('email: $user_data, pass: $user_pass');
            if (email.text == user_data && password.text == user_pass) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Login complete!!")));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MobileScreenLayout()));
              break;
            } else if (email.text != user_data || password.text != user_pass) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Login faild!!")));
            }
          }
        } else {
          print('error');
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
      }
      ;
    }
  }

  void loginUserAuth() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods()
        .loginUser(email: email.text, password: password.text);
    if (res == "success") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  )));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(top: 8),
          height: 100,
          width: 100,
          child: SvgPicture.asset(
            'assets/images/Instagram_logo.svg',
            height: 30,
            width: 30,
            color: primaryColor,
            semanticsLabel: 'My SVG Image',
          ),
        ),
        centerTitle: true,
        actions: [
          DropdownButton<Language>(
              padding: EdgeInsets.only(top: 8, right: 10),
              // hint: Text(translation(context).language),
              underline: SizedBox(),
              icon: const Icon(
                Icons.language,
                size: 25,
              ),
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                          value: e,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text(e.name)],
                          )))
                  .toList(),
              onChanged: (Language? language) async {
                if (language != null) {
                  Locale _locale = await setLocale(language.languageCode);
                  MyApp.setLocale(context, _locale);
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 10),
            height: 600,
            width: 350,
            child: Column(children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 50),
                        height: 60,
                        width: 60,
                        child: Image(
                            image: AssetImage(
                                "assets/images/logo_instargram.png")),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            labelText: translation(context).email,
                            isDense: true,
                            hintText: translation(context).emailHint,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (value) {
                            setState(() {
                              email.text = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return "Invalid Email!!!";
                            }
                            ;
                          },
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: password,
                          // onChanged: () {},
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: translation(context).passwordHint,
                            labelText: translation(context).password,
                            isDense: true,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid Password!';
                            }
                            if (value.length < 8) {
                              return 'Password should have more 8 characters';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              value = password.text;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  fixedSize: Size.fromWidth(400),
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                ),
                                child: Center(
                                  child: Text(
                                    translation(context).sign_in_button,
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ),
                                onPressed: () {
                                  loginUserAuth();
                                }),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: TextButton(
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              foregroundColor: Colors.white,
                              fixedSize: Size.fromWidth(400),
                            ),
                            child: Center(
                              child: Text(
                                "Forgot account?",
                                // translation(context).sign_in_button,
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            onPressed: () {
                              // Login();
                            }),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        margin: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size.fromWidth(400),
                              padding: EdgeInsets.symmetric(vertical: 13),
                            ),
                            child: Center(
                              child: Text(
                                "Create new account",
                                // translation(context).sign_in_button,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            }),
                      ),
                    ],
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
