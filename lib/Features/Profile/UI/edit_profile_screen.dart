import 'dart:io';

import 'package:fitpro/Core/Components/custom_snackbar.dart';
import 'package:fitpro/Core/DI/dependency.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Profile/Data/Model/user_model.dart';
import 'package:fitpro/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Components/back_button.dart';
import '../../../Core/Components/media_query.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Core/Shared/app_string.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const EditProfileScreen({super.key, required this.userModel});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  // late int _currentHeight;
  late int _currentWeight;
  late String _selectedGender;
  File? imageFile;
  bool isUploading = false;
  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.userModel.userName);
    _ageController =
        TextEditingController(text: widget.userModel.age.toString());
    // _currentHeight = widget.userModel.userHeight;
    _currentWeight = widget.userModel.userWeight;
    _selectedGender = widget.userModel.gender;
  }

  Future<void> _uploadProfileImage(File image) async {
    setState(() {
      isUploading = true;
    });

    // Simulate image upload
    await Future.delayed(const Duration(seconds: 2));

    // Once uploaded, you can update the userModel's image field with the new file path or URL
    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(

        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: mq.width(5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mq.width(5), vertical: mq.height(1)),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileImageSection(
                  onImageSelected: (File selectedImage) async {
                    setState(() {
                      imageFile = selectedImage;
                    });

                    // Upload the image and update the user profile
                    await _uploadProfileImage(selectedImage);
                  },
                  imageUrl: widget.userModel.image,
                ),
                SizedBox(height: mq.height(1)),
                EditableField(
                  label: 'Your Name',
                  controller: _nameController,
                  obscureText: false,
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mq.height(1)),
                EditableField(
                  label: 'Age',
                  controller: _ageController,
                  icon: Icons.calendar_today_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    } else if (int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                // SizedBox(height: mq.height(1)),
                // HeightSlider(
                //   height: widget.userModel.userHeight,
                //   onValueChanged: (height) {
                //     setState(() {
                //       _currentHeight = height;
                //     });
                //   },
                // ),
                SizedBox(height: mq.height(1)),
                WeightSlider(
                  weighslider: widget.userModel.userWeight,
                  onValueChanged: (weight) {
                    setState(() {
                      _currentWeight = weight;
                    });
                  },
                ),
                SizedBox(height: mq.height(2)),
                BlocProvider(
                  create: (context) => getIT<ProfileCubit>(),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: mq.width(12.5), vertical: mq.height(1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(mq.width(2.5)),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Pass updated userModel data
                          context.read<ProfileCubit>().updateProfile(
                                widget.userModel.copyWith(
                                  userName: _nameController.text,
                                  age: int.parse(_ageController.text),
                                  // userHeight: _currentHeight,
                                  userWeight: _currentWeight,
                                  gender: _selectedGender,
                                  image: imageFile?.path,
                                ),
                                widget.userModel.userId,
                              );
                          CustomSnackbar.showSnackbar(context, "Success");
                        }
                      },
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                            fontSize: mq.width(4), color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileImageSection extends StatefulWidget {
  final Function(File) onImageSelected;
  final String? imageUrl;

  const ProfileImageSection(
      {super.key, required this.onImageSelected, this.imageUrl});

  @override
  _ProfileImageSectionState createState() => _ProfileImageSectionState();
}

class _ProfileImageSectionState extends State<ProfileImageSection> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      widget.onImageSelected(File(selectedImage.path));
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: mq.width(12.5),
            backgroundImage: _imageFile != null
                ? FileImage(File(_imageFile!.path))
                : AssetImage(AppString
                    .profile), // Use the asset image if no file is present
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: mq.width(3.75),
              backgroundColor: ColorManager.backGroundColor,
              child: IconButton(
                icon: Icon(Icons.camera_alt,
                    size: mq.width(3.75),
                    color: Colors.white), // Changed to camera icon
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditableField extends StatelessWidget {
  final String label;

  final IconData icon;
  final bool obscureText;
  final bool isReadOnly;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const EditableField({
    super.key,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.isReadOnly = false,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.w600),
        ),
        SizedBox(height: mq.height(0.8)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(mq.width(2.5)),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

class WeightSlider extends StatefulWidget {
  final int weighslider;
  final Function(int) onValueChanged;
  const WeightSlider(
      {super.key, required this.weighslider, required this.onValueChanged});

  @override
  WeightSliderState createState() => WeightSliderState();
}

class WeightSliderState extends State<WeightSlider> {
  double _currentWeight = 40;

  @override
  void initState() {
    super.initState();
    _currentWeight = widget.weighslider.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight (kg)',
          style: TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Text('40', style: TextStyle(fontSize: mq.width(3.5))),
            Expanded(
              child: Slider(
                activeColor: ColorManager.primaryColor,
                inactiveColor: Colors.grey,
                value: _currentWeight,
                min: 40,
                max: 160,
                divisions: 120,
                label: _currentWeight.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _currentWeight = value;
                  });
                  widget.onValueChanged(_currentWeight.round());
                },
              ),
            ),
            Text('160', style: TextStyle(fontSize: mq.width(3.5))),
          ],
        ),
      ],
    );
  }
}

class HeightSlider extends StatefulWidget {
  final int height;
  final Function(int) onValueChanged;
  const HeightSlider(
      {super.key, required this.height, required this.onValueChanged});

  @override
  _HeightSliderState createState() => _HeightSliderState();
}

class _HeightSliderState extends State<HeightSlider> {
  double _currentHeight = 130;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.height.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Height (cm)',
          style: TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Text('130', style: TextStyle(fontSize: mq.width(3.5))),
            Expanded(
              child: Slider(
                activeColor: ColorManager.primaryColor,
                inactiveColor: Colors.grey,
                value: _currentHeight,
                min: 130,
                max: 200,
                divisions: 70,
                label: _currentHeight.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _currentHeight = value;
                  });
                  widget.onValueChanged(_currentHeight.round());
                },
              ),
            ),
            Text('200', style: TextStyle(fontSize: mq.width(3.5))),
          ],
        ),
      ],
    );
  }
}
