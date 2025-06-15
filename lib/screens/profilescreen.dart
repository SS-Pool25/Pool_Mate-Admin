import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../services/profileService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  String? name;
  String? email;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final profileData = await _profileService.getProfileData();
    setState(() {
      name = profileData['name'];
      email = profileData['email'];
    });
  }

  void _showAddAdminDialog() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    String gender = 'Male';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3C),
        title: const Text('Add Admin Member',
            style: TextStyle(color: Colors.white)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) => value!.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: gender,
                dropdownColor: const Color(0xFF2A2A3C),
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) {
                  gender = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Create Admin'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final result = await _profileService.createAdmin(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                  gender: gender,
                );
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result),
                      backgroundColor: Colors.blueGrey[800],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return Scaffold(
          backgroundColor: const Color(0xFF1E1E2F),
          appBar: isMobile
              ? AppBar(
                  backgroundColor: const Color(0xFF2A2A3C),
                  title: const Text('Profile'),
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                )
              : null,
          drawer: isMobile
              ? Drawer(
                  child: Material(
                    color: const Color(0xFF2A2A3C),
                    child: Sidebar(),
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!isMobile)
                Material(color: const Color(0xFF1E1E2F), child: Sidebar()),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMobile)
                          const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (name != null) ...[
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: const AssetImage(
                              'assets/profile_placeholder.png',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Hello, $name!',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 30),
                          if (name == 'SSPOOL')
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[900],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Admin Controls',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Admin Member'),
                                    onPressed: _showAddAdminDialog,
                                  ),
                                ],
                              ),
                            ),
                        ] else
                          const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
