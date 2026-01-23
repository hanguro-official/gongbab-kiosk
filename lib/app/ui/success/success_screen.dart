import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab/app/router/app_router.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  int remainingSeconds = 2;
  Timer? _countdownTimer;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();

    // Animation controller for the checkmark
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start the animation
    _animationController.forward();

    // Start countdown timer
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress -= 0.05 / 20; // Decrease over 2 seconds
        if (_progress <= 0) {
          _progress = 0;
        }
      });
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        _countdownTimer?.cancel();
        // Navigate back or to home screen
        if (mounted) {
          // context.pop();
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1f2e),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                'CHECK-IN STATUS',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 2,
                ),
              ),
            ),

            // Main content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated checkmark circle
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 280.r,
                        height: 280.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF10b981).withOpacity(0.3),
                              const Color(0xFF059669).withOpacity(0.1),
                              Colors.transparent,
                            ],
                            stops: const [0.3, 0.7, 1.0],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 160.r,
                            height: 160.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF34d399),
                                  Color(0xFF10b981),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10b981),
                                  blurRadius: 40.r,
                                  spreadRadius: -10.r,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check,
                              size: 80.r,
                              color: const Color(0xFF1a1f2e),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                  // Success message in Korean
                  Text(
                    '식권 체크 완료',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '맛있게 식사하세요',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9ca3af),
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  // Approved button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 60.w,
                      vertical: 18.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1e40af),
                      borderRadius: BorderRadius.circular(50.r),
                      border: Border.all(
                        color: const Color(0xFF3b82f6),
                        width: 2.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3b82f6).withOpacity(0.3),
                          blurRadius: 20.r,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      '승인됨 (Approved)',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF60a5fa),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom countdown section
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 16.r,
                        color: const Color(0xFF6b7280),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '$remainingSeconds초 후 홈으로 이동합니다',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF6b7280),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 6.h,
                      backgroundColor: const Color(0xFF2d3548),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF3b82f6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}