// 앱 실행 시 가장 먼저 보이는 화면
// lib/presentation/onboarding/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/presentation/onboarding/screens/onboarding_screen.dart'; // 다음 화면으로 연결

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding(); // 스플래시 후 온보딩 화면으로 이동
  }

  _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2)); // 2초간 스플래시 화면 유지
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige, // 주 배경색 적용
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고 이미지 (assets/images/app_logo.png 경로에 있어야 합니다)
            Image.asset(
              'assets/images/app_logo.png',
              width: 150, // 로고 크기 조절
              height: 150,
            ),
            const SizedBox(height: 16),
            // 슬로건
            Text(
              '우리만의 여정을 기록하다.',
              style: GoogleFonts.notoSansKr(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.urbanGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}