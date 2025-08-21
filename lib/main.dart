import 'package:flutter/material.dart';
import 'package:couple_log/presentation/onboarding/screens/splash_screen.dart'; // 스플래시 화면 임포트
import 'package:couple_log/core/constants/app_colors.dart'; // 색상 상수 임포트
// import 'package:couple_log/presentation/my_page/screens/contact_feedback_screen.dart'; // 추가


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Couple Log Demo',
      theme: ThemeData(
        primaryColor: AppColors.warmRosePink, // 앱의 주 색상 설정
        scaffoldBackgroundColor: AppColors.softCreamBeige, // Scaffold 기본 배경색 설정
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.softCreamBeige,
          elevation: 0, // AppBar 그림자 없앰
          iconTheme: IconThemeData(color: AppColors.urbanGrey), // AppBar 아이콘 색상
        ),
        // 다른 테마 설정들을 여기에 추가할 수 있습니다.
      ),
      home: const SplashScreen(), // 앱 시작 시 스플래시 화면을 보여줍니다.
      debugShowCheckedModeBanner: false, // 디버그 배너 숨김
    );
  }
}