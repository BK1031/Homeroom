import 'package:fluro/fluro.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:homeroom_flutter/models/user.dart';

import '../models/version.dart';

Version appVersion = new Version("1.0.4+1");
String appStatus = "";
String appFull = "Version ${appVersion.toString()}";

final router = new Router();

User currUser = new User();

List<String> defaultProfilePics = [
  "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile-1.png?alt=media&token=c4e7902e-d9ef-47e4-9aa5-4b21bbc4190e"
  "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile-2.png?alt=media&token=807a00c7-dc41-45f5-b76f-521e221414ce",
  "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile-3.png?alt=media&token=d47805a6-b6bb-49cd-8777-c18d430e7852",
  "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile-4.png?alt=media&token=64303288-33a9-4935-b428-5d9b0a17dc2a",
  "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile-5.png?alt=media&token=a27e5154-997f-48d1-aa6a-da7b51815db7",
  "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile-6.png?alt=media&token=0718ed8b-662b-4b60-a436-3596b1f85802",
  "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile-7.png?alt=media&token=f8372e79-7465-4827-b63a-2068632bbf6f",
  "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile-8.png?alt=media&token=362ff6f7-2f15-44f7-bc02-f45781d84172"
];

String appLegal = """
MIT License
Copyright (c) 2020 Equinox Initiative
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
""";