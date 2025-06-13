import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ss_pool/screens/loginpage.dart';
import 'package:ss_pool/services/loginService.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Color(0xFF2A2A3C),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.account_balance_wallet, size: 40, color: Colors.white),
          SizedBox(height: 30),
          SidebarItem(
            icon: LucideIcons.layoutDashboard,
            label: 'Dashboard',
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          SidebarItem(
            icon: LucideIcons.users,
            label: 'Users',
            onTap: () => Navigator.pushNamed(context, '/users'),
          ),
          SidebarItem(
            icon: LucideIcons.car,
            label: 'Drivers',
            onTap: () => Navigator.pushNamed(context, '/drivers'),
          ),
          SidebarItem(
            icon: LucideIcons.navigation,
            label: 'Rides',
            onTap: () => Navigator.pushNamed(context, '/rides'),
          ),
          SidebarItem(
            icon: LucideIcons.user,
            label: 'Profile',
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          SidebarItem(
            icon: LucideIcons.logOut,
            label: 'Sign Out',
            onTap: () {
              SidebarServices.logout(context);
            },
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(label, style: TextStyle(color: Colors.white70)),
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Only pop if possible
        } // Close drawer on mobile tap
        onTap();
      },
    );
  }
}

class SidebarServices {
  static Future<void> logout(BuildContext context) async {
    bool result = await LoginService.logout();
    if (result) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // remove all previous routes
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logout failed. Try again.")),
      );
    }
  }
}
