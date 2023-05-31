import 'package:flutter_app_mucb/Fragments/ChangePasswordPage.dart';

import '../Fragments/HomePage.dart';
import '../Fragments/AssignedPage.dart';
import '../Fragments/ScheduledPage.dart';
import '../Fragments/OnHoldPage.dart';
import '../Fragments/InProgressPage.dart';
import '../Fragments/ReadyToReviewPage.dart';
import '../Fragments/CompletePage.dart';
class pageRoutes {
  static const String home = homePage.routeName;
  static const String assigned = assignedPage.routeName;
  static const String scheduled = scheduledPage.routeName;
  static const String onhold = onHoldPage.routeName;
  static const String inprogress = inProgressPage.routeName;
  static const String readytoreview = readyToReviewPage.routeName;
  static const String completed = completePage.routeName;
  static const String changePassword = ChangePasswordPage.routeName;

}