import 'package:flutter/material.dart';
import 'package:smart_event_explorer_frontend/apis/repository/auth/AuthRepository.dart';
import 'package:smart_event_explorer_frontend/screens/auth/LoginScreen.dart';
import 'package:smart_event_explorer_frontend/screens/splash/SplashScreen.dart';
import 'package:smart_event_explorer_frontend/theme/TextTheme.dart';
import 'package:smart_event_explorer_frontend/utils/AnimatedNavigator/AnimatedNavigator.dart';
import 'package:smart_event_explorer_frontend/widgets/SubmitButton/SubmitButton.dart';
import 'package:smart_event_explorer_frontend/widgets/TextFormField/TextFormFieldWidget.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgetPassword>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

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

  final _emailKey = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();

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
    otpController.dispose();
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
              width: size.width * 0.9,
              height: size.height * 0.20,
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
                      "Forget Password ?",
                      style: MyTextTheme.HeadingStyle(color : Colors.black),
                    ),
                    Divider(color: Colors.black),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                      ),
                      child: Column(
                        spacing: 10,
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .start,
                        children: [
                          Form(
                            key: _emailKey,
                            child: Column(
                              spacing: 5,
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
                                  suffixIcon: TextButton(
                                    onPressed: () {
                                      if (_emailKey.currentState!.validate()) {
                                        sendOTPLogic(
                                          emailController.text
                                              .toString()
                                              .trim(),
                                        );
                                      }
                                    },
                                    child: Text("Send OTP"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: _form2Key,
                            child: Column(
                              crossAxisAlignment: .start,
                              spacing: 5,
                              children: [
                                Text(
                                  "Enter 6 Digit OTP Here : ",
                                  style: MyTextTheme.NormalStyle(color : Colors.black),
                                ),
                                CustomTextFormFieldWidget(
                                  controller: otpController,
                                  isPasswordField: false,
                                  text: "OTP",
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Enter New Password Here : ",
                                  style: MyTextTheme.NormalStyle(color : Colors.black),
                                ),
                                CustomTextFormFieldWidget(
                                  controller: passwordController,
                                  isPasswordField: true,
                                  text: "New Password",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: size.width * 0.70,
                          height: size.height * 0.06,
                          child: CustomSubmitButton(
                            backgroundColor: Colors.black,
                            buttonText: "Change Password",
                            onPressed: () {
                              if (_form2Key.currentState!.validate() &&
                                  _emailKey.currentState!.validate()) {
                                resetPasswordLogic(
                                  emailController.text.toString().trim(),
                                  otpController.text.toString().trim(),
                                  passwordController.text.toString().trim(),
                                );
                              }
                            },
                          ),
                        ),
                        Container(height: 10),
                        TextButton(
                          onPressed: () async {
                            AnimatedNavigator(LoginScreen(), context);
                          },
                          child: Text("Remebered Password ?"),
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

  void sendOTPLogic(String email) async {
    Map<String, dynamic> otpSent = await Authentication.sendOTP(email);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      
        content: Text(
          otpSent['message'],
          style: MyTextTheme.NormalStyle(color : Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
    );
    if (otpSent['otpsent'] == true) {
      print(otpSent['message']);
      return;
    }
    return;
  }

  void resetPasswordLogic(String email, String otp, String password) async {
    Map<String, dynamic> resetPass = await Authentication.resetPassword(
      email,
      otp,
      password,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(backgroundColor: Colors.white,content: Text( style: MyTextTheme.NormalStyle(color : Colors.black),resetPass['message'])));

    if (resetPass['reset'] == true) {
      print("Password Changed Succesfully");
      AnimatedNavigator(SplashScreen(), context);
    }
    return;
  }
}
