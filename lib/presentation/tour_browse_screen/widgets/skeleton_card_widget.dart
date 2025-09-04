import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SkeletonCardWidget extends StatefulWidget {
  const SkeletonCardWidget({Key? key}) : super(key: key);

  @override
  State<SkeletonCardWidget> createState() => _SkeletonCardWidgetState();
}

class _SkeletonCardWidgetState extends State<SkeletonCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonBox(
                width: double.infinity,
                height: 20.h,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(
                      width: 70.w,
                      height: 2.h,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    SizedBox(height: 1.h),
                    _buildSkeletonBox(
                      width: 50.w,
                      height: 1.5.h,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSkeletonBox(
                      width: 60.w,
                      height: 1.5.h,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSkeletonBox(
                          width: 25.w,
                          height: 2.5.h,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        _buildSkeletonBox(
                          width: 20.w,
                          height: 2.h,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeletonBox({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300]!.withValues(alpha: _animation.value),
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}
