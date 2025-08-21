// lib/presentation/auth/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:couple_log/core/utils/form_validators.dart';
import 'package:couple_log/data/auth/repositories/auth_repository.dart';
import 'package:couple_log/presentation/auth/widgets/auth_input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final MockAuthRepository _authRepository = MockAuthRepository();
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _authRepository.signUp(
          _emailController.text,
          _passwordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('회원가입이 완료되었습니다!'),
              backgroundColor: AppColors.warmRosePink,
            ),
          );
          Navigator.pop(context); // 회원가입 성공 후 이전 화면(로그인)으로 돌아가기
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
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('약관 및 정책에 동의해주세요.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text('회원가입', style: AppTextStyles.linkText.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 24),
                Text(
                  'Take our first step together.', // 회원가입 화면 환영 메시지
                  style: AppTextStyles.headerTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                AuthInputField(
                  label: '이메일',
                  placeholder: '이메일 주소를 입력해주세요',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidators.validateEmail,
                ),
                const SizedBox(height: 24),
                AuthInputField(
                  label: '비밀번호',
                  placeholder: '비밀번호 (8자 이상)',
                  controller: _passwordController,
                  isPassword: true,
                  validator: FormValidators.validatePassword,
                ),
                const SizedBox(height: 24),
                AuthInputField(
                  label: '비밀번호 확인',
                  placeholder: '비밀번호를 다시 입력해주세요',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: (value) =>
                      FormValidators.validateConfirmPassword(value, _passwordController.text),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _agreeToTerms = newValue ?? false;
                        });
                      },
                      activeColor: AppColors.warmRosePink,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreeToTerms = !_agreeToTerms; // 텍스트 탭 시 체크박스 토글
                          });
                        },
                        child: Text(
                          '개인정보처리방침 및 서비스 이용약관에 동의합니다.',
                          style: AppTextStyles.smallText.copyWith(
                            decoration: TextDecoration.underline, // 링크처럼 보이게
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading || !_agreeToTerms ? null : _signup,
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
                      '회원가입',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}