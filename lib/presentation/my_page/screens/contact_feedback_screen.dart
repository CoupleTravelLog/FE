// lib/presentation/my_page/screens/contact_feedback_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 외부 앱(메일) 실행을 위해 필요
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';

class ContactFeedbackScreen extends StatelessWidget {
  const ContactFeedbackScreen({super.key});

  // BuildContext를 인자로 받도록 수정
  Future<void> _launchEmailClient(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@couplelog.com', // 앱 지원 이메일 주소
      queryParameters: {
        'subject': '[커플로그 문의]',
      },
    );

    if (!await launchUrl(emailLaunchUri)) {
      // 전달받은 context를 사용하여 SnackBar 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이메일 앱을 열 수 없습니다. support@couplelog.com으로 직접 문의해주세요.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '문의하기 / 피드백',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.headset_mic_outlined,
              size: 80,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 20),
            Text(
              '무엇을 도와드릴까요?',
              style: AppTextStyles.inputLabel,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '궁금한 점이나 제안하고 싶은 내용이 있다면 언제든지 알려주세요!',
              style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildContactOption(
              context,
              icon: Icons.email_outlined,
              title: '이메일 문의',
              subtitle: 'support@couplelog.com',
              // onTap 호출 시 context 전달
              onTap: () => _launchEmailClient(context),
            ),
            const SizedBox(height: 20),
            _buildContactOption(
              context,
              icon: Icons.chat_bubble_outline,
              title: '자주 묻는 질문 (FAQ)',
              subtitle: '궁금한 점을 먼저 확인해보세요.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('FAQ 화면 (TODO)')),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildContactOption(
              context,
              icon: Icons.forum_outlined,
              title: '커뮤니티 / 포럼',
              subtitle: '다른 사용자들과 소통하고 정보를 공유하세요.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('커뮤니티 화면 (TODO)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: AppColors.mellowLavender),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.inputLabel.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.lightGrey),
          ],
        ),
      ),
    );
  }
}