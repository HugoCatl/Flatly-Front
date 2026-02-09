import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseAuthService {
  // Instancias privadas
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); // <-- CORRECCIÓN: Instanciamos aquí

  // Stream para el AuthWrapper
  Stream<User?> get userStream => _auth.authStateChanges();

  // Método de Login
  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // --- WEB ---
        await _auth.signInWithPopup(GoogleAuthProvider());
      } else {
        // --- MÓVIL (Android/iOS) ---
        // Usamos la instancia _googleSignIn que creamos arriba
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        // Si el usuario cancela el login, googleUser será null
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
      }

      // Sincronizar datos si todo salió bien
      if (_auth.currentUser != null) {
        await _syncUserWithFirestore(_auth.currentUser!);
      }
    } catch (e) {
      print("Error en Firebase Auth: $e");
    }
  }

  // Sincronización con Firestore
  Future<void> _syncUserWithFirestore(User user) async {
    final userRef = _firestore.collection('users').doc(user.uid);

    await userRef.set({
      'uid': user.uid,
      'name': user.displayName,
      'email': user.email,
      'photoUrl': user.photoURL,
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Cerrar sesión
  Future<void> signOut() async {
    // Si estamos en móvil, cerramos sesión de Google también para poder cambiar de cuenta
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }
}
