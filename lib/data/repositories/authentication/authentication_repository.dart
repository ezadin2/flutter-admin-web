import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../routes/routes.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuthenthicationRepository extends GetxController{
  static AuthenthicationRepository get instance => Get.find();
  //Firebase Auth Instance
final _auth = FirebaseAuth.instance;

//Get Authentcated User Data
User? get autheUser => _auth.currentUser;
//Get Autheticated User
bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {
    super.onReady();
    _auth.setPersistence(Persistence.LOCAL);
  }

  //Function to determin the relevant

  void screenRedirect() async{
    final user = _auth.currentUser;
    //if the user is logged in

    if (user !=null) {
      Get.offAllNamed(TRoutes.dashboard);

    }
    else{
      Get.offAllNamed(TRoutes.login);
    }
  }
//Function to determine the relevant screen and redirect accordingly

//

//login
Future<UserCredential> loginWithEmailAndPassword(String email,String password) async{
    try{
 return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    }on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch(e){
      throw TFormatException();
    }on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    }catch(e){
      throw 'something  went wrong pls check $e';
    }
}

//Register

  Future<UserCredential> registerWithEmailAndPassword(String email,String password) async{
    try{
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    }on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch(e){
      throw TFormatException();
    }on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    }catch(e){
      throw 'something  went wrong pls check $e';
    }
  }

//Register User By Admin


//Email Verifications


//Forget Password


//RE Authenticaticate User


//Logout user
Future<void> logout() async {
  try{
await FirebaseAuth.instance.signOut();
Get.offAllNamed(TRoutes.login);
  } on FirebaseAuthException catch(e){
    throw TFirebaseAuthException(e.code).message;
  }on FirebaseException catch(e){
    throw TFirebaseException(e.code).message;
  }on FormatException catch(e){
    throw TFormatException();
  }on PlatformException catch(e){
    throw TPlatformException(e.code).message;
  }catch(e){
    throw 'something  went wrong pls check $e';
  }
}

// In AuthenthicationRepository class
  Future<void> deleteUser(String id) async {
    try {
      // Get the user to delete
      final user = _auth.currentUser;
      if (user != null && user.uid == id) {
        await user.delete();
      } else {
        // If trying to delete another user, you might need admin privileges
        // or use Firebase Admin SDK on your backend
        throw 'You can only delete your own account';
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }
}