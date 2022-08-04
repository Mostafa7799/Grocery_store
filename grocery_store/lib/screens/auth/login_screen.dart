import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/fetch_screen.dart';
import 'package:grocery_store/inner_screens/feeds_screen.dart';
import 'package:grocery_store/screens/auth/forget_pass.dart';
import 'package:grocery_store/screens/auth/register_screen.dart';
import 'package:grocery_store/screens/bottom_bar.dart';
import 'package:grocery_store/screens/loading_screen.dart';
import 'package:grocery_store/widget/auth_button.dart';
import 'package:grocery_store/widget/google_button.dart';

import '../../const/contss.dart';
import '../../const/firebase_const.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _opSecure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool isLoading = false;

  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailController.text.toLowerCase().trim(),
            password: _passwordController.text.trim());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));
        print('Succefully logged in');
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
             context: context,supTitle: '${error.message}',);
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(supTitle: '$error', context: context);
        setState(() {
          isLoading = false;
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Utils utils = Utils(context: context);
    Size size = utils.getScreenSize;
    final color = utils.color;
    return Scaffold(
      body: Material(
        child: LoadingScreen(
          isLoading: isLoading,
          child: Stack(
            children: [
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Consts.authImages[index],
                    fit: BoxFit.fill,
                  );
                },
                duration: 800,
                autoplayDelay: 6000,
                itemCount: Consts.authImages.length,
                autoplay: true,
              ),
              Container(
                color: Colors.black87.withOpacity(.6),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * .06,
                      ),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: size.height * .004,
                      ),
                      Text(
                        'Sign in to contention',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: size.height * .05,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_passFocusNode),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid email address';
                                } else {}
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle:
                                    TextStyle(color: Colors.white, fontSize: 20),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .03,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                _submitFormOnLogin();
                              },
                              controller: _passwordController,
                              focusNode: _passFocusNode,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _opSecure,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return 'Please enter a valid password';
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _opSecure = !_opSecure;
                                    });
                                  },
                                  child: _opSecure
                                      ? Icon(
                                          Icons.visibility,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Colors.white,
                                        ),
                                ),
                                hintText: 'Password',
                                hintStyle:
                                    TextStyle(color: Colors.white, fontSize: 20),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * .015,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, ForgetPassword.routeName);
                          },
                          child: Text(
                            "Forget password?",
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 19,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * .03,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AuthButton(
                          textButton: "Login",
                          function: () {
                            _submitFormOnLogin();
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * .012,
                      ),
                      GoogleButton(),
                      SizedBox(
                        height: size.height * .012,
                      ),
                      Row(
                        children:   [
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                          SizedBox(width: size.width*.01,),
                          Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: size.width*.01,),
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * .003,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AuthButton(
                          textButton: "Contention as a guest",
                          function: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FetchScreen(),
                                ));
                          },
                            primary: Colors.black87,
                        ),
                      ),
                      SizedBox(
                        height: size.height * .025,
                      ),
                      Row(
                        children: [
                          Text(
                            "Don't have any account?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RegisterScreen.routeName);
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 21,
                              ),
                            ),
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
      ),
    );
  }
}
