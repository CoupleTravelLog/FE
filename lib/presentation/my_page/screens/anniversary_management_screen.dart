// lib/presentation/my_page/screens/anniversary_management_screen.dart

import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';

class AnniversaryManagementScreen extends StatelessWidget {
  const AnniversaryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '기념일 관리',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 80,
                color: AppColors.lightGrey,
              ),
              const SizedBox(height: 20),
              Text(
                '우리의 소중한 기념일을 관리하세요!',
                style: AppTextStyles.inputLabel,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '첫 만남, 100일, 1주년, 그리고 특별한 날까지.\n모든 순간을 기록하고 알림을 받을 수 있어요.',
                style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // TODO: 새 기념일 추가 화면으로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('새 기념일 추가 화면 (TODO)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warmRosePink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  '새로운 기념일 추가하기',
                  style: AppTextStyles.buttonText.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}