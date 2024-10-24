import 'package:PureFit/Core/Components/media_query.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmerloadingexercises extends StatelessWidget {
  final CustomMQ mq;
  const Shimmerloadingexercises({super.key, required this.mq});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height(20), // Set the height for the shimmer effect
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Number of shimmer items to display
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: mq.width(4)),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: mq.width(55),
                padding: EdgeInsets.all(mq.width(4)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mq.width(4)),
                  color: Colors.white, // Background color for shimmer
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: mq.height(7),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(mq.width(3)),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: mq.height(1)),
                    Row(
                      children: [
                        Container(
                          height: mq.width(3),
                          width: mq.width(4.5),
                          color: Colors.white,
                        ),
                        SizedBox(width: mq.width(1.25)),
                        Container(
                          height: mq.width(3),
                          width: mq.width(10),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildPlanCardShimmer(CustomMQ mq) {
  return Padding(
    padding:
        EdgeInsets.symmetric(horizontal: mq.width(1), vertical: mq.height(1)),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: mq.height(10),
        width: double.infinity,
        padding: EdgeInsets.all(mq.width(4)),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(mq.width(4)),
        ),
      ),
    ),
  );
}
