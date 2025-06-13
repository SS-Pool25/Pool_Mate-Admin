import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Scaffold(
          backgroundColor: const Color(0xFF1E1E2F),
          appBar:
              isMobile
                  ? AppBar(
                    backgroundColor: const Color(0xFF2A2A3C),
                    title: const Text('RideScreen'),
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
                            'RideScreen',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          'Hello,',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "quote",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A3C),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text('Box1'),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A3C),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text('Box2'),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A3C),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text('Box3'),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A3C),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text('Box4'),
                        ),
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
