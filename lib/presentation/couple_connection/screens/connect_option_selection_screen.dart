// lib/presentation/couple_connection/screens/connect_option_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:couple_log/presentation/couple_connection/screens/generate_share_invite_code_screen.dart';
import 'package:couple_log/presentation/couple_connection/screens/enter_invite_code_screen.dart';

class ConnectOptionSelectionScreen extends StatelessWidget {
  const ConnectOptionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '파트너와 연결하기',
          style: AppTextStyles.linkText.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '어떻게 연결할까요?',
              style: AppTextStyles.headerTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildOptionCard(
              context,
              icon: Icons.send, // 종이비행기 아이콘
              iconColor: AppColors.warmRosePink,
              title: '초대 코드 보내기',
              description: '파트너에게 초대 코드를 보내고 연결을 시작합니다.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GenerateShareInviteCodeScreen()),
                );
              },
              isPrimary: true,
            ),
            const SizedBox(height: 24),
            _buildOptionCard(
              context,
              icon: Icons.vpn_key_rounded, // 열쇠 아이콘
              iconColor: AppColors.urbanGrey,
              title: '초대 코드 입력하기',
              description: '파트너에게 받은 초대 코드를 입력하고 연결합니다.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EnterInviteCodeScreen()),
                );
              },
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required IconData icon,
        required Color iconColor,
        required String title,
        required String description,
        required VoidCallback onTap,
        required bool isPrimary,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.warmRosePink.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? AppColors.warmRosePink : AppColors.lightGrey.withOpacity(0.5),
            width: isPrimary ? 2.0 : 1.0,
          ),
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
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.inputLabel.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isPrimary ? AppColors.warmRosePink.darken(0.1) : AppColors.urbanGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.smallText.copyWith(
                      color: isPrimary ? AppColors.warmRosePink.darken(0.2) : AppColors.lightGrey,
                    ),
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

// Color 확장 (Darken 기능 추가 - 필요 시 AppColors 파일로 이동)
extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}