import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Core/Components/custom_snackbar.dart';
import '../../../../Core/Components/media_query.dart';
import '../../Logic/cubit/profile_cubit.dart';

class CustomProfileHeader extends StatefulWidget {
  const CustomProfileHeader({super.key});

  @override
  State<CustomProfileHeader> createState() => _CustomProfileHeaderState();
}

class _CustomProfileHeaderState extends State<CustomProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return _shimmerHeader(mq);
        } else if (state is ProfileSuccess) {
          final user = state.user;
          final imageFile = File(user.image!);
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: mq.width(15),
                height: mq.width(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mq.width(2.5)),
                ),
                child: imageFile.existsSync()
                    ? Image.file(imageFile, fit: BoxFit.cover)
                    : user.gender == "male"
                        ? SvgPicture.asset(
                            "assets/images/man.svg",
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(
                            "assets/images/women.svg",
                            fit: BoxFit.cover,
                          ),
              ),
              SizedBox(width: mq.width(4)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user.userName,
                      style: TextStyle(
                        fontSize: mq.width(4.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: mq.height(0.5)),
                    Text(
                      state.user.userEmail,
                      style: TextStyle(
                        fontSize: mq.width(3.5),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (state is ProfileError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              CustomSnackbar.showSnackbar(context, "Error");
            }
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _shimmerHeader(CustomMQ mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: mq.width(15),
            height: mq.width(15),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(mq.width(2.5)),
            ),
          ),
        ),
        SizedBox(width: mq.width(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: mq.width(30),
                  height: mq.height(2),
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(height: mq.height(0.5)),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: mq.width(20),
                  height: mq.height(1.5),
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
