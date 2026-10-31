import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color primaryGreen = Color(0xFF1A6556);

  void _showDeleteAccountDialog() {
    final TextEditingController passwordController = TextEditingController();
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            elevation: 8,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Judul: HAPUS AKUN
                  const Text(
                    'HAPUS AKUN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Input Password dengan Border Merah & Label "Kata Sandi"
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    cursorColor: const Color(0xFFE53935),
                    style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Masukan Kata Sandi',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF333333),
                          size: 22,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFFE53935),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFFE53935),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFFE53935),
                          width: 1.8,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Kotak Banner Peringatan Merah Muda
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFFE53935),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Anda akan menghapus akun anda. Tindakan ini tidak dapat dibatalkan. Semua data akan hilang.',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF4A4A4A),
                              height: 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF757575),
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Baris Tombol "Hapus" (merah) dan "Batal"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tombol Hapus (Merah)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Akun Anda telah berhasil dihapus'),
                              backgroundColor: Color(0xFFE53935),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 32),

                      // Tombol Batal
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData? icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            // Ikon (jika null, sediakan spacer lebar 24px agar teks tetap sejajar persis gambar referensi)
            if (icon != null)
              Icon(
                icon,
                color: Colors.black87,
                size: 24,
              )
            else
              const SizedBox(width: 24),

            const SizedBox(width: 20),

            // Judul Menu
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

            // Panah Kanan
            const Icon(
              Icons.chevron_right,
              color: Colors.black87,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
      indent: 20,
      endIndent: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // 1. Ubah Nomor Hp
            _buildSettingsItem(
              icon: Icons.phone_outlined,
              title: 'Ubah Nomor Hp',
              onTap: () {
                Navigator.pushNamed(context, '/change-phone');
              },
            ),
            _buildDivider(),

            // 2. Ubah Email
            _buildSettingsItem(
              icon: Icons.mail_outline,
              title: 'Ubah Email',
              onTap: () {
                Navigator.pushNamed(context, '/change-email');
              },
            ),
            _buildDivider(),

            // 3. Ubah Kata Sandi (tanpa ikon depan, teks tetap sejajar sesuai gambar referensi)
            _buildSettingsItem(
              icon: null,
              title: 'Ubah Kata Sandi',
              onTap: () {
                Navigator.pushNamed(context, '/change-password');
              },
            ),
            _buildDivider(),

            // 4. Hapus Akun
            _buildSettingsItem(
              icon: Icons.delete_outline,
              title: 'Hapus Akun',
              onTap: _showDeleteAccountDialog,
            ),
            _buildDivider(),
          ],
        ),
      ),
    );
  }
}
