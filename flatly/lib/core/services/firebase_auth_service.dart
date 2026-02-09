import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream para saber si hay sesión activa en Firebase
  Stream<User?> get userStream => _auth.authStateChanges();

  // Login con Google
  Future<void> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      // En Web se usa signInWithPopup, en móvil se suele usar signInWithForward
      UserCredential userCredential = await _auth.signInWithPopup(
        googleProvider,
      );

      if (userCredential.user != null) {
        await _syncUserWithFirestore(userCredential.user!);
      }
    } catch (e) {
      print("Error en Firebase Auth: $e");
    }
  }

  // Sincronización con la colección de 'users' de tu compañero
  Future<void> _syncUserWithFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final snap = await userDoc.get();

    if (!snap.exists) {
      await userDoc.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        // Aquí es donde luego añadiremos tus campos personalizados
      });
    }
  }

  Future<void> signOut() => _auth.signOut();
}
