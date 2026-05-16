import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final bioController = TextEditingController();

  Uint8List? profileImageBytes;

  @override
  void initState() {
    super.initState();
    nameController.text = AuthService.currentUser ?? "Unknown User";
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedImage = prefs.getString("profile_image_base64");

    setState(() {
      bioController.text = prefs.getString("profile_bio") ?? "";

      if (savedImage != null && savedImage.isNotEmpty) {
        profileImageBytes = base64Decode(savedImage);
      }
    });
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedImage == null) return;

    final bytes = await pickedImage.readAsBytes();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("profile_image_base64", base64Encode(bytes));

    setState(() {
      profileImageBytes = bytes;
    });
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("profile_bio", bioController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully 🚀")),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 58,
                  backgroundColor: Colors.blueAccent,
                  backgroundImage: profileImageBytes != null
                      ? MemoryImage(profileImageBytes!)
                      : null,
                  child: profileImageBytes == null
                      ? const Icon(Icons.person, size: 58, color: Colors.white)
                      : null,
                ),

                InkWell(
                  onTap: pickProfileImage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TextField(
              controller: nameController,
              readOnly: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Full Name",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: bioController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Bio",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveProfile,
                child: const Text(
                  "Save Profile",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Information",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    "Research AI User",
                    style: TextStyle(color: Colors.blueAccent),
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
