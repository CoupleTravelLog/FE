// lib/presentation/couple_connection/screens/generate_share_invite_code_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 클립보드 복사를 위해 필요
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:couple_log/data/couple_connection/repositories/couple_repository.dart';
import 'package:couple_log/presentation/home/screens/home_screen.dart'; // 임시 홈 화면
import 'package:couple_log/presentation/main_app/screens/main_app_screen.dart'; // MainAppScreen 임포트

class GenerateShareInviteCodeScreen extends StatefulWidget {
  const GenerateShareInviteCodeScreen({super.key});

  @override
  State<GenerateShareInviteCodeScreen> createState() =>
      _GenerateShareInviteCodeScreenState();
}

class _GenerateShareInviteCodeScreenState
    extends State<GenerateShareInviteCodeScreen> {
  String _inviteCode = '생성 중...';
  bool _isLoading = false;
  final MockCoupleRepository _coupleRepository = MockCoupleRepository();

  @override
  void initState() {
    super.initState();
    _generateCode();
  }

  Future<void> _generateCode() async {
    setState(() {
      _isLoading = true;
      _inviteCode = '생성 중...';
    });
    try {
      final code = await _coupleRepository.generateInviteCode();
      if (mounted) {
        setState(() {
          _inviteCode = code;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _inviteCode = '오류 발생';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('코드 생성 실패: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _copyCodeToClipboard() {
    Clipboard.setData(ClipboardData(text: _inviteCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('초대 코드가 클립보드에 복사되었습니다!'),
        backgroundColor: AppColors.warmRosePink,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '초대 코드 보내기',
          style: AppTextStyles.linkText.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '아래 코드를 파트너에게 전달해주세요.',
              style: AppTextStyles.smallText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warmRosePink, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warmRosePink.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Center(
                  child: CircularProgressIndicator(color: AppColors.warmRosePink))
                  : Text(
                _inviteCode,
                style: AppTextStyles.headerTitle.copyWith(
                  fontSize: 48,
                  color: AppColors.warmRosePink,
                  letterSpacing: 4.0, // 코드 간격
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '코드 유효 시간: 15분 (임시)', // TODO: 실제 타이머 구현
              style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _copyCodeToClipboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warmRosePink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '코드 복사',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _generateCode,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.lightGrey, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '새 코드 생성',
                  style: AppTextStyles.buttonText.copyWith(color: AppColors.urbanGrey),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '파트너에게 커플로그 앱을 다운로드하고 이 코드를 입력하라고 안내해주세요.',
              style: AppTextStyles.smallText,
              textAlign: TextAlign.center,
            ),
            const Spacer(), // 하단 여백을 채움
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 실제 연결 대기 로직 또는 홈으로 이동 후 백그라운드에서 연결 대기
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainAppScreen()), // 이 부분 수정!
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mellowLavender, // 보조색 사용
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '연결 대기 중 / 홈으로 이동',
                  style: AppTextStyles.buttonText.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}