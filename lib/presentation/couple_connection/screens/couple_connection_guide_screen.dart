// lib/presentation/couple_connection/screens/couple_connection_guide_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:couple_log/presentation/couple_connection/screens/connect_option_selection_screen.dart';
import 'package:couple_log/presentation/main_app/screens/main_app_screen.dart';

class CoupleConnectionGuideScreen extends StatelessWidget {
  const CoupleConnectionGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고 또는 아이콘 (선택 사항)
            Image.asset(
              'assets/images/app_logo.png', // 앱 로고 경로
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 32),
            Text(
              '사랑의 여정을 함께 시작할 준비가 되셨나요?',
              style: AppTextStyles.headerTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            // 따뜻하고 감성적인 커플 일러스트
            Image.asset(
              'assets/images/app_logo.png', // 커플 일러스트 경로
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 48),
            Text(
              '커플로그는 오직 두 분만을 위한 비밀스러운 공간이에요.\n파트너와 연결하여 지금 바로 추억을 기록해보세요.',
              style: AppTextStyles.smallText,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 실제 연결 여부 확인 후 분기
                  // 임시로 바로 다음 화면 (커플 연결 선택)으로 이동.
                  // 만약 이미 연결되어 있다면 MainAppScreen으로 바로 이동.
                  Navigator.pushReplacement( // 교체 (이전 화면 스택에서 제거)
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConnectOptionSelectionScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warmRosePink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '파트너와 연결하기',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}