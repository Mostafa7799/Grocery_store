import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_store/const/firebase_const.dart';

import '../screens/bottom_bar.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
              GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken));
          if(authResult.additionalUserInfo!.isNewUser){
            await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
              'id': authResult.user!.uid,
              'email': authResult.user!.email,
              'name':  authResult.user!.displayName,
              'shipping address': '',
              'userWish': [],
              'userCart': [],
              'createdAt': Timestamp.now(),
            });
          }
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const BottomBarScreen(),
          ));
          print("Successes");
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              supTitle: '${error..message}', context: context);
          print(error);
        } catch (error) {
          GlobalMethods.errorDialog(supTitle: '$error', context: context);
          print(error);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Utils utils = Utils(context: context);
    Size size = utils.getScreenSize;
    final color = utils.color;
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          googleSignIn(context);
        },
        child: Row(
          children: [
            SizedBox(
              width: size.width * .009,
            ),
            Container(
              color: Colors.white30,
              width: size.width * .1,
              child: Image.asset('assets/images/google.png'),
            ),
            SizedBox(
              width: size.width * .16,
            ),
            Text(
              'Sign in with google',
              style: TextStyle(color: Colors.white, fontSize: 19),
            ),
          ],
        ),
      ),
    );
  }
}
