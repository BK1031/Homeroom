import 'package:firebase/firebase.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/pages/auth/check_auth_page.dart';
import 'package:homeroom_flutter/pages/auth/login_page.dart';
import 'package:homeroom_flutter/pages/auth/register_page.dart';
import 'package:homeroom_flutter/pages/classroom/classroom_chat_page.dart';
import 'package:homeroom_flutter/pages/classroom/classroom_details_page.dart';
import 'package:homeroom_flutter/pages/classroom/classroom_page.dart';
import 'package:homeroom_flutter/pages/home_page.dart';
import 'package:homeroom_flutter/pages/onboarding_page.dart';
import 'package:homeroom_flutter/pages/rooms/room_page.dart';
import 'package:homeroom_flutter/pages/settings/settings_page.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/service_account.dart';
import 'package:homeroom_flutter/utils/theme.dart';

void main() {
  initializeApp(
      apiKey: ServiceAccount.apiKey,
      authDomain: ServiceAccount.authDomain,
      databaseURL: ServiceAccount.databaseUrl,
      projectId: ServiceAccount.projectID,
      storageBucket: ServiceAccount.storageUrl
  );
  // AUTH ROUTES
  router.define('/check-auth', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new CheckAuthPage();
  }));
  router.define('/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));
  router.define('/register', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RegisterPage();
  }));

  // HOME ROUTES
  router.define('/', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new OnboardingPage();
  }));
  router.define('/home', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HomePage();
  }));

  // CLASSROOM ROUTES
  router.define('/classroom', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ClassroomPage();
  }));
  router.define('/classroom/:id', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ClassroomDetailsPage(params["id"][0]);
  }));
  router.define('/classroom/:id/chat', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ClassroomChatPage(params["id"][0]);
  }));

  // ROOM ROUTES
  router.define('/room/:id', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RoomPage(params["id"][0]);
  }));

  // SETTINGS ROUTES
  router.define('/settings', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SettingsPage();
  }));

  runApp(new MaterialApp(
    title: "Homeroom",
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
    initialRoute: '/check-auth',
    onGenerateRoute: router.generator,
  ));
}