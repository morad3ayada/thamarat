import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/di/injection_container.dart' as di;
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/auth/auth_event.dart';
import 'logic/blocs/auth/auth_state.dart';
import 'logic/blocs/profile/profile_bloc.dart';
import 'logic/blocs/profile/profile_event.dart';
import 'logic/blocs/materials/materials_bloc.dart';
import 'logic/blocs/vendor/vendor_bloc.dart';
import 'logic/blocs/sell/sell_bloc.dart';
import 'logic/blocs/fridge/fridge_bloc.dart';
import 'logic/blocs/chat/chat_bloc.dart';
import 'logic/blocs/office/office_bloc.dart';
import 'logic/blocs/office/office_event.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/materials_repository.dart';
import 'data/repositories/vendor_repository.dart';
import 'data/repositories/sell_repository.dart';
import 'data/repositories/fridge_repository.dart';
import 'data/repositories/chat_repository.dart';
import 'data/repositories/office_repository.dart';
import 'presentation/screens/home_page.dart';
import 'presentation/screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: GetIt.I<AuthRepository>(),
          ),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            profileRepository: GetIt.I<ProfileRepository>(),
          ),
        ),
        BlocProvider<MaterialsBloc>(
          create: (context) => MaterialsBloc(
            materialsRepository: GetIt.I<MaterialsRepository>(),
          ),
        ),
        BlocProvider<VendorBloc>(
          create: (context) => VendorBloc(
            GetIt.I<VendorRepository>(),
          ),
        ),
        BlocProvider<SellBloc>(
          create: (context) => SellBloc(
            sellRepository: GetIt.I<SellRepository>(),
          ),
        ),
        BlocProvider<FridgeBloc>(
          create: (context) => FridgeBloc(
            fridgeRepository: GetIt.I<FridgeRepository>(),
          ),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => GetIt.I<ChatBloc>(),
        ),
        BlocProvider<OfficeBloc>(
          create: (context) => OfficeBloc(
            officeRepository: GetIt.I<OfficeRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Cairo',
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: const Color(0xFFF9F9F9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFDAF3D7),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color.fromARGB(255, 28, 98, 32),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
            iconTheme: IconThemeData(
              color: Color.fromARGB(255, 28, 98, 32),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 28, 98, 32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color.fromARGB(255, 28, 98, 32)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
        home: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // Check if the widget is still mounted before accessing context
            if (!context.mounted) return;
            
            try {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is AuthInitial) {
                // Check if user actually logged out
                final authBloc = context.read<AuthBloc>();
                if (authBloc.wasUserLogout) {
                  // Reset loaded states when user logs out
                  context.read<ProfileBloc>().resetLoadedState();
                  context.read<OfficeBloc>().resetLoadedState();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تسجيل الخروج بنجاح'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            } catch (e) {
              print('Failed to show snackbar: $e');
            }
          },
          child: InitialDataLoader(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                // Check auth status on app start
                if (state is AuthInitial) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      try {
                        context.read<AuthBloc>().add(CheckAuthStatus());
                      } catch (e) {
                        print('Failed to check auth status: $e');
                      }
                    }
                  });
                }
                
                // Always show LoginScreen for AuthInitial state (logout)
                if (state is AuthInitial) {
                  return const LoginScreen();
                }
                
                // Show HomeScreen for AuthSuccess state (logged in)
                if (state is AuthSuccess) {
                  return const HomeScreen();
                }
                
                // Show LoginScreen for AuthLoading and AuthFailure states
                return const LoginScreen();
              },
            ),
          ),
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

// Widget to load initial data once when app starts
class InitialDataLoader extends StatefulWidget {
  final Widget child;
  
  const InitialDataLoader({super.key, required this.child});

  @override
  State<InitialDataLoader> createState() => _InitialDataLoaderState();
}

class _InitialDataLoaderState extends State<InitialDataLoader> {
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadInitialData() async {
    if (_dataLoaded) return;
    
    try {
      // Load profile and office data once when app starts
      context.read<ProfileBloc>().add(LoadProfile());
      context.read<OfficeBloc>().add(LoadOfficeInfo());
      
      // Mark data as loaded
      setState(() {
        _dataLoaded = true;
      });
    } catch (e) {
      print('Error loading initial data: $e');
      setState(() {
        _dataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        // Load data only when user is authenticated
        if (authState is AuthSuccess && !_dataLoaded) {
          _loadInitialData();
        } else if (authState is AuthInitial) {
          // Reset data loaded flag when user logs out
          setState(() {
            _dataLoaded = false;
          });
        }
      },
      child: widget.child,
    );
  }
}
