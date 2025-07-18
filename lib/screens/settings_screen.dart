// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:hive/hive.dart';
// import '../models/expense.dart'; // adjust import to your folder
//
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _notificationsEnabled = true;
//   bool _isDarkTheme = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPreferences();
//   }
//
//   Future<void> _loadPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _notificationsEnabled = prefs.getBool('notifications') ?? true;
//       _isDarkTheme = prefs.getBool('darkTheme') ?? false;
//     });
//   }
//
//   Future<void> _toggleNotification(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('notifications', value);
//     setState(() => _notificationsEnabled = value);
//   }
//
//   Future<void> _toggleTheme(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('darkTheme', value);
//     setState(() => _isDarkTheme = value);
//   }
//
//   void _showClearDataDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Clear All Data'),
//         content: const Text('Are you sure you want to clear all saved data?'),
//         actions: [
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () => Navigator.pop(context),
//           ),
//           ElevatedButton(
//             child: const Text('Clear'),
//             onPressed: () async {
//               var box = await Hive.openBox<Expense>('expenses');
//               await box.clear();
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Data cleared successfully')),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear(); // clear all session data
//     if (!mounted) return;
//     Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//   }
//
//   Widget _buildBarChart() {
//     return AspectRatio(
//       aspectRatio: 1.5,
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           maxY: 1000,
//           barTouchData: BarTouchData(enabled: false),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//                   return Text(days[value.toInt() % 7]);
//                 },
//               ),
//             ),
//           ),
//           barGroups: List.generate(7, (i) {
//             return BarChartGroupData(
//               x: i,
//               barRods: [
//                 BarChartRodData(
//                   toY: (100 + i * 50).toDouble(),
//                   width: 15,
//                   color: Colors.teal,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Settings"),
//         backgroundColor: Colors.teal,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           const Text("Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SwitchListTile(
//             title: const Text("Enable Notifications"),
//             value: _notificationsEnabled,
//             onChanged: _toggleNotification,
//             secondary: const Icon(Icons.notifications),
//           ),
//           SwitchListTile(
//             title: const Text("Dark Theme"),
//             value: _isDarkTheme,
//             onChanged: _toggleTheme,
//             secondary: const Icon(Icons.brightness_6),
//           ),
//           const Divider(),
//           const Text("Analytics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             child: _buildBarChart(),
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.info),
//             title: const Text("About"),
//             onTap: () {
//               showAboutDialog(
//                 context: context,
//                 applicationName: "Smart Expense Tracker",
//                 applicationVersion: "1.0.0",
//                 children: [
//                   const Text("Made with ❤️ by Deborah"),
//                 ],
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.delete_forever),
//             title: const Text("Clear All Data"),
//             onTap: _showClearDataDialog,
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text("Logout"),
//             onTap: _logout,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart'; // adjust import to your folder

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _isDarkTheme = false;

  // You could fetch these from your user model or preferences
  String userName = "Deborah Ishimwe";
  String userEmail = "debby53@example.com";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _isDarkTheme = prefs.getBool('darkTheme') ?? false;
    });
  }

  Future<void> _toggleNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', value);
    setState(() => _isDarkTheme = value);
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('Are you sure you want to clear all saved data?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Clear'),
            onPressed: () async {
              var box = await Hive.openBox<Expense>('expenses');
              await box.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data cleared successfully')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear all session data
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Widget _buildBarChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1000,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Text(days[value.toInt() % 7]);
                },
              ),
            ),
          ),
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (100 + i * 50).toDouble(),
                  width: 15,
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Account info ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.shade100.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.teal,
                  child: Text(
                    userName.isNotEmpty ? userName[0] : 'U',
                    style: const TextStyle(fontSize: 28, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.teal),
                  onPressed: () {
                    // TODO: Navigate to profile edit screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile tapped')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Preferences",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: _notificationsEnabled,
            onChanged: _toggleNotification,
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text("Dark Theme"),
            value: _isDarkTheme,
            onChanged: _toggleTheme,
            secondary: const Icon(Icons.brightness_6),
          ),

          const Divider(height: 40),

          const Text(
            "Analytics",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: _buildBarChart(),
          ),

          const Divider(height: 40),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Smart Expense Tracker",
                applicationVersion: "1.0.0",
                children: const [
                  Text("Made with ❤️ by Deborah"),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text("Clear All Data"),
            onTap: _showClearDataDialog,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
