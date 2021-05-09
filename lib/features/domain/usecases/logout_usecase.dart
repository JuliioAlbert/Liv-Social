import 'package:liv_social/features/domain/repositories/auth_repository.dart';

class LogOutUseCase {
  LogOutUseCase(this.authRepository);
  final AuthRepository authRepository;

  Future<void> logout() async => await authRepository.logout();
}
