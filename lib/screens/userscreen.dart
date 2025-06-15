import 'package:flutter/material.dart';
import '../services/userService.dart';
import '../widgets/sidebar.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic>? _selectedUser;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    try {
      final users = await _userService.fetchUsers(_searchText);
      setState(() {
        _users = users;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _selectUser(String id) async {
    try {
      final user = await _userService.fetchUserDetails(id);
      setState(() {
        _selectedUser = user;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Scaffold(
          backgroundColor: const Color(0xFF1E1E2F),
          appBar:
              isMobile
                  ? AppBar(
                    backgroundColor: const Color(0xFF2A2A3C),
                    title: const Text('User Management'),
                    leading: Builder(
                      builder:
                          (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                    ),
                  )
                  : null,
          drawer:
              isMobile
                  ? Drawer(
                    child: Material(
                      color: const Color(0xFF2A2A3C),
                      child: Sidebar(),
                    ),
                  )
                  : null,
          body: SafeArea(
            child: Row(
              children: [
                // Sidebar fixed for desktop
                if (!isMobile)
                  Material(
                    color: const Color(0xFF1E1E2F),
                    child: SizedBox(width: 220, child: Sidebar()),
                  ),

                // Main content area
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 8 : 24),
                    color: const Color(0xFF1E1E2F),
                    child:
                        isMobile
                            ? Column(
                              children: [
                                // User details on top for mobile
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A2A3C),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:
                                        _selectedUser == null
                                            ? const Center(
                                              child: Text(
                                                'Select a user to view details',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            )
                                            : SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.person, color: Colors.white, size: 24),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _selectedUser!['name'] ?? 'N/A',
                                                    style: const TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),

                                              Row(
                                                children: [
                                                  const Icon(Icons.phone, color: Colors.white70, size: 20),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _selectedUser!['phone'] ?? 'N/A',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),

                                              Row(
                                                children: [
                                                  Text(
                                                    "Gender: ${_selectedUser!['gender'] ?? 'N/A'}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),

                                              Row(
                                                children: [
                                                  Text(
                                                    "Driver: ${_selectedUser!['isDriver'] == true ? 'Yes' : 'No'}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),

                                              if (_selectedUser!['vehicle_number'] != null)
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Vehicle No: ${_selectedUser!['vehicle_number']}",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              if (_selectedUser!['vehicle_type'] != null)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Type: ${_selectedUser!['vehicle_type']}",
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white70,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),

                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Search + User list below details on mobile
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A2A3C),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: TextField(
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: 'Search User by Name or Phone Number',
                                              labelStyle: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.search,
                                                color: Colors.white70,
                                              ),
                                              filled: true,
                                              fillColor: const Color(
                                                0xFF1E1E2F,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(
                                                () => _searchText = value,
                                              );
                                              _loadUsers();
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: _users.length,
                                            itemBuilder: (context, index) {
                                              final user = _users[index];
                                              bool selected =
                                                  _selectedUser?['_id'] ==
                                                  user['_id'];
                                              return Card(
                                                color:
                                                    selected
                                                        ? Colors.blueAccent
                                                            .withOpacity(0.7)
                                                        : const Color(
                                                          0xFF1E1E2F,
                                                        ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: ListTile(
                                                  title: Text(
                                                    user['name'],
                                                    style: TextStyle(
                                                      color:
                                                          selected
                                                              ? Colors.white
                                                              : Colors.white70,
                                                      fontWeight:
                                                          selected
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    user['phone'],
                                                    style: TextStyle(
                                                      color:
                                                          selected
                                                              ? Colors.white70
                                                              : Colors.white54,
                                                    ),
                                                  ),
                                                  onTap:
                                                      () => _selectUser(
                                                        user['_id'],
                                                      ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Row(
                              children: [
                                // User details on left (desktop)
                                Container(
                                  width: 700,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 5),
                                      const Text(
                                        'User Management',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          width: 450,
                                          height: 400,
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2A2A3C),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child:
                                              _selectedUser == null
                                                  ? const Center(
                                                    child: Text(
                                                      'Select a user to view details',
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  )
                                                  : SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.person, color: Colors.white, size: 24),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          _selectedUser!['name'] ?? 'N/A',
                                                          style: const TextStyle(
                                                            fontSize: 22,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),

                                                    Row(
                                                      children: [
                                                        const Icon(Icons.phone, color: Colors.white70, size: 20),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          _selectedUser!['phone'] ?? 'N/A',
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white70,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),

                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Gender: ${_selectedUser!['gender'] ?? 'N/A'}",
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white70,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),

                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Driver: ${_selectedUser!['isDriver'] == true ? 'Yes' : 'No'}",
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white70,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),

                                                    if (_selectedUser!['vehicle_number'] != null)
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Vehicle No: ${_selectedUser!['vehicle_number']}",
                                                            style: const TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.white70,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                    if (_selectedUser!['vehicle_type'] != null)
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 8),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Type: ${_selectedUser!['vehicle_type']}",
                                                              style: const TextStyle(
                                                                fontSize: 18,
                                                                color: Colors.white70,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),

                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 20),

                                // User list + search on right (desktop)
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A2A3C),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: TextField(
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: 'Search User by Name or Phone Number',
                                              labelStyle: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.search,
                                                color: Colors.white70,
                                              ),
                                              filled: true,
                                              fillColor: const Color(
                                                0xFF1E1E2F,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(
                                                () => _searchText = value,
                                              );
                                              _loadUsers();
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: _users.length,
                                            itemBuilder: (context, index) {
                                              final user = _users[index];
                                              bool selected =
                                                  _selectedUser?['_id'] ==
                                                  user['_id'];
                                              return Card(
                                                color:
                                                    selected
                                                        ? Colors.blueAccent
                                                            .withOpacity(0.7)
                                                        : const Color(
                                                          0xFF2A2A3C,
                                                        ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: ListTile(
                                                  title: Text(
                                                    user['name'],
                                                    style: TextStyle(
                                                      color:
                                                          selected
                                                              ? Colors.white
                                                              : Colors.white70,
                                                      fontWeight:
                                                          selected
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    user['phone'],
                                                    style: TextStyle(
                                                      color:
                                                          selected
                                                              ? Colors.white70
                                                              : Colors.white54,
                                                    ),
                                                  ),
                                                  onTap:
                                                      () => _selectUser(
                                                        user['_id'],
                                                      ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
