import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../Core/Components/back_button.dart';
import '../../../Core/Components/media_query.dart';
import '../../../Core/Shared/app_string.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: mq.width(5), // Replacing 20.sp
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
                const ProfileImageSection(),
                SizedBox(height: mq.height(1)),
                EditableField(
                  label: 'Your Name',
                  hintText: 'Youssef Alaa',
                  obscureText: true,
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mq.height(1)),
                const EditableField(
                  label: 'Email',
                  hintText: 'youssef@gmail.com',
                  icon: Icons.email_outlined,
                  isReadOnly: true, // Make the email field read-only
                ),
                SizedBox(height: mq.height(1)),
                EditableField(
                  label: 'Password',
                  hintText: '***********',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mq.height(1)),
                const GenderSelector(),
                SizedBox(height: mq.height(1)),
                const HeightSlider(),
                SizedBox(height: mq.height(1)),
                const WeightSlider(),
                SizedBox(height: mq.height(2)),
                Center(
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
                        // Process data here if form is valid
                      }
                    },
                    child: Text(
                      'Save Changes',
                      style:
                          TextStyle(fontSize: mq.width(4), color: Colors.white),
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

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: mq.width(12.5),
            backgroundImage: AssetImage(AppString.profile),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: mq.width(3.75),
              backgroundColor: Colors.orange,
              child:
                  Icon(Icons.edit, size: mq.width(3.75), color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class EditableField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final bool isReadOnly;
  final String? Function(String?)? validator;

  const EditableField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.isReadOnly = false,
    this.validator,
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
          obscureText: obscureText,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            hintText: hintText,
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
  const WeightSlider({super.key});

  @override
  _WeightSliderState createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  double _currentWeight = 40;

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
                value: _currentWeight,
                min: 40,
                max: 160,
                divisions: 120, // Number of steps between 40 and 160
                label: _currentWeight.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _currentWeight = value;
                  });
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
  const HeightSlider({super.key});

  @override
  _HeightSliderState createState() => _HeightSliderState();
}

class _HeightSliderState extends State<HeightSlider> {
  double _currentHeight = 130;

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
                value: _currentHeight,
                min: 130,
                max: 200,
                divisions: 70, // Number of steps between 130 and 200
                label: _currentHeight.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _currentHeight = value;
                  });
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

class GenderSelector extends StatefulWidget {
  const GenderSelector({super.key});

  @override
  GenderSelectorState createState() => GenderSelectorState();
}

class GenderSelectorState extends State<GenderSelector> {
  String _selectedGender = "Male";

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(fontSize: mq.width(4), fontWeight: FontWeight.w600),
        ),
        SizedBox(height: mq.height(0.8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGender = "Male";
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(mq.width(0.25)),
                  decoration: BoxDecoration(
                    color: _selectedGender == "Male"
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(mq.width(2.5)),
                    border: Border.all(
                      color:
                          _selectedGender == "Male" ? Colors.blue : Colors.grey,
                      width: mq.width(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: "Male",
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      SizedBox(width: mq.width(2.5)),
                      Text(
                        "Male",
                        style: TextStyle(fontSize: mq.width(4)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: mq.width(2.5)),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGender = "Female";
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(mq.width(0.25)),
                  decoration: BoxDecoration(
                    color: _selectedGender == "Female"
                        ? Colors.pink.withOpacity(0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(mq.width(2.5)),
                    border: Border.all(
                      color: _selectedGender == "Female"
                          ? Colors.pink
                          : Colors.grey,
                      width: mq.width(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: "Female",
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                        activeColor: Colors.pink,
                      ),
                      SizedBox(width: mq.width(2.5)),
                      Text(
                        "Female",
                        style: TextStyle(fontSize: mq.width(4)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
