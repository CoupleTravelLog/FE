// lib/presentation/main_app/screens/main_app_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:couple_log/presentation/home/screens/home_screen.dart';
import 'package:couple_log/presentation/travel_log/screens/travel_log_screen.dart';
import 'package:couple_log/presentation/create_content/screens/create_content_screen.dart'; // 이름 변경된 파일 임포트
import 'package:couple_log/presentation/my_page/screens/my_page_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0; // 현재 선택된 탭 인덱스
  final PageController _pageController = PageController(); // 화면 전환을 위한 컨트롤러

  final List<Widget> _screens = [
    const HomeScreen(),
    const TravelLogScreen(),
    // '생성' 탭은 여기서 직접 화면을 보여주지 않고, onTap에서 별도로 처리합니다.
    const Placeholder(), // 인덱스 유지를 위한 플레이스홀더
    const MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) { // '생성' 탭 (인덱스 2)을 눌렀을 때
      _showCreateTravelLogScreen();
    } else {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(index); // 탭 선택 시 해당 페이지로 즉시 이동
    }
  }

  void _showCreateTravelLogScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTravelLogScreen(),
        fullscreenDialog: true, // 모달처럼 전체 화면으로 띄우기
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (index != 2) { // '생성' 탭으로 스크롤해서 이동하는 것은 막음
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        // 물리적 스크롤 비활성화 (네비게이션 바를 통한 이동만 허용)
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white, // 배경색
        selectedItemColor: AppColors.warmRosePink, // 선택된 아이템 색상
        unselectedItemColor: AppColors.lightGrey, // 선택되지 않은 아이템 색상
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // 아이템 개수가 많아도 흔들리지 않게 고정
        selectedLabelStyle: AppTextStyles.smallText.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 12, // 폰트 크기
        ),
        unselectedLabelStyle: AppTextStyles.smallText.copyWith(
          fontSize: 12, // 폰트 크기
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // 선택 시 채워진 아이콘
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: '여행 기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline), // '생성' 아이콘
            activeIcon: Icon(Icons.add_circle),
            label: '생성',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}