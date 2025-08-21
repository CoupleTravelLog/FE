// lib/presentation/my_page/screens/notification_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _isAllNotificationsEnabled = true;
  bool _isAnniversaryNotificationsEnabled = true;
  bool _isNewContentNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '알림 설정',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('일반 알림'),
            _buildNotificationToggle(
              '모든 알림 받기',
              _isAllNotificationsEnabled,
                  (bool value) {
                setState(() {
                  _isAllNotificationsEnabled = value;
                  // 모든 하위 알림 설정도 함께 변경 (예시)
                  _isAnniversaryNotificationsEnabled = value;
                  _isNewContentNotificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('개별 알림'),
            _buildNotificationToggle(
              '기념일 알림',
              _isAnniversaryNotificationsEnabled,
                  (bool value) {
                setState(() {
                  _isAnniversaryNotificationsEnabled = value;
                });
              },
            ),
            _buildNotificationToggle(
              '새로운 콘텐츠 알림',
              _isNewContentNotificationsEnabled,
                  (bool value) {
                setState(() {
                  _isNewContentNotificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 30),
            Text(
              '참고: 일부 중요 알림(예: 보안 관련)은 앱 설정과 무관하게 발송될 수 있습니다.',
              style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: AppTextStyles.inputLabel.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNotificationToggle(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.inputLabel,
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.warmRosePink,
            inactiveThumbColor: AppColors.lightGrey,
            inactiveTrackColor: AppColors.lightGrey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}