// lib/presentation/my_page/screens/terms_policies_screen.dart

import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart'; // 웹 링크 열기를 위해 필요

class TermsPoliciesScreen extends StatelessWidget {
  const TermsPoliciesScreen({super.key});

  // BuildContext를 인자로 받도록 수정
  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // 전달받은 context를 사용하여 SnackBar 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('링크를 열 수 없습니다: $url'),
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
          '약관 및 정책',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '커플로그의 서비스 이용에 필요한 약관 및 정책입니다.',
              style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
            ),
            const SizedBox(height: 30),
            _buildPolicyItem(
              context,
              '서비스 이용 약관',
              'https://www.couplelog.com/terms', // 실제 약관 URL로 변경
              // onTap 호출 시 context 전달
                  () => _launchUrl(context, 'https://www.couplelog.com/terms'),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
            _buildPolicyItem(
              context,
              '개인정보 처리 방침',
              'https://www.couplelog.com/privacy', // 실제 개인정보 처리 방침 URL로 변경
              // onTap 호출 시 context 전달
                  () => _launchUrl(context, 'https://www.couplelog.com/privacy'),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
            _buildPolicyItem(
              context,
              '오픈소스 라이선스',
              '', // 오픈소스 라이선스 정보가 있는 페이지 (내부 화면일수도 있음)
                  () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('오픈소스 라이선스 화면 (TODO)')),
                );
              },
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.lightGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyItem(BuildContext context, String title, String url, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
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