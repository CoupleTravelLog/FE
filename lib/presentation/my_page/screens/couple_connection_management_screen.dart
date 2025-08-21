// lib/presentation/my_page/screens/couple_connection_management_screen.dart

import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:couple_log/data/couple_connection/repositories/couple_repository.dart'; // MockCoupleRepository 사용
// import 'package:couple_log_app/presentation/couple_connection/screens/connect_option_selection_screen.dart'; // 연결 끊기 후 이동

class CoupleConnectionManagementScreen extends StatefulWidget {
  const CoupleConnectionManagementScreen({super.key});

  @override
  State<CoupleConnectionManagementScreen> createState() => _CoupleConnectionManagementScreenState();
}

class _CoupleConnectionManagementScreenState extends State<CoupleConnectionManagementScreen> {
  final MockCoupleRepository _coupleRepository = MockCoupleRepository();
  // 실제 앱에서는 커플 연결 상태 및 파트너 정보 등을 여기에서 로드합니다.
  String _partnerNickname = '파트너 닉네임'; // TODO: 실제 데이터로 변경
  bool _isConnected = true; // TODO: 실제 연결 상태 확인 로직 추가

  @override
  void initState() {
    super.initState();
    // TODO: _loadCoupleStatus(); // 초기 커플 연결 상태 로드
  }

  Future<void> _disconnectCouple() async {
    // TODO: 실제 백엔드 연동: 연결 해제 API 호출
    setState(() {
      _isConnected = false; // 임시로 연결 해제 상태 변경
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('파트너와 연결이 해제되었습니다.'),
        backgroundColor: AppColors.warmRosePink,
      ),
    );
    // 연결 해제 후 커플 연결 시작 화면으로 이동하거나, 홈 화면의 UI를 변경
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ConnectOptionSelectionScreen()),
    //   (Route<dynamic> route) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '커플 연결 관리',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              title: '현재 파트너',
              content: _isConnected ? _partnerNickname : '연결된 파트너 없음',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 30),
            if (_isConnected)
              _buildActionCard(
                context,
                title: '파트너와 연결 해제',
                description: '파트너와 커플 연결을 해제합니다. 기록된 데이터는 유지됩니다.',
                icon: Icons.link_off,
                iconColor: Colors.redAccent,
                onTap: () {
                  _showDisconnectDialog(context);
                },
              )
            else
              _buildActionCard(
                context,
                title: '파트너와 다시 연결하기',
                description: '새로운 파트너와 연결하거나 기존 파트너와 다시 연결합니다.',
                icon: Icons.link,
                iconColor: AppColors.warmRosePink,
                onTap: () {
                  // TODO: 커플 연결 시작 화면으로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('커플 연결 시작 화면 (TODO)')),
                  );
                },
              ),
            const SizedBox(height: 20),
            Text(
              '※ 파트너와 연결을 해제해도 기존에 기록된 사진과 다이어리 등 데이터는 유지됩니다.',
              style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content, required IconData icon}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 28, color: AppColors.urbanGrey),
              const SizedBox(width: 15),
              Text(
                title,
                style: AppTextStyles.inputLabel.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            content,
            style: AppTextStyles.headerTitle.copyWith(fontSize: 22, color: AppColors.warmRosePink),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required Color iconColor,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Icon(icon, size: 30, color: iconColor),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.inputLabel.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
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
      ),
    );
  }

  void _showDisconnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.softCreamBeige,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('연결 해제 확인', style: AppTextStyles.inputLabel.copyWith(fontWeight: FontWeight.bold)),
          content: Text('정말로 파트너와의 연결을 해제하시겠습니까?', style: AppTextStyles.smallText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: AppTextStyles.linkText.copyWith(color: AppColors.urbanGrey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _disconnectCouple();
              },
              child: Text(
                '해제',
                style: AppTextStyles.linkText.copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}