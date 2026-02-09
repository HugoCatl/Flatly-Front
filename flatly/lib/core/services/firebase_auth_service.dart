import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 1. EL TRUCO: Ponemos un alias ("social") a la librería para diferenciarla
import 'package:google_sign_in/google_sign_in.dart' as social;
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 2. Usamos el alias "social" para instanciar. 
  // Así Flutter sabe que queremos la librería oficial, no otra cosa.
  final social.GoogleSignIn _googleSignIn = social.GoogleSignIn();

  Stream<User?> get userStream => _auth.authStateChanges();

  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        await _auth.signInWithPopup(GoogleAuthProvider());
      } else {
        // --- MÓVIL (Android/iOS) ---
        // 3. Usamos el tipo con el alias para evitar confusiones
        final social.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        
        if (googleUser == null) return; // Usuario canceló

        // 4. Obtenemos la autenticación (ahora sí reconocerá el método)
        final social.GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // 5. Creamos la credencial usando los tokens oficiales
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
      }

      // Sincronizar datos si el login fue exitoso
      if (_auth.currentUser != null) {
        await _syncUserWithFirestore(_auth.currentUser!);
      }
    } catch (e) {
      print("Error en Firebase Auth: $e");
    }
  }

  Future<void> _syncUserWithFirestore(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': user.displayName,
      'email': user.email,
      'photoUrl': user.photoURL,
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }
}