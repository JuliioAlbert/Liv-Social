import 'package:liv_social/features/domain/repositories/auth_repository.dart';

class EnrollUseCase {
  EnrollUseCase(this.authRepository);
  final AuthRepository authRepository;

  Future<void> createUser(String email, String password) async =>
      await authRepository.createUserByEmailAuth(email, password);
}
