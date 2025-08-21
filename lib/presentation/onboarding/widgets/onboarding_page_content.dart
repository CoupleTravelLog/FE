// 각 튜토리얼 화면의 내용 담을 때 재사용할 아이콘

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:couple_log/core/constants/app_colors.dart';

class OnboardingPageContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPageContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
              ),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: GoogleFonts.notoSansKr(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.urbanGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: GoogleFonts.notoSansKr(
                  fontSize: 16,
                  color: AppColors.urbanGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const Expanded(flex: 1, child: SizedBox.shrink()),
            ],
        ),
    );
  }
}