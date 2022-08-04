import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/const/firebase_const.dart';
import 'package:grocery_store/fetch_screen.dart';
import 'package:grocery_store/screens/auth/login_screen.dart';
import 'package:grocery_store/screens/loading_screen.dart';
import 'package:grocery_store/services/global_methods.dart';
import 'package:grocery_store/widget/back_widget.dart';

import '../../const/contss.dart';
import '../../inner_screens/feeds_screen.dart';
import '../../services/utils.dart';
import '../../widget/auth_button.dart';
import '../bottom_bar.dart';
import 'forget_pass.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _opSecure = true;

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailController.text.toLowerCase().trim(),
            password: _passwordController.text.trim());
        final user = authInstance.currentUser;
        final uid = user!.uid;
        user.updateDisplayName(_nameController.text);
        user.reload();

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'email': _emailController.text,
          'name' : _nameController.text,
          'shipping address': _addressController.text,
          'userWish': [],
          'userCart': [],
          'createdAt': Timestamp.now(),
        });

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>  FetchScreen(),
        ));
        print('Succefully created in');

      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
          context: context,
          supTitle: '${error.message}',
        );
        setState(() {
          isLoading = false;
        });
        print(error);
      } catch (error) {
        GlobalMethods.errorDialog(supTitle: '$error', context: context);
        setState(() {
          isLoading = false;
        });
        print(error);
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
                color: Colors.black87.withOpacity(.7),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * .02,
                      ),
                      BackWidget(),
                      SizedBox(
                        height: size.height * .02,
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
                        'Sign up to contention',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: size.height * .03,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_passFocusNode),
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is messing';
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .03,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_passFocusNode),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid email address';
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                                _submitFormOnRegister();
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
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                                _submitFormOnRegister();
                              },
                              controller: _addressController,
                              focusNode: _addressFocusNode,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 10) {
                                  return 'Please enter a valid address';
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: 'Shipping address',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * .01,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ForgetPassword.routeName);
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
                        height: size.height * .01,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AuthButton(
                          textButton: "Sign up",
                          function: () {
                            _submitFormOnRegister();
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * .014,
                      ),
                      Row(
                        children: [
                          Text(
                            "Already a user?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName);
                            },
                            child: Text(
                              "Sign in",
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
