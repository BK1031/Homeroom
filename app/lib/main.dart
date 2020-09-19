import 'package:firebase/firebase.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/pages/auth/login_page.dart';
import 'package:homeroom_flutter/pages/auth/register_page.dart';
import 'package:homeroom_flutter/pages/classroom/classroom_page.dart';
import 'package:homeroom_flutter/pages/home_page.dart';
import 'package:homeroom_flutter/pages/onboarding_page.dart';
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
  router.define('/classroom/:id', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ClassroomPage(params["id"][0]);
  }));

  runApp(new MaterialApp(
    title: "Homeroom",
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
    initialRoute: '/',
    onGenerateRoute: router.generator,
  ));
}