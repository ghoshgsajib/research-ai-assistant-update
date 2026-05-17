import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/auth_service.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final bioController = TextEditingController();
  String? userEmail;
  String? userName;
  bool isAdmin = false;
  List<Map<String, String>> allUsers = [];

  Uint8List? profileImageBytes;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImage = prefs.getString("profile_image_base64");
    
    // অ্যাডমিন কি না চেক করা হচ্ছে
    final adminStatus = await AuthService.isAdmin();
    
    List<Map<String, String>> usersList = [];
    if (adminStatus) {
      usersList = await AuthService.getAllUsers();
    }
    
    setState(() {
      isAdmin = adminStatus;
      allUsers = usersList;
      userName = prefs.getString('name') ?? "Research User";
      userEmail = prefs.getString('email') ?? "No Email Linked";
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

  void confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Logout?", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to logout?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("My Research Profile"),
        actions: [
          IconButton(
            onPressed: confirmLogout,
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "Logout",
          ),
        ],
      ),
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
            
            // Personal Information Card
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

            // Admin Only Section: Registered Users List (Database)
            if (isAdmin && allUsers.isNotEmpty) ...[
              const SizedBox(height: 45),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "User Database (Admin Only)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  final user = allUsers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor.withOpacity(0.1),
                          child: Text(
                            user['name']?[0].toUpperCase() ?? "U",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name'] ?? "Unknown",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                user['email'] ?? "No Email",
                                style: const TextStyle(color: Colors.white38, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        if (user['email'] == "admin@gmail.com")
                          const Icon(Icons.verified, color: Colors.blueAccent, size: 20),
                      ],
                    ),
                  );
                },
              ),
            ],
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
