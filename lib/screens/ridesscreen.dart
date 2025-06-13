import 'dart:async';
import 'package:flutter/material.dart';
import '../services/rideService.dart';
import '../widgets/sidebar.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  bool loading = true;
  Timer? _timer;
  List<dynamic> allRides = [];

  @override
  void initState() {
    super.initState();
    fetchRides();

    // Refresh rides every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => fetchRides());
  }

  Future<void> fetchRides() async {
    try {
      final rides = await RideService().fetchActiveRides();
      final combinedRides = [
        ...rides['pool'].map((e) => {...e, 'rideType': 'pool'}),
        ...rides['demand'].map((e) => {...e, 'rideType': 'demand'}),
        ...rides['schedule'].map((e) => {...e, 'rideType': 'schedule'}),
      ];

      final statusPriority = {
        'pending': 1,
        'accepted': 2,
        'confirmed': 3,
        'completed': 4,
        'cancelled': 5,
      };

      combinedRides.sort((a, b) {
        final aDate = DateTime.tryParse(a['startTime'] ?? '') ?? DateTime(2000);
        final bDate = DateTime.tryParse(b['startTime'] ?? '') ?? DateTime(2000);
        final dateCompare = bDate.compareTo(aDate);
        return dateCompare != 0
            ? dateCompare
            : (statusPriority[a['rideStatus']] ?? 99).compareTo(
              statusPriority[b['rideStatus']] ?? 99,
            );
      });

      setState(() {
        allRides = combinedRides;
        loading = false;
      });
    } catch (e) {
      print('Error fetching rides: $e');
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'confirmed':
        return Colors.grey;
      case 'pending':
      case 'accepted':
        return Colors.amber;
      default:
        return Colors.white70;
    }
  }

  IconData getRideIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pool':
        return Icons.directions_car;
      case 'demand':
        return Icons.flash_on;
      case 'schedule':
        return Icons.schedule;
      default:
        return Icons.emoji_transportation;
    }
  }

  Widget buildRideCard(dynamic ride) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF323244),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ride ID: ${ride['_id'] ?? 'N/A'}',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            'Driver: ${ride['driver_name'] ?? 'N/A'} (${ride['driver_phone'] ?? ''})',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Vehicle: ${ride['vehicle_type'] ?? 'N/A'}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            'From: ${ride['pickupLocation'] ?? 'N/A'}',
            style: const TextStyle(color: Colors.lightBlueAccent),
          ),
          Text(
            'To: ${ride['dropoffLocation'] ?? 'N/A'}',
            style: const TextStyle(color: Colors.lightGreenAccent),
          ),
          const SizedBox(height: 10),
          const Text(
            'Passengers:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (ride['passengers'] != null && ride['passengers'] is List)
            ...List<Widget>.from(
              (ride['passengers'] as List).map(
                (p) => Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 3),
                  child: Text(
                    '- ${p['name']} | ${p['phoneNumber']} | ${p['remarks'] ?? 'No remarks'}',
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(getRideIcon(ride['rideType']), color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    ride['rideType'].toString().toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(ride['status'] ?? ''),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ride['status']?.toString().toUpperCase() ?? 'UNKNOWN',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
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
                        const Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Keep tracking active rides!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 30),
                        loading
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : Column(
                              children: allRides.map(buildRideCard).toList(),
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
