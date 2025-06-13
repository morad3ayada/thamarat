class ApiConstants {
  static const String baseUrl = 'http://localhost:5239'; // ✅ غيّره لو في production

  // Auth
  static const String login = '/api/mobile/login'; // (POST) Login
  //static const String register = '/api/auth/register'; // Discard
  static const String logout = '/api/mobile/logout'; // (POST) Logout (Not done yet)

  // Profile
  static const String profile = '/api/mobile/permissions'; // (GET) Get seller data and permissions
  static const String updateProfile = '/api/mobile/profile'; // (POST) Update seller data (Not done yet)

  // Materials
  //static const String materials = '/api/mobile/materials'; // Discard
  static const String addMaterial = '/api/mobile/sale-processes/materials'; // (POST) Add a material to sale process
  //static const String updateMaterial = '/api/mobile/materials/update'; // Discard

  // Fridge
  static const String fridges = '/api/mobile/trucks'; // (GET) Show trucks with thier materials
  //static const String fridgeDetails = '/api/mobile/fridges/details'; // Discard

  // Chat
  static const String messages = '/api/mobile/chat/messages'; // (GET) Show all seller messages (Not done yet)
  static const String sendMessage = '/api/mobile/chat/send'; // (POST) Send a message to the office (Not done yet)

  // Sell
  static const String sell = '/api/mobile/sale-processes'; // (GET) Show sale processes with their details
  //static const String sellDetails = '/api/mobile/sell/details'; // Discard
  //static const String confirmSell = '/api/mobile/sell/confirm'; // Discard
}