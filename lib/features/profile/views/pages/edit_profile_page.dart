import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/views/widgets/main_button.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/profile/cubit/edit_profile/edit_profile_cubit.dart';

class EditProfilePage extends StatelessWidget {
  final UserData userData;
  const EditProfilePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocProvider(
        create: (context) => EditProfileCubit(),
        child: EditProfileBody(userData: userData),
      ),
    );
  }
}

class EditProfileBody extends StatefulWidget {
  final UserData userData;
  const EditProfileBody({super.key, required this.userData});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData.name;
    _titleController.text = widget.userData.title ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editProfileCubit = context.read<EditProfileCubit>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.userData.imageUrl ??
                            'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                      ),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.upload, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                // Add more fields as needed
              ],
            ),
            const SizedBox(height: 50),
            BlocConsumer<EditProfileCubit, EditProfileState>(
              bloc: editProfileCubit,
              listenWhen:
                  (previous, current) =>
                      current is EditProfileError ||
                      current is EditProfileSuccess,
              listener: (context, state) {
                if (state is EditProfileError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is EditProfileSuccess) {
                  Navigator.pop(context);
                }
              },
              buildWhen:
                  (previous, current) =>
                      current is EditProfileError ||
                      current is EditProfileSuccess ||
                      current is EditProfileLoading,
              builder: (context, state) {
                if (state is EditProfileLoading) {
                  return MainButton(
                    isLoading: true,
                  );
                }
                return MainButton(
                  onPressed: () async {
                    await editProfileCubit.updateProfile(
                      name: _nameController.text,
                      title: _titleController.text,
                      imageUrl: widget.userData.imageUrl,
                    );
                  },
                  child: const Text('Save Changes'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
