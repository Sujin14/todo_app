import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTaskCard extends StatelessWidget {
  final double height;
  const ShimmerTaskCard({super.key, this.height = 88});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: height,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(width: 8, height: double.infinity, color: Colors.grey.shade400),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 14, width: double.infinity, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 140, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 100, color: Colors.grey.shade400),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(width: 24, height: 24, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
