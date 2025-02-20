// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class CommonShimmer extends StatelessWidget {
//   final double height;
//   final double width;
//   final int itemCount;

//   const CommonShimmer({
//     Key? key,
//     this.height = 50,
//     this.width = double.infinity,
//     this.itemCount = 3, // Default: 3 shimmer blocks
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: List.generate(
//         itemCount,
//         (index) => Padding(
//           padding: EdgeInsets.symmetric(vertical: 10),
//           child: Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.white,
//             child: Container(
//               height: height,
//               width: width,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final bool isFullScreen;
  final Color baseColor;
  final Color highlightColor;
  final ShimmerType shimmerType;

  const CommonShimmer({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 50, // Matches form field height
    this.isFullScreen = false,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = Colors.white,
    this.shimmerType = ShimmerType.list, // Default shimmer type
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? _buildFullScreenShimmer()
        : _buildFormShimmer();
  }

  /// ✅ Full-Screen Shimmer
  Widget _buildFullScreenShimmer() {
    return Column(
      children: List.generate(itemCount, (index) => _shimmerItem()),
    );
  }

  /// ✅ Shimmer for Form Fields
  Widget _buildFormShimmer() {
    return Column(
      children: [
        _shimmerBox(width: double.infinity, height: 40), // Header Shimmer
        SizedBox(height: 10),
        _shimmerBox(width: double.infinity, height: 50), // Project Dropdown
        SizedBox(height: 10),
        _shimmerBox(width: double.infinity, height: 50), // Process Dropdown
        SizedBox(height: 10),
        _shimmerBox(width: double.infinity, height: 50), // Time Picker
        SizedBox(height: 10),
        _shimmerBox(width: double.infinity, height: 80), // Description Field
        SizedBox(height: 10),
        _shimmerBox(width: double.infinity, height: 50), // Add Button
        SizedBox(height: 10),
        _shimmerBox(width: double.infinity, height: 100), // Filled TimeSheet
        SizedBox(height: 10),
        _shimmerBox(width: double.infinity, height: 100), // Project Entries
        SizedBox(height: 10),
        _shimmerBox(width: double.infinity, height: 50), // Submit Button
      ],
    );
  }

  /// ✅ Reusable Shimmer Box
  Widget _shimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// ✅ Single List Item Shimmer
  Widget _shimmerItem() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: itemHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

/// ✅ Shimmer Type Enum
enum ShimmerType {
  list,
  form,
  fullScreen,
}