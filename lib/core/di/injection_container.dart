import 'package:get_it/get_it.dart';
import '../api/api_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/materials_repository.dart';
import '../../data/repositories/vendor_repository.dart';
import '../../data/repositories/sell_repository.dart';
import '../../data/repositories/fridge_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/office_repository.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/profile/profile_bloc.dart';
import '../../logic/blocs/materials/materials_bloc.dart';
import '../../logic/blocs/vendor/vendor_bloc.dart';
import '../../logic/blocs/sell/sell_bloc.dart';
import '../../logic/blocs/fridge/fridge_bloc.dart';
import '../../logic/blocs/chat/chat_bloc.dart';
import '../../logic/blocs/office/office_bloc.dart';

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
  getIt.registerLazySingleton<FridgeRepository>(
    () => FridgeRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<OfficeRepository>(
    () => OfficeRepository(getIt<ApiService>()),
  );

  // Blocs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(profileRepository: getIt<ProfileRepository>()),
  );
  getIt.registerFactory<MaterialsBloc>(
    () => MaterialsBloc(materialsRepository: getIt<MaterialsRepository>()),
  );
  getIt.registerFactory<VendorBloc>(
    () => VendorBloc(getIt<VendorRepository>()),
  );
  getIt.registerFactory<SellBloc>(
    () => SellBloc(sellRepository: getIt<SellRepository>()),
  );
  getIt.registerFactory<FridgeBloc>(
    () => FridgeBloc(fridgeRepository: getIt<FridgeRepository>()),
  );
  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(chatRepository: getIt<ChatRepository>()),
  );
  getIt.registerFactory<OfficeBloc>(
    () => OfficeBloc(officeRepository: getIt<OfficeRepository>()),
  );
} 