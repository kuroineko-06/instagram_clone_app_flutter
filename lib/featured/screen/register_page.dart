// ignore_for_file: prefer_const_constructors, annotate_overrides, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, avoid_print, await_only_futures, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/featured/classes/language_constaits.dart';
import 'package:instagram_clone/featured/screen/login_screen.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: 380,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "What's Your Name?",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Add a name so your friends can find you.",
                          style: TextStyle(fontSize: 15),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: name,
                        // onChanged: () {},
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText: translation(context).nameHint,
                          labelText: translation(context).name,
                        ),
                        validator: (value) {
                          if (value == "" || value!.isEmpty) {
                            return 'Invalid Name';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            value = name.text;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.blue,
                            fixedSize: Size.fromWidth(400),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              // translation(context).sign_in_button,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterPage2(name_data: name.text)));
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class RegisterPage2 extends StatefulWidget {
  final String name_data;
  const RegisterPage2({super.key, required this.name_data});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController password = TextEditingController();
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: 380,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Create password",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Create a password with at least 8 letters or numbers. You should choose a password that is difficult to guess.",
                          style: TextStyle(fontSize: 15),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: password,
                        // onChanged: () {},
                        //obscuringCharacter: "*",
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    const SizedBox(height: 20),
                    Container(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.blue,
                            fixedSize: Size.fromWidth(400),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              // translation(context).sign_in_button,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage3(
                                            password_data: password.text,
                                            nameData: widget.name_data,
                                          )));
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class RegisterPage3 extends StatefulWidget {
  final String password_data;
  final String nameData;
  const RegisterPage3(
      {super.key, required this.password_data, required this.nameData});

  State<RegisterPage3> createState() => _RegisterPage3State();
}

@override
class _RegisterPage3State extends State<RegisterPage3> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateOfBirth = TextEditingController();

  // int calculateAge(DateTime birthDate) {
  //   DateTime currentDate = DateTime.now();
  //   int age = currentDate.year - birthDate.year;
  //   if (birthDate.month > currentDate.month) {
  //     age--;
  //   } else if (currentDate.month == birthDate.month) {
  //     if (birthDate.day > currentDate.day) {
  //       age--;
  //     }
  //   }
  //   return age;
  // }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (birthDate.month > currentDate.month) {
      age--;
    } else if (currentDate.month == birthDate.month) {
      if (birthDate.day > currentDate.day) {
        age--;
      }
    }
    return age;
  }

  void initState() {
    dateOfBirth.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: 380,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "When is your date of birth?",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Use your own birthday, even if the account is for a business, pet, or other topic. This information will not be visible to anyone unless you choose to share it.",
                          style: TextStyle(fontSize: 15),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(right: 15, left: 2),
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        child: TextFormField(
                          style: TextStyle(color: primaryColor),
                          controller:
                              dateOfBirth, //editing controller of this TextField
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: primaryColor),
                            icon: Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: primaryColor,
                            ),
                            labelText:
                                "Enter Date Of Birth", //label text of field
                          ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter date';
                            }
                            if (calculateAge(
                                    DateFormat("dd-MM-yyyy").parse(value)) <
                                16) {
                              return "The required age is 16 year old!";
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(
                                    1900), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2040));
                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement
                              setState(() => dateOfBirth.text = formattedDate);
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.blue,
                            fixedSize: Size.fromWidth(400),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              // translation(context).sign_in_button,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage4(
                                          dateData: dateOfBirth.text,
                                          password_data: widget.password_data,
                                          nameData: widget.nameData)));
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class RegisterPage4 extends StatefulWidget {
  final String dateData;
  final String password_data;
  final String nameData;

  const RegisterPage4(
      {super.key,
      required this.dateData,
      required this.password_data,
      required this.nameData});

  @override
  State<RegisterPage4> createState() => _RegisterPage4State();
}

