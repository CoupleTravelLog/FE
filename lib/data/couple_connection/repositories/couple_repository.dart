// 커플 연결 로직 추상화 (Placeholder)

abstract class CoupleRepository {
  Future<String> generateInviteCode(); // 초대 코드 생성
  Future<void> connectWithCode(String code); // 초대 코드로 연결
  Future<bool> isCoupleConnected(); // 커플 연결 여부 확인 (추후 구현)
// Future<void> disconnectCouple(); // 연결 해제 (추후 구현)
}

// 백엔드 연결 전까지 사용할 Mock 구현체
class MockCoupleRepository implements CoupleRepository {
  String? _currentInviteCode;
  // bool _isCurrentlyConnected = false; // 실제 백엔드에서는 로그인된 사용자 정보 기반

  @override
  Future<String> generateInviteCode() async {
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 흉내
    // 간단한 6자리 코드 생성 (실제는 더 복잡한 로직)
    _currentInviteCode = (DateTime.now().millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');
    print('Generated Mock Invite Code: $_currentInviteCode');
    return _currentInviteCode!;
  }

  @override
  Future<void> connectWithCode(String code) async {
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 흉내
    if (_currentInviteCode == code && code != 'invalid_code') { // 'invalid_code'는 테스트용 실패 코드
      // _isCurrentlyConnected = true; // 실제 연결 성공 시 상태 변경
      print('Mock Connection successful with code: $code');
    } else {
      print('Mock Connection failed with code: $code');
      throw Exception('유효하지 않거나 만료된 코드입니다.');
    }
  }

  @override
  Future<bool> isCoupleConnected() async {
    // 실제 백엔드에서는 사용자 UID를 기반으로 연결 여부 확인
    await Future.delayed(const Duration(milliseconds: 500));
    return false; // 일단은 연결 안 된 상태로 가정하여 커플 연결 플로우 유도
  }
}