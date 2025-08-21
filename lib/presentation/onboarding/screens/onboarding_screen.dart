// lib/presentation/onboarding/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/presentation/onboarding/widgets/onboarding_page_content.dart';

import '../../auth/screens/login_screen.dart';
// import 'package:couple_log_app/presentation/auth/screens/login_screen.dart'; // 로그인 화면으로 연결 (추후 구현)

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingPages = [
    {
      'image': 'assets/images/onboarding_icon_1.png',
      'title': '시작되는 우리의 특별한 여정',
      'description': '커플로그에서 우리만의 특별한 여정을 시작해요.\n둘만의 공간에서 사랑을 키워보세요.',
    },
    {
      'image': 'assets/images/onboarding_icon_2.png',
      'title': '모든 추억을 담아내는 지도',
      'description': '함께 떠난 모든 곳을 지도 위에 기록하고 추억하세요.\n우리의 발자취가 지도가 되는 곳.',
    },
    {
      'image': 'assets/images/onboarding_icon_3.png',
      'title': '소중한 순간들을 기록하는 다이어리',
      'description': '사진과 이야기로 사랑의 순간들을 영원히 간직할 수 있어요.\n우리만의 비밀스러운 다이어리.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageContent(
                imagePath: onboardingPages[index]['image']!,
                title: onboardingPages[index]['title']!,
                description: onboardingPages[index]['description']!,
              );
            },
          ),
          Positioned(
            bottom: 60, // 하단 내비게이션 바 높이 고려
            left: 24,
            right: 24,
            child: Column(
              children: [
                // 페이지 인디케이터
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingPages.length,
                        (index) => buildDot(index, context),
                  ),
                ),
                const SizedBox(height: 30),
                // 다음 / 시작하기 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < onboardingPages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        // 마지막 페이지: 로그인/회원가입 화면으로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()), // 여기를 수정!
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warmRosePink, // 로즈 핑크 버튼
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // 부드러운 모서리
                      ),
                      elevation: 0, // 그림자 없앰
                    ),
                    child: Text(
                      _currentPage == onboardingPages.length - 1 ? '커플로그 시작하기' : '다음',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // 버튼과 건너뛰기 사이 간격
                // 건너뛰기 버튼 (마지막 페이지 제외)
                if (_currentPage < onboardingPages.length - 1)
                  TextButton(
                    onPressed: () {
                      // 마지막 페이지로 바로 이동
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()), // 여기도 수정!
                      );
                    },
                    child: Text(
                      '건너뛰기',
                      style: GoogleFonts.notoSansKr(
                        fontSize: 16,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 페이지 인디케이터 도트 위젯
  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.warmRosePink : AppColors.mellowLavender.withOpacity(0.6),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}