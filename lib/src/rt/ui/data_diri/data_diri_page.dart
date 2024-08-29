// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:e_kas/src/login/form_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_kas/service/rt/datadiri_service.dart';
import 'package:e_kas/src/rt/ui/data_diri/updatediripage.dart';
import '../../../shared/rt/navbar_widget.dart';
import '../../../shared/rt/topbar_widget.dart';

class DataDiriPage extends StatefulWidget {
  const DataDiriPage({super.key});

  @override
  _DataDiriPageState createState() => _DataDiriPageState();
}

class _DataDiriPageState extends State<DataDiriPage> {
  int _currentIndex = 5;
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final data = await getUserData();
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getInitials(String fullName) {
    final nameParts = fullName.split(' ');
    if (nameParts.isEmpty) return '';
    final initials = nameParts[0].isNotEmpty ? nameParts[0][0] : ''; // Take the first letter of the first name
    return initials.toUpperCase();
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToUpdatePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateDiriPage(
          diriId: _userData?['id'] ?? '', 
          initialData: _userData, 
        ),
      ),
    );
  }
  
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const FormLoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final circleAvatarRadius = screenWidth * 0.2;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Topbar(title: 'Data Diri'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _userData == null
                        ? const Center(child: Text('No data found'))
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: circleAvatarRadius,
                                  backgroundColor: const Color(0xFF06B4B5),
                                  child: Center(
                                    child: Text(
                                      _getInitials(_userData!['nama_Lengkap']),
                                      style: TextStyle(
                                        fontSize: circleAvatarRadius * 0.8, // Adjust font size proportionally
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                ElevatedButton(
                                  onPressed: _navigateToUpdatePage,
                                  style: ElevatedButton.styleFrom(
                                   
                                    minimumSize: Size(screenWidth * 0.8, 50), // Set button width and height
                                    alignment: Alignment.centerLeft, // Align text to the left
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.person),
                                      SizedBox(width: 8.0),
                                      Text('Data Diri', textAlign: TextAlign.left),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                ElevatedButton(
                                  onPressed: _logout,
                                  style: ElevatedButton.styleFrom(
                               
                                    minimumSize: Size(screenWidth * 0.8, 50), // Set button width and height
                                    alignment: Alignment.centerLeft, // Align text to the left
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.logout),
                                      SizedBox(width: 8.0),
                                      Text('Logout', textAlign: TextAlign.left),
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
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}