class _RegisterPage4State extends State<RegisterPage4> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _image;

  void _selectedImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: 380,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Set Your Photo",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Put a photo so everyone can know who you are.",
                          style: TextStyle(fontSize: 15),
                        )),
                    const SizedBox(
                      height: 120,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 80,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : InkWell(
                                onTap: () => _selectedImage(),
                                splashColor: Colors.transparent,
                                child: const CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(
                                      "https://as2.ftcdn.net/v2/jpg/02/15/84/43/1000_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"),
                                ),
                              ),
                        Positioned(
                            bottom: double.minPositive,
                            left: 110,
                            child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) => RadialGradient(
                                center: Alignment.centerRight,
                                stops: [.8, 3],
                                colors: [
                                  Color.fromARGB(255, 70, 254, 3),
                                  Color.fromARGB(255, 242, 11, 11),
                                ],
                              ).createShader(bounds),
                              child: IconButton(
                                  onPressed: _selectedImage,
                                  icon: const Icon(
                                    Icons.add_a_photo_sharp,
                                    size: 30,
                                  )),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                    Container(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.blue,
                            fixedSize: Size.fromWidth(400),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              // translation(context).sign_in_button,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => _image != null
                                        ? RegisterPage5(
                                            dateData: widget.dateData,
                                            password_data: widget.password_data,
                                            nameData: widget.nameData,
                                            imageData: _image!,
                                            //email_data: email.text,
                                          )
                                        : AlertDialog(
                                            title: Text('Error'),
                                            content:
                                                Text("The image isn't empty"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('OK'))
                                            ],
                                          )));
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class RegisterPage5 extends StatefulWidget {
  final String dateData;
  final String password_data;
  final String nameData;
  final Uint8List imageData;

  const RegisterPage5(
      {super.key,
      required this.dateData,
      required this.password_data,
      required this.nameData,
      required this.imageData});

  @override
  State<RegisterPage5> createState() => _RegisterPage5State();
}

class _RegisterPage5State extends State<RegisterPage5> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: 380,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "What's Your Email?",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Enter an email that can be used to contact you. This information will not be visible to anyone else on your profile.",
                          style: TextStyle(fontSize: 15),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: TextFormField(
                          controller: email,
                          // onChanged: () {},
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: translation(context).emailHint,
                            labelText: translation(context).email,
                          ),
                          onFieldSubmitted: (value) {
                            setState(() {
                              value = email.text;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Invalid Email!!!";
                            }
                            if (!value.contains('@')) {
                              return "The email address must have '@'";
                            }
                          }),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.blue,
                            fixedSize: Size.fromWidth(400),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              // translation(context).sign_in_button,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage6(
                                            dateData: widget.dateData,
                                            password_data: widget.password_data,
                                            nameData: widget.nameData,
                                            email_data: email.text,
                                            imageData: widget.imageData,
                                          )));
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class RegisterPage6 extends StatefulWidget {
  final String dateData;
  final String password_data;
  final String nameData;
  final String email_data;
  final Uint8List imageData;
  const RegisterPage6(
      {super.key,
      required this.dateData,
      required this.password_data,
      required this.nameData,
      required this.email_data,
      required this.imageData});

  @override
  State<RegisterPage6> createState() => _RegisterPage6State();
}

class _RegisterPage6State extends State<RegisterPage6> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  late TextEditingController email, password, name, dateOfBirth;

  @override
  void initState() {
    super.initState();
    email = TextEditingController(text: widget.email_data);
    password = TextEditingController(text: widget.password_data);
    name = TextEditingController(text: widget.nameData);
    dateOfBirth = TextEditingController(text: widget.dateData);
  }

  Future<void> registerUser(
      String name_data, email_data, password_data, date_data) async {
    var baseUrl = "https://65b35d69770d43aba4799b17.mockapi.io/api/user";

    try {
      Map list = {
        "name": name_data,
        "email": email_data,
        "password": password_data,
        "dateOfBirth": date_data,
      };
      print(list);
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(list),
      );
      print("list: $list");
      print("data_response: " + response.body);

      if (response.statusCode == 201) {
        //print('User registered successfully');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Register complete!!!")));
        await Future.delayed(Duration(seconds: 2));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      } else {
        // Handle error response
        print('POST request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Failed to register user');
      }
    } catch (e) {
      // Handle network-related errors
      print('Error: $e');
      throw Exception('Network error');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: 380,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Check Your Information",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Please make sure the information above is correct. Then, click the button below to finish the registration process.",
                          style: TextStyle(fontSize: 15),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                            labelText: translation(context).name),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                            labelText: translation(context).email),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: password,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: translation(context).password,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: dateOfBirth,
                        decoration: InputDecoration(labelText: "Date Of Birth"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? Center(
                            child: const CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Container(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  backgroundColor: Colors.blue,
                                  fixedSize: Size.fromWidth(400),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: Center(
                                  child: Text(
                                    "Next",
                                    // translation(context).sign_in_button,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  // registerUser(name.text, email.text, password.text,
                                  //     dateOfBirth.text);
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  String res = await AuthMethods().signUpUser(
                                    email: email.text,
                                    password: password.text,
                                    name: name.text,
                                    dateOfBirth: dateOfBirth.text,
                                    file: widget.imageData,
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  print(res);
                                  if (res != 'success') {
                                    showSnackBar(res, context);
                                  } else {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ResponsiveLayout(
                                                  mobileScreenLayout:
                                                      MobileScreenLayout(),
                                                  webScreenLayout:
                                                      WebScreenLayout(),
                                                )));
                                  }
                                }),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
