class ApiConstants {
  static const String baseUrl = 'http://localhost:5239'; // ✅ غيّره لو في production

  // Auth
  static const String login = '/login';
  static const String register = '/api/auth/register';
  static const String logout = '/api/auth/logout';

  // Profile
  static const String profile = '/api/profile';
  static const String updateProfile = '/api/profile/update';

  // Materials
  static const String materials = '/api/materials';
  static const String addMaterial = '/api/materials/add';
  static const String updateMaterial = '/api/materials/update';

  // Fridge
  static const String fridges = '/api/fridges';
  static const String fridgeDetails = '/api/fridges/details';

  // Chat
  static const String messages = '/api/chat/messages';
  static const String sendMessage = '/api/chat/send';

  // Sell
  static const String sell = '/api/sell';
  static const String sellDetails = '/api/sell/details';
  static const String confirmSell = '/api/sell/confirm';
}
