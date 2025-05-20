import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/utils/image_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileSettingsScreen extends StatefulWidget {
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _favoriteTeamController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  File? _avatar;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });
  }

  Future<void> _sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent')),
      );
    }
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _favoriteTeamController.text = prefs.getString('favoriteTeam') ?? '';
      _bioController.text = prefs.getString('bio') ?? '';
      _instagramController.text = prefs.getString('instagram') ?? '';
      _twitterController.text = prefs.getString('twitter') ?? '';
      final avatarPath = prefs.getString('avatarPath');
      if (avatarPath != null && File(avatarPath).existsSync()) {
        _avatar = File(avatarPath);
      }
    });
  }

  Future<void> _saveProfileData() async {
    if (_formKey.currentState?.validate() != true) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('favoriteTeam', _favoriteTeamController.text);
    await prefs.setString('bio', _bioController.text);
    await prefs.setString('instagram', _instagramController.text);
    await prefs.setString('twitter', _twitterController.text);
    if (_avatar != null) {
      await prefs.setString('avatarPath', _avatar!.path);
    }
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImageUtils.pickAndSaveImage();
      if (image != null) {
        setState(() {
          _avatar = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: label == "Username" ? Icon(Icons.person) : Icon(Icons.shield),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLinkField(String label, TextEditingController controller, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.link),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value != null && value.trim().isNotEmpty) {
            Uri? uri = Uri.tryParse(value);
            if (uri == null || !uri.hasScheme) {
              return 'Please enter a valid URL';
            }
          }
          return null;
        },
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: _isEditing ? _pickImage : null,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
              child: _avatar == null ? Icon(Icons.camera_alt, size: 40) : null,
            ),
          ),
          const SizedBox(height: 20),
          if (FirebaseAuth.instance.currentUser?.email != null)
            Text(
              'Email: ${FirebaseAuth.instance.currentUser!.email}',
              style: const TextStyle(color: Colors.white70),
            ),
          const SizedBox(height: 10),
          if (!_isEmailVerified)
            Column(
              children: [
                const Text(
                  'Email not verified!',
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: _sendEmailVerification,
                  child: const Text('Send Verification Email'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField("Username", _usernameController, _isEditing),
                _buildTextField("Favorite Team", _favoriteTeamController, _isEditing),
                _buildTextField("Bio", _bioController, _isEditing),
                _buildLinkField("Instagram", _instagramController, _isEditing),
                _buildLinkField("Twitter", _twitterController, _isEditing),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_isEditing)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveProfileData,
                  icon: Icon(Icons.save),
                  label: Text("Save"),
                ),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _isEditing = false),
                  icon: Icon(Icons.cancel),
                  label: Text("Cancel"),
                ),
              ],
            )
          else
            ElevatedButton.icon(
              onPressed: () => setState(() => _isEditing = true),
              icon: Icon(Icons.edit),
              label: Text("Edit Profile"),
            ),
          if (!_isEditing) ...[
            if (_instagramController.text.isNotEmpty)
              GestureDetector(
                onTap: () => _launchURL(_instagramController.text),
                child: Text(
                  'Instagram: ${_instagramController.text}',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            if (_twitterController.text.isNotEmpty)
              GestureDetector(
                onTap: () => _launchURL(_twitterController.text),
                child: Text(
                  'Twitter: ${_twitterController.text}',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _logout,
            icon: Icon(Icons.logout),
            label: Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
