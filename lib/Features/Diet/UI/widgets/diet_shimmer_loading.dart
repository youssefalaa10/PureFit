 import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Core/Components/media_query.dart';

Widget dietShimmerLoading(BuildContext context) {
    final mq = CustomMQ(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: mq.height(1)),
            child: Container(
              height: mq.height(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }