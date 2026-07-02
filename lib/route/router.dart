import 'package:flutter/material.dart';
import 'package:news_feeds/route/route_constants.dart';
import 'package:news_feeds/screens/innovation/views/approvedInnovations_screen.dart';
import 'package:news_feeds/screens/users/users.dart';

import '../screens/auth/views/login_screen.dart';
import '../screens/auth/views/password_recovery_screen.dart';
import '../screens/auth/views/signup_screen.dart';
import '../screens/innovation/views/added_for_review_message_screen.dart';
import '../screens/innovation/views/censorship_innovations_page.dart';
import '../screens/innovation/views/my_innovation/index_screen.dart';
import '../screens/main/views/main_screen.dart';
import '../screens/notification/view/notificatios_screen.dart';
import '../screens/innovation/views/add_innovation_screen.dart';
import '../screens/profile/views/components/profile_edit_screen.dart';
import '../screens/profile/views/profile_screen.dart';
import '../screens/research/Components/prompt_screen.dart';
import '../screens/research/Components/research_list_screen.dart';
import '../screens/research/index.dart';
import '../screens/search/views/search_screen.dart';
import '../screens/startup_screen/views/onboarding_screen.dart';
import '../services/DatabaseHelper.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onboardingScreenRoute:
      return MaterialPageRoute(builder: (context) => const StartupScreen());
    case logInScreenRoute:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case signUpScreenRoute:
      return MaterialPageRoute(builder: (context) => const SignUpScreen());
    case researchScreenRoute:
      return MaterialPageRoute(
        builder: (context) => ResearchScreen(dbHelper: DatabaseHelper()),
      );
    case mainScreenRoute:
      return MaterialPageRoute(builder: (context) => MainScreen());
    case promptScreenRoute:
      return MaterialPageRoute(
        builder: (context) => PromptScreen(dbHelper: DatabaseHelper()),
      );
    case researchListScreenRoute:
      return MaterialPageRoute(
        builder: (context) => ResearchListScreen(dbHelper: DatabaseHelper()),
      );
    case passwordRecoveryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PasswordRecoveryScreen(),
      );
    case postAnInnovationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => PostInnovationScreen(),
      );
    case profileScreenRoute:
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    case censorshipInnovationsPageRoute:
      return MaterialPageRoute(
        builder: (context) => CensorshipInnovationsScreen(),
      );
    case notificationsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      );
    case editUserInfoScreenRoute:
      return MaterialPageRoute(builder: (context) => const ProfileEditScreen());
    case searchScreenRoute:
      return MaterialPageRoute(builder: (context) => const SearchScreen());
    case addedForReviewMessageScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const AddedForReviewMessageScreen(),
      );
    case myInnovationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const MyInnovationScreen(),
      );
    case approvedInnovationsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ApprovedInnovationsScreen(),
      );
    case usersScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const UsersScreen(),
      );
    default:
      return MaterialPageRoute(builder: (context) => const StartupScreen());
  }
}
