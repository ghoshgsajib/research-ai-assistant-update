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
  String? userEmail;
  String? userName;
  bool isAdmin = false;

  Uint8List? profileImageBytes;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImage = prefs.getString("profile_image_base64");
    
    // চেক করা হচ্ছে ইউজার অ্যাডমিন কি না
    final adminStatus = await AuthService.isAdmin();
    
    setState(() {
      isAdmin = adminStatus;
      userName = prefs.getString('name') ?? "Research User";
      userEmail = prefs.getString('email') ?? "No Email Linked";
      nameController.text = userName!;
      bioController.text = prefs.getString("profile_bio") ?? "";

      if (savedImage != null && savedImage.isNotEmpty) {
        profileImageBytes = base64Decode(savedImage);
      }
    });
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

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
    
    if (!mounted) return;
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
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("My Research Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  backgroundImage: profileImageBytes != null ? MemoryImage(profileImageBytes!) : null,
                  child: profileImageBytes == null
                      ? Icon(Icons.person, size: 65, color: primaryColor)
                      : null,
                ),
                InkWell(
                  onTap: pickProfileImage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                    child: const Icon(Icons.edit, color: Colors.black, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            
            // User Information Card - শুধুমাত্র অ্যাডমিনদের জন্য দৃশ্যমান
            if (isAdmin)
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    detailRow(Icons.person_outline, "Full Name", userName ?? "Loading..."),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                    detailRow(Icons.alternate_email, "Email Address", userEmail ?? "Loading..."),
                  ],
                ),
              ),
            
            TextField(
              controller: bioController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Research Bio / Interests",
                hintText: "Add your research goals or interests...",
              ),
            ),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveProfile,
                child: const Text("Update Profile Info"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                value, 
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
