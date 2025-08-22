import 'package:flutter/material.dart';
import 'package:couple_log/core/constants/app_colors.dart';
import 'package:couple_log/core/constants/app_text_styles.dart';
import 'package:couple_log/data/travel_log_dummy.dart';
import 'package:couple_log/presentation/create_content/screens/create_content_screen.dart';

class TravelLogScreen extends StatelessWidget {
  const TravelLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCreamBeige,
      appBar: AppBar(
        title: Text(
          '여행 기록',
          style: AppTextStyles.headerTitle.copyWith(fontSize: 24),
        ),
        centerTitle: true,
      ),
      // 더미 데이터가 비어있는지 확인하여 다른 UI를 보여줍니다.
      body: travelLogDummyData.isEmpty
          ? _buildEmptyState(context) // 더미 데이터가 없으면 비어있는 상태 UI를 보여줍니다.
          : _buildTravelLogList(context), // 더미 데이터가 있으면 리스트 UI를 보여줍니다.
    );
  }

  // 데이터가 없을 때의 UI
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.map_outlined,
            size: 80,
            color: AppColors.lightGrey,
          ),
          const SizedBox(height: 20),
          Text(
            '우리만의 여행 기록을 시작해보세요!',
            style: AppTextStyles.inputLabel,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            '아직 기록된 여행이 없어요.',
            style: AppTextStyles.smallText.copyWith(color: AppColors.lightGrey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // 새 여행 기록 작성 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTravelLogScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warmRosePink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              '새로운 여행 기록 추가하기',
              style: AppTextStyles.buttonText.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // 데이터가 있을 때의 리스트 UI
  Widget _buildTravelLogList(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // "새로운 기록 추가하기" 버튼
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTravelLogScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warmRosePink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle_outline, color: AppColors.white),
                const SizedBox(width: 8),
                Text(
                  '새로운 기록 추가하기',
                  style: AppTextStyles.buttonText.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 여행 기록 리스트
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // 부모 스크롤뷰에 종속
            itemCount: travelLogDummyData.length,
            itemBuilder: (context, index) {
              final log = travelLogDummyData[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: _buildTravelLogCard(log),
              );
            },
          ),
        ],
      ),
    );
  }

  // 각 여행 기록 카드 위젯
  Widget _buildTravelLogCard(log) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              log.imageUrls.isNotEmpty
                  ? log.imageUrls.first
                  : 'https://via.placeholder.com/600x400?text=이미지+없음',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.title,
                  style: AppTextStyles.headerTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '${log.date.toLocal().toString().split(' ')[0]}',
                  style: AppTextStyles.smallText.copyWith(color: AppColors.urbanGrey),
                ),
                const SizedBox(height: 10),
                Text(
                  log.description,
                  style: AppTextStyles.regularText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}