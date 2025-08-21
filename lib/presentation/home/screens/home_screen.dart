// lib/presentation/home/screens/home_screen.dart

import 'package:couple_log/presentation/couple_connection/screens/connect_option_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '커플로그', // 앱 이름 또는 홈 제목
          style: GoogleFonts.notoSansKr(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.urbanGrey,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.urbanGrey),
            onPressed: () {
              // TODO: 알림 화면으로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('알림 화면 (TODO)')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 커플 인사말 / 메인 섹션
            Text(
              '안녕하세요, Emma & James!', // TODO: 실제 사용자 이름으로 동적 변경
              style: AppTextStyles.headerTitle.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text(
              '우리만의 특별한 추억을 기록해볼까요?',
              style: AppTextStyles.smallText,
            ),
            const SizedBox(height: 30),

            // 기념일 D-Day 카드
            _buildAnniversaryCard(),
            const SizedBox(height: 30),

            // 최신 여행 기록 미리보기 (가로 스크롤)
            Text(
              '최신 여행 기록',
              style: AppTextStyles.inputLabel.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 180, // 카드 높이
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // TODO: 실제 데이터 개수로 변경
                itemBuilder: (context, index) {
                  return _buildTravelLogCard(context, index);
                },
              ),
            ),
            const SizedBox(height: 30),

            // 커플 다짐 / 위시리스트 등 추가 섹션 (예시)
            _buildFeatureSection(
              context,
              title: '우리만의 다짐',
              description: '서로에게 약속한 다짐들을 확인하고 지켜나가요.',
              icon: Icons.favorite_border,
            ),
            const SizedBox(height: 20),
            _buildFeatureSection(
              context,
              title: '함께 할 위시리스트',
              description: '버킷리스트를 채우고 함께 이뤄가요.',
              icon: Icons.star_border,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnniversaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warmRosePink, // 배경색
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warmRosePink, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '다음 기념일: 결혼 기념일', // TODO: 실제 기념일 데이터로 변경
            style: AppTextStyles.smallText.copyWith(color: AppColors.warmRosePink.darken(0.2)),
          ),
          const SizedBox(height: 8),
          Text(
            'D-365', // TODO: 실제 D-Day 계산
            style: GoogleFonts.notoSansKr(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.warmRosePink,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                // TODO: 기념일 관리 화면으로 이동
              },
              child: Text(
                '자세히 보기',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.warmRosePink.darken(0.1),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelLogCard(BuildContext context, int index) {
    return Container(
      width: 150, // 카드 너비
      margin: EdgeInsets.only(right: index == 2 ? 0 : 15), // 마지막 카드 제외 마진
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                'assets/images/onboarding_map_illustration.png', // TODO: 실제 여행 사진으로 변경
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '제주도 ${index + 1}일차', // TODO: 실제 제목
                  style: AppTextStyles.inputLabel.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '2024.08.${10 + index}', // TODO: 실제 날짜
                  style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection(BuildContext context, {required String title, required String description, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: AppColors.mellowLavender),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.inputLabel.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.lightGrey),
        ],
      ),
    );
  }
}