import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';

class TravelLogScreen extends StatelessWidget {
  const TravelLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '여행 기록',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map_outlined,
              size: 80,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 20),
            Text(
              '우리만의 여행 기록을 시작해보세요!',
              style: AppTextStyles.inputLabel,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '아직 기록된 여행이 없어요.',
              style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: 새 여행 기록 작성 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('새 여행 기록 작성 (TODO)')),
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
                '새로운 여행 기록 추가하기',
                style: AppTextStyles.buttonText.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}