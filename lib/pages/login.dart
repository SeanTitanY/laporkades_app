import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laporkades_app/pages/home.dart'; // Ganti dengan halaman utama Anda
import 'package:laporkades_app/pages/register.dart'; // Ganti dengan halaman registrasi Anda
import 'package:laporkades_app/pages/izin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleSuccessfulLogin(User user) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    // Cek apakah field 'hasAgreedToPermissions' ada dan bernilai true
    if (userDoc.exists && userDoc.data()?['hasAgreedToPermissions'] == true) {
      // Jika sudah pernah setuju, langsung ke HomePage
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } else {
      // Jika pengguna baru atau belum pernah setuju, ke PermissionScreen
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PermissionScreen()));
      }
    }
  }

  /// Fungsi untuk mengirim email reset password
  Future<void> _resetPassword(String email) async {
    // Tutup dialog terlebih dahulu
    Navigator.of(context).pop();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan alamat email Anda untuk reset password.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Link reset password telah dikirim ke email Anda.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengirim email: ${e.message}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Fungsi untuk menangani login dengan Email & Password
  Future<void> _signInWithEmailAndPassword() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email dan password tidak boleh kosong.")));
      return;
    }
    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Panggil handler setelah login berhasil
      if (userCredential.user != null) {
        await _handleSuccessfulLogin(userCredential.user!);
      }
    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan.";
      if (e.code == 'invalid-credential' || e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = "Email atau password salah.";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Fungsi untuk menangani login dengan Google
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Login dibatalkan');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) throw Exception('Gagal mendapatkan data pengguna dari Firebase.');

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
          'createdAt': Timestamp.now(),
          'hasAgreedToPermissions': false, // Pengguna baru belum setuju
        });
      }

      // Panggil handler setelah login berhasil
      await _handleSuccessfulLogin(user);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal masuk: ${e.toString()}")));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              // Logo dan Teks Selamat Datang
              // Ganti Text widget dengan Image.asset
              Image.asset(
                'assets/icons/appLogoNoBg.png', // Sesuaikan path dan nama file logo Anda
                height: 100, // Atur tinggi logo sesuai kebutuhan
              ),
              const SizedBox(height: 24),
              const Text("Selamat datang di LaporKades 👋", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                "Aplikasi layanan pengaduan masyarakat Desa Tegal Rejo",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              
              // Tombol Masuk dengan Google
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _signInWithGoogle,
                icon: Image.asset('assets/icons/google_logo.png', height: 20), // Pastikan ada logo google di aset
                label: const Text("Masuk dengan Google", style: TextStyle(color: Colors.black)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              
              // Divider "atau"
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("atau", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              
              // Form Email & Password
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Username/Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Tombol Masuk
              ElevatedButton(
                onPressed: _isLoading ? null : _signInWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Masuk"),
              ),
              const SizedBox(height: 16),
              
              // Link Lupa Password
              // Link Lupa Password
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    // Tampilkan dialog saat tombol ditekan
                    showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController resetEmailController = TextEditingController();
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          title: const Text("Reset Password"),
                          content: TextField(
                            controller: resetEmailController,
                            decoration: const InputDecoration(hintText: "Masukkan email terdaftar"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Batal"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              child: const Text("Kirim"),
                              onPressed: () {
                                _resetPassword(resetEmailController.text);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Lupa Password?"),
                ),
              ),
              const SizedBox(height: 32),
              
              // Link Daftar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text("Daftar di sini."),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}