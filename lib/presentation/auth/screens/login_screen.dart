
import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:couple_log/core/utils/form_validators.dart';
import 'package:couple_log/data/auth/repositories/auth_repository.dart'; // Mock Auth Repository 사용
import 'package:couple_log/presentation/auth/widgets/auth_input_field.dart';
import 'package:couple_log/presentation/auth/screens/signup_screen.dart'; // 회원가입 화면
import 'package:couple_log/presentation/auth/screens/forgot_password_screen.dart'; // 비밀번호 찾기 화면
import 'package:couple_log/presentation/couple_connection/screens/couple_connection_guide_screen.dart'; // 커플 연결 화면 (추후 구현)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MockAuthRepository _authRepository = MockAuthRepository(); // 백엔드 연결 시 FirebaseAuthRepository 등으로 교체
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _authRepository.signIn(
          _emailController.text,
          _passwordController.text,
        );
        if (mounted) {
          // 로그인 성공 시 커플 연결 화면 또는 홈 화면으로 이동
          // TODO: 실제 앱에서는 로그인 성공 후 커플 연결 여부 확인 로직 필요
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CoupleConnectionGuideScreen()), // 이 부분 수정!
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 앱 로고
                Image.asset(
                  'assets/images/app_logo.png', // 앱 로고 이미지 경로
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 32),
                Text(
                  '우리의 여정을 시작해봐요.', // 로그인 화면 환영 메시지
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
                  placeholder: '비밀번호를 입력해주세요',
                  controller: _passwordController,
                  isPassword: true,
                  validator: FormValidators.validatePassword,
                  onFieldSubmitted: (value) => _login(), // 엔터키로 로그인 시도
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
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
                      '로그인',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      '비밀번호를 잊으셨나요?',
                      style: AppTextStyles.linkText.copyWith(color: AppColors.lightGrey, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 없으신가요?',
                      style: AppTextStyles.linkText.copyWith(color: AppColors.urbanGrey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                        );
                      },
                      child: Text(
                        '회원가입',
                        style: AppTextStyles.linkText.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}