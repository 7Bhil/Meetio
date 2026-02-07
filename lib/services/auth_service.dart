class AuthService {
  Future<User?> signIn(String email, String password) {}
  Future<User?> signUp(String name, String email, String password) {}
  Future<void> signOut() {}
}