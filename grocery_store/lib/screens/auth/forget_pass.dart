import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_store/const/firebase_const.dart';
import 'package:grocery_store/screens/loading_screen.dart';
import 'package:grocery_store/services/global_methods.dart';
import 'package:grocery_store/widget/auth_button.dart';

import '../../const/contss.dart';
import '../../services/utils.dart';
import '../../widget/back_widget.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = '/ForgetPassword';

  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    super.dispose();
  }

  bool loading = false;

  void _forgetPass() async {
    if (_emailController.text.isEmpty) {
      GlobalMethods.errorDialog(
          context: context, supTitle: 'Please enter a correct email');
    } else {
      setState(() {
        loading = true;
      });
      try {
        await authInstance.sendPasswordResetEmail(
            email: _emailController.text.toLowerCase());
        Fluttertoast.showToast(
            msg: "An email has been sent",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
          context: context,
          supTitle: '${error.message}',
        );
        setState(() {
          loading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(supTitle: '$error', context: context);
        setState(() {
          loading = false;
        });
      } finally {
        setState(() {
          loading = false;
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
          isLoading: loading,
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
                        height: size.height * .05,
                      ),
                      BackWidget(),
                      SizedBox(
                        height: size.height * .037,
                      ),
                      Text(
                        'Forget Password',
                        style: TextStyle(
                            fontSize: 27,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: size.height * .03,
                      ),
                      Column(
                        children: [
                          TextField(
                            textInputAction: TextInputAction.next,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Email address',
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
                          SizedBox(
                            width: double.infinity,
                            child: AuthButton(
                              textButton: 'Reset password',
                              function: () {
                                _forgetPass();
                              },
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
