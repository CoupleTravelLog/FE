// 백 연동 전까지 사용할 인증 서비스 인터페이스

abstract class AuthRepository {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
// Future<void> signOut(); // 추후 추가 가능
// Future<String?> getCurrentUserUid(); // 추후 추가 가능
}

// 실제 Firebase 연동 시 이 클래스를 구현합니다. (Placeholder for now)
class MockAuthRepository implements AuthRepository {
  @override
  Future<void> signIn(String email, String password) async {
    // 실제 백엔드 로직 (Firebase Auth 등)이 여기에 들어갈 예정
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 흉내
    if (email == 'test@example.com' && password == 'password123') {
      print('Mock sign in successful for $email');
      // 성공 처리
    } else {
      print('Mock sign in failed for $email');
      throw Exception('이메일 또는 비밀번호가 일치하지 않습니다.');
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    // 실제 백엔드 로직 (Firebase Auth 등)이 여기에 들어갈 예정
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 흉내
    if (email.contains('exist')) { // 예시: 이미 존재하는 이메일
      throw Exception('이미 가입된 이메일 주소입니다.');
    }
    print('Mock sign up successful for $email');
    // 성공 처리
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // 실제 백엔드 로직 (Firebase Auth 등)이 여기에 들어갈 예정
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 흉내
    if (email.contains('notfound')) { // 예시: 등록되지 않은 이메일
      throw Exception('등록되지 않은 이메일 주소입니다.');
    }
    print('Mock password reset email sent to $email');
    // 성공 처리
  }
}