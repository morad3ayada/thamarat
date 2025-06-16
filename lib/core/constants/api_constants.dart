class ApiConstants {
  // Base URL for the API
  static const String baseUrl = 'https://thamarat.runasp.net/api/mobile/';

  // Auth
  static const String login = 'auth/login';
  static const String logout = 'auth/logout';

  // Office
  static const String officeInfo = 'office-info';

  // Customers
  static const String customers = 'customers';
  static const String addCustomer = 'customers/add';

  // Sale Processes
  static const String saleProcesses = 'sale-processes';
  static const String getSaleProcess = 'sale-processes/'; // + {id}
  static const String addSaleProcess = 'sale-processes/add';
  static const String sendToOffice = 'sale-processes/'; // + {id}/send-to-office

  // Materials
  static const String materials = 'trucks/materials'; // Get all materials from trucks
  static const String addMaterial = 'sale-processes/materials/add';
  static const String deleteMaterial = 'sale-processes/materials/delete';

  // Trucks
  static const String trucks = 'trucks';
  static const String truckById = 'trucks/'; // + {id}

  // Fridges
  static const String fridges = 'trucks'; // Using trucks endpoint for fridges
  static const String fridgeById = 'trucks/'; // + {id}

  // Profile
  static const String profile = 'profile';
  static const String editProfile = 'profile/edit';

  // Chat
  static const String chatMessages = 'chat/messages';
  static const String sendChatMessage = 'chat/send';
}
