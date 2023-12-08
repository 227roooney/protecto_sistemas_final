import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_map/screens/building_details/bloc/buildings_bloc.dart';
import 'package:uni_map/screens/home.dart';
import 'package:uni_map/screens/splash.dart';
import 'package:uni_map/screens/auth_screens/waiting_verification.dart';
import 'firebase_options.dart';

import 'package:uni_map/screens/auth_screens/auth.dart';

var kTextTabBarHeight = 48.0;

Future<bool> checkEmailVerified(User user) async {
  await user.reload();
  return user.emailVerified;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BuildingBloc>(
          create: (context) => BuildingBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'UniMap',
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 28, 1, 12)),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (snapshot.hasData) {
              final user = snapshot.data as User;

              if (!user.emailVerified) {
                return FutureBuilder(
                  future: checkEmailVerified(user),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const WaitingVerificationScreen();
                    }

                    if (snapshot.data!) {
                      return const HomeScreen();
                    } else {
                      return const WaitingVerificationScreen();
                    }
                  },
                );
              }

              return const HomeScreen();
            }

            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
