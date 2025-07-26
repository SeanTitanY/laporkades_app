import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laporkades_app/pages/home.dart'; // Ganti dengan halaman utama Anda
import 'package:laporkades_app/pages/register.dart'; // Ganti dengan halaman registrasi Anda

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

  /// Fungsi untuk menangani login dengan Email & Password
  Future<void> _signInWithEmailAndPassword() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password tidak boleh kosong.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Jika berhasil, navigasi ke halaman utama
      if (mounted) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => const HomeScreen()),
        // );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan.";
      if (e.code == 'invalid-credential') {
        message = "Email atau password salah.";
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = "Email atau password salah.";
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
  setState(() => _isLoading = true);
  
  try {
    // 1. Lakukan proses login dengan Google
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Login dibatalkan');

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 2. Login ke Firebase Authentication
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user == null) throw Exception('Gagal mendapatkan data pengguna dari Firebase.');

    // --- LOGIKA SIMPAN KE FIRESTORE ---

    // 3. Dapatkan referensi ke dokumen pengguna di Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDocRef = firestore.collection('users').doc(user.uid);

    final doc = await userDocRef.get();

    // 4. Jika dokumen tidak ada (pengguna baru), buat profilnya
    if (!doc.exists) {
      await userDocRef.set({
        'username': user.displayName, // Ambil nama dari akun Google
        'email': user.email,
        'photoUrl': user.photoURL, // Ambil URL foto dari akun Google
        'createdAt': Timestamp.now(),
      });
    }
    
    // 5. Navigasi ke halaman utama setelah login berhasil
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }

  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal masuk: ${e.toString()}")),
      );
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
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () { /* TODO: Logika Lupa Password */ },
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