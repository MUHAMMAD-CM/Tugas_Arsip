import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text("Arsip"),
              onTap: () => Get.offNamed('/home'),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text("Kategori Surat"),
              onTap: () => Get.offNamed('/category'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () => Get.offNamed('/about'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "About Me",
          style: GoogleFonts.poppins(
            color: Color(0xFF262422),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 139,
                  height: 139,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/edittttt.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      iconSize: 31,
                      onPressed: () {
                        Get.snackbar("Mangeak", "Selamat anda tertipu");
                      },
                      icon: Container(
                        width: 31,
                        height: 31,
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Color(0xFFEE8924),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Color(0xFFFFFFFF),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  "Fajar Sapto Mukti Raharjo",
                  style: GoogleFonts.poppins(
                    color: Color(0xFF262422),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Mobile Developer",
                  style: GoogleFonts.poppins(
                    color: Color(0xFFABABAB),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              field(
                name: "D3 - Teknologi Informasi",
                label: "Jurusan",
                icon: Icons.play_lesson_outlined,
              ),
              const SizedBox(height: 20),
              field(name: "2231740018", label: "NIM", icon: Icons.numbers),
              const SizedBox(height: 20),
              field(
                name: "15 September 2025",
                label: "Tanggal",
                icon: Icons.calendar_month,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget field({
    required String name,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Color(0xFF262422),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(width: 1, color: Color(0xFFF1ECEC)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(icon, color: Color(0xFFABABAB)),
              SizedBox(width: 12),
              Text(
                name,
                style: GoogleFonts.poppins(
                  color: Color(0xFFABABAB),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
