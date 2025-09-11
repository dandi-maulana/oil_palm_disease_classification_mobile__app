// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
        backgroundColor: const Color(0xFF1e3a8a), // Biru tua
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Bagian Pengantar & Misi ---
            Card(
              elevation: 4,
              color: Colors.blue[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Tentang Tim ANUGRAH',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1e3a8a),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Kami adalah tim yang berdedikasi untuk memberdayakan petani kelapa sawit melalui teknologi AI. Misi kami adalah menyediakan alat bantu yang mudah digunakan, akurat, dan dapat diandalkan untuk deteksi penyakit daun secara dini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- Bagian Dosen Pembimbing ---
            const Text(
              'Dosen Pembimbing',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Divider(height: 20, thickness: 1),
            _buildProfileListCard(
              imagePath: 'assets/images/pembimbing.jpeg',
              name: 'Muhathir, S.T., M.Kom',
              role: 'Dosen Pembimbing',
              description: 'Dosen S1 Teknik Informatika',
            ),
            const SizedBox(height: 30),

            // --- Bagian Tim Pengembang ---
            const Text(
              'Tim Pengembang',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Divider(height: 20, thickness: 1),
            _buildProfileListCard(
              imagePath: 'assets/images/ketua.jpeg',
              name: 'Nugraha Rahmadan Diyanto',
              role: 'Ketua Tim',
              description: 'Mahasiswa S1 Teknik Informatika',
            ),
            _buildProfileListCard(
              imagePath: 'assets/images/anggota1.jpeg',
              name: 'Stevi Freshia Sihombing',
              role: 'Anggota',
              description: 'Mahasiswi S1 Teknik Informatika',
            ),
            _buildProfileListCard(
              imagePath: 'assets/images/anggota2.jpeg',
              name: 'M.Rizky Aulia Hrp',
              role: 'Anggota',
              description: 'Mahasiswa S1 Teknik Informatika',
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER DIPERBARUI MENJADI LIST CARD ---
  Widget _buildProfileListCard({
    required String imagePath,
    required String name,
    required String role,
    required String description,
  }) {
    return Card(
      elevation: 2,
      color: Colors.blue[50], // Warna biru muda
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar di sebelah kiri
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue[100],
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 15),
            // Teks di sebelah kanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1e3a8a),
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}