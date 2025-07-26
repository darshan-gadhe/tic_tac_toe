import 'package:advanced_tic_tac_toe/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late String _selectedAvatarId;
  final int totalAvatars = 4; // The total number of avatar images you have

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _nameController = TextEditingController(text: profileProvider.userName);
    _selectedAvatarId = profileProvider.avatarId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.setProfile(_nameController.text.trim(), _selectedAvatarId);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved!'), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Choose Your Avatar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(totalAvatars, (index) {
                final avatarId = (index + 1).toString();
                final isSelected = _selectedAvatarId == avatarId;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAvatarId = avatarId),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatars/avatar_$avatarId.png'),
                    child: isSelected
                        ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
                      ),
                    )
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Player Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}