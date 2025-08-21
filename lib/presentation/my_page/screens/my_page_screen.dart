import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
// import 'package:couple_log/presentation/auth/screens/login_screen.dart'; // 로그아웃 시 이동
import 'package:couple_log/presentation/my_page/screens/anniversary_management_screen.dart';
import 'package:couple_log/presentation/my_page/screens/notification_settings_screen.dart';
import 'package:couple_log/presentation/my_page/screens/couple_connection_management_screen.dart';
import 'package:couple_log/presentation/my_page/screens/contact_feedback_screen.dart';
import 'package:couple_log/presentation/my_page/screens/terms_policies_screen.dart';


class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 정보 영역
            _buildProfileSection(context),
            const SizedBox(height: 30),

            // 기능 목록 섹션
            _buildFeatureList(context), // 이 부분을 호출합니다.
            const SizedBox(height: 30),

            // 하단 정보 및 로그아웃
            Align(
              alignment: Alignment.center,
              child: Text(
                '버전 1.0.0',
                style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  // TODO: 로그아웃 로직 구현 (AuthRepository 사용)
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                  //   (Route<dynamic> route) => false,
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그아웃 (TODO)')),
                  );
                },
                child: Text(
                  '로그아웃',
                  style: AppTextStyles.linkText.copyWith(
                    color: AppColors.urbanGrey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildProfileAvatar('M', Colors.pink.shade50), // 나의 프로필
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '내 닉네임', // TODO: 실제 닉네임
                  style: AppTextStyles.inputLabel.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: AppColors.lightGrey),
                onPressed: () {
                  // TODO: 프로필 수정 화면으로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('프로필 수정 (TODO)')),
                  );
                },
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1, color: AppColors.lightGrey),
          Row(
            children: [
              _buildProfileAvatar('P', Colors.purple.shade50), // 파트너 프로필
              const SizedBox(width: 16),
              Text(
                '파트너 닉네임', // TODO: 실제 파트너 닉네임
                style: AppTextStyles.inputLabel.copyWith(color: AppColors.urbanGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(String initial, Color bgColor) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: bgColor,
      child: Text(
        initial,
        style: AppTextStyles.headerTitle.copyWith(
          fontSize: 24,
          color: AppColors.urbanGrey,
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    return Container(
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
        children: [
          _buildFeatureListItem(context, Icons.cake_outlined, '기념일 관리', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AnniversaryManagementScreen()));
          }),
          const Divider(indent: 20, endIndent: 20, height: 1, thickness: 1, color: AppColors.lightGrey),
          _buildFeatureListItem(context, Icons.notifications_none, '알림 설정', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
          }),
          const Divider(indent: 20, endIndent: 20, height: 1, thickness: 1, color: AppColors.lightGrey),
          _buildFeatureListItem(context, Icons.link, '커플 연결 관리', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CoupleConnectionManagementScreen()));
          }),
          const Divider(indent: 20, endIndent: 20, height: 1, thickness: 1, color: AppColors.lightGrey),
          _buildFeatureListItem(context, Icons.headset_mic_outlined, '문의하기 / 피드백', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactFeedbackScreen()));
          }),
          const Divider(indent: 20, endIndent: 20, height: 1, thickness: 1, color: AppColors.lightGrey),
          _buildFeatureListItem(context, Icons.article_outlined, '약관 및 정책', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsPoliciesScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildFeatureListItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.urbanGrey),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.inputLabel,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.lightGrey),
          ],
        ),
      ),
    );
  }
}