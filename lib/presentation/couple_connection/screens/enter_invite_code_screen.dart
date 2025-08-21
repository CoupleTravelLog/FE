// lib/presentation/couple_connection/screens/enter_invite_code_screen.dart

import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:couple_log/data/couple_connection/repositories/couple_repository.dart';
import 'package:couple_log/presentation/auth/widgets/auth_input_field.dart'; // 공통 입력 필드 재사용
import 'package:couple_log/presentation/home/screens/home_screen.dart'; // 임시 홈 화면
import 'package:couple_log/presentation/main_app/screens/main_app_screen.dart'; // MainAppScreen 임포트

class EnterInviteCodeScreen extends StatefulWidget {
  const EnterInviteCodeScreen({super.key});

  @override
  State<EnterInviteCodeScreen> createState() => _EnterInviteCodeScreenState();
}

class _EnterInviteCodeScreenState extends State<EnterInviteCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final MockCoupleRepository _coupleRepository = MockCoupleRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String? _validateInviteCode(String? value) {
    if (value == null || value.isEmpty) {
      return '초대 코드를 입력해주세요.';
    }
    if (value.length != 6) {
      return '코드는 6자리여야 합니다.';
    }
    // 추가적인 형식 검사 (예: 숫자+영문 조합)
    return null;
  }

  void _connectWithCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _coupleRepository.connectWithCode(_codeController.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('커플 연결 완료!'),
              backgroundColor: AppColors.warmRosePink,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainAppScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '초대 코드 입력하기',
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
              '파트너에게 받은 초대 코드를 입력해주세요.',
              style: AppTextStyles.smallText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: AuthInputField(
                label: '초대 코드',
                placeholder: '6자리 코드를 입력해주세요',
                controller: _codeController,
                keyboardType: TextInputType.text, // 코드 유형에 따라 변경 (예: TextInputType.number)
                validator: _validateInviteCode,
                onFieldSubmitted: (value) => _connectWithCode(),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _connectWithCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warmRosePink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : Text(
                  '연결하기',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}