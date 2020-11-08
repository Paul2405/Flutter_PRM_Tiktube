import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Bloc/UserBloc/UserBloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localstorage/localstorage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn ggSign = GoogleSignIn();
final LocalStorage localStore = new LocalStorage('user');


Future<String> SignInWithGG() async {
  Firebase.initializeApp();
  GoogleSignInAccount googleSignInAccount = await ggSign.signIn();

  GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  UserCredential authResult = await auth.signInWithCredential(credential);

  User user = authResult.user;

  assert(!user.isAnonymous);
  Future<String> getId() async {
    final String id = await authResult.user.getIdToken();
    print("User Name: $id");
    return id;
  }

  assert(await user.getIdToken() != null);
  String email = user.email;
  print("User Name: $email");
  getId().then((token) {
    userBloc.getUserLogin(token);
  });
  return '$user';
}

void SignOutGG() async {
  await ggSign.signOut();
  await localStore.clear();
}
