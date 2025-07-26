import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:laporkades_app/pages/login.dart'; // Sesuaikan path ke halaman login

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  // Fungsi untuk melakukan log out
  Future<void> _signOut(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("Error saat log out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data pengguna yang sedang login
    final User? user = FirebaseAuth.instance.currentUser;
    // Gunakan nama dari profil, atau 'Warga' jika tidak ada
    final String username = user?.displayName ?? 'Warga';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profil", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Bagian Header ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hai,",
                  style: TextStyle(fontSize: 22, color: Colors.black54),
                ),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- Opsi Menu ---
          _buildOptionListTile(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi LaporKades',
            onTap: () { /* TODO: Navigasi ke halaman Tentang */ },
          ),
          _buildOptionListTile(
            icon: Icons.description_outlined,
            title: 'Syarat dan Ketentuan',
            onTap: () { /* TODO: Navigasi ke halaman Syarat & Ketentuan */ },
          ),
          _buildOptionListTile(
            icon: Icons.shield_outlined,
            title: 'Kebijakan Privasi',
            onTap: () { /* TODO: Navigasi ke halaman Kebijakan Privasi */ },
          ),
          
          const Divider(height: 32),
          
          // --- Tombol Keluar ---
          _buildOptionListTile(
            icon: Icons.logout,
            title: 'Keluar',
            color: Colors.red,
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat setiap baris opsi
  Widget _buildOptionListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}