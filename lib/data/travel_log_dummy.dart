import 'package:couple_log/data/travel_log.dart';

final List<TravelLog> travelLogDummyData = [
  TravelLog(
    id: '1',
    title: '제주도 푸른 밤의 추억',
    date: DateTime(2025, 7, 15),
    description: '제주도에서 보낸 아름다운 밤. 성산일출봉에서 바라본 야경이 잊혀지지 않네요. 맛있는 해산물 요리도 최고였어요!',
    imageUrls: [
      'https://via.placeholder.com/600x400?text=제주도+여행+1',
      'https://via.placeholder.com/600x400?text=제주도+여행+2',
    ],
  ),
  TravelLog(
    id: '2',
    title: '부산 해운대 여름 바다',
    date: DateTime(2025, 8, 10),
    description: '뜨거운 햇살 아래 해운대에서 즐거운 시간을 보냈어요. 시원한 바다에 발을 담그니 모든 스트레스가 사라지는 것 같았어요!',
    imageUrls: [
      'https://via.placeholder.com/600x400?text=부산+여행+1',
      'https://via.placeholder.com/600x400?text=부산+여행+2',
    ],
  ),
  TravelLog(
    id: '3',
    title: '강릉 커피거리 데이트',
    date: DateTime(2025, 6, 25),
    description: '강릉 안목해변의 커피거리에서 맛있는 커피와 함께 데이트를 즐겼어요. 조용한 분위기가 정말 좋았네요.',
    imageUrls: [
      'https://via.placeholder.com/600x400?text=강릉+여행+1',
      'https://via.placeholder.com/600x400?text=강릉+여행+2',
    ],
  ),
];