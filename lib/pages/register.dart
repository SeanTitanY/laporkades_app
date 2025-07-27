import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laporkades_app/pages/verify_email.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  /// Fungsi untuk mendaftarkan pengguna baru
  Future<void> _registerUser() async {
    // Validasi input
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua kolom wajib diisi.")));
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password tidak cocok.")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Buat pengguna di Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final User? user = userCredential.user;
      if (user != null) {
        // 2. Perbarui profil di Firebase Authentication (nama & foto)
        await user.sendEmailVerification();

      // 2. Perbarui profil dan simpan ke Firestore (tetap sama)
      await user.updateProfile(displayName: _nameController.text.trim());
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': _nameController.text.trim(),
        'email': user.email,
        'createdAt': Timestamp.now(),
        'photoUrl': null,
      });

      // 3. Arahkan ke halaman verifikasi, bukan HomePage
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const VerifyEmailScreen()),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan.";
      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email ini sudah terdaftar.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Daftar Akun Baru"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: const InputDecoration(labelText: "Konfirmasi Password"),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Daftar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}