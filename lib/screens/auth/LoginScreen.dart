import 'package:flutter/material.dart';
import 'package:smart_event_explorer_frontend/apis/repository/auth/AuthRepository.dart';
import 'package:smart_event_explorer_frontend/screens/auth/ForgetPassword.dart';
import 'package:smart_event_explorer_frontend/screens/auth/SignUpScreen.dart';
import 'package:smart_event_explorer_frontend/screens/splash/SplashScreen.dart';
import 'package:smart_event_explorer_frontend/theme/TextTheme.dart';
import 'package:smart_event_explorer_frontend/utils/AnimatedNavigator/AnimatedNavigator.dart';
import 'package:smart_event_explorer_frontend/widgets/SubmitButton/SubmitButton.dart';
import 'package:smart_event_explorer_frontend/widgets/TextFormField/TextFormFieldWidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation =
      Tween<Offset>(
        begin: const Offset(0.0, 2.0),
        end: const Offset(0.0, 0.1),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      );

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller.reset();
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          children: [
            Image.asset(
              "lib/assets/images/app_name_light.png",
              width: size.width * 0.7,
              height: size.height * 0.15,
            ),

            SlideTransition(
              position: _offsetAnimation,
              child: Container(
                height: size.height * 0.70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: .circular(20),
                    topRight: .circular(20),
                  ),
                ),

                child: Column(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    Text(
                      "Login Here !",
                      style: MyTextTheme.HeadingStyle(color : Colors.black),
                    ),
                    Divider(color: Colors.black),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: .center,
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              "Enter Your Email Here : ",
                              style: MyTextTheme.NormalStyle(color : Colors.black),
                            ),
                            CustomTextFormFieldWidget(
                              controller: emailController,
                              isPasswordField: false,
                              text: "Your Email",
                            ),
                            Container(height: 10),
                            Text(
                              "Enter Your Password Here : ",
                              style: MyTextTheme.NormalStyle(color : Colors.black),
                            ),
                            CustomTextFormFieldWidget(
                              controller: passwordController,
                              isPasswordField: true,
                              text: "Your Password",
                            ),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Container(),
                                TextButton(
                                  onPressed: () async {
                                    AnimatedNavigator(
                                      ForgetPassword(),
                                      context,
                                    );
                                  },
                                  child: Text("Forgot Password ?"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: size.width * 0.70,
                          height: size.height * 0.06,
                          child: CustomSubmitButton(
                            backgroundColor: Colors.black,
                            buttonText: "Login",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                loginLogic(
                                  emailController.text.toString().trim(),
                                  passwordController.text.toString().trim(),
                                );
                              }
                            },
                          ),
                        ),
                        Container(height: 10),
                        TextButton(
                          onPressed: () async {
                            AnimatedNavigator(SignUpScreen(), context);
                          },
                          child: Text("Don't Have Any Account ?"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginLogic(String email, String password) async {
    Map<String, dynamic> login = await Authentication.login(email, password);

    if (login['login'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Loggin Successfull",
            style: MyTextTheme.NormalStyle(color : Colors.black),
          ),
        ),
      );
      AnimatedNavigator(SplashScreen(), context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            style: MyTextTheme.NormalStyle(color : Colors.black),
            "${login['message']}",
          ),
        ),
      );
      return;
    }
  }
}
