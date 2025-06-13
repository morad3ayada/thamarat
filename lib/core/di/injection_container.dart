import 'package:get_it/get_it.dart';
import '../api/api_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/materials_repository.dart';
import '../../data/repositories/vendor_repository.dart';
import '../../data/repositories/sell_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // Core
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<MaterialsRepository>(
    () => MaterialsRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<VendorRepository>(
    () => VendorRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<SellRepository>(
    () => SellRepository(getIt<ApiService>()),
  );
} 