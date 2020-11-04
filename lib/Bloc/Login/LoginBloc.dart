import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn ggSign = GoogleSignIn();

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

  assert(await user.getIdToken() != null);

  return '$user';
}

void SignOutGG() async {
  await ggSign.signOut();
}
