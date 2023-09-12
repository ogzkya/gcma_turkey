import 'package:flutter/material.dart';
import 'package:gcma_v1/services/auth_service.dart';
import 'package:gcma_v1/screens/admin/admin_home_screen.dart';
import 'package:gcma_v1/screens/moderator/moderator_home_screen.dart';
import 'package:gcma_v1/screens/user/user_home_screen.dart';
import 'package:gcma_v1/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'localization.dart';
import 'package:location/location.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Locale> _getLocale() async {
    final locationData = await Location().getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      // Kullanıcının konumuna göre dil belirleyin
      // Örnek olarak Türkiye koordinatlarına göre Türkçe seçiyoruz
      if (locationData.latitude! > 36 &&
          locationData.latitude! < 42 &&
          locationData.longitude! > 26 &&
          locationData.longitude! < 45) {
        return Locale('tr', 'TR');
      }
    }
    return Locale('en', 'US');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
          title: 'GCMA',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.green,
            errorColor: Colors.red,
            brightness: Brightness.light,
            textTheme: TextTheme(
              bodyText2: TextStyle(fontSize: 16),
            ),
          ),
          home: const AppHome(),
          routes: {
            '/Admin': (context) => const AdminHomeScreen(),
            '/Moderator': (context) => ModeratorHomeScreen(),
            '/User': (context) => UserHomeScreen(),
          }),
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserRole>(
      stream: _authService.userRoleStream,
      builder: (BuildContext context, AsyncSnapshot<UserRole> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final userRole = snapshot.data;
          if (userRole == UserRole.admin) {
            return const AdminHomeScreen();
          } else if (userRole == UserRole.moderator) {
            return ModeratorHomeScreen();
          } else if (userRole == UserRole.user) {
            return UserHomeScreen();
          } else {
            return LoginScreen();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
