import 'package:flutter/material.dart';

import '../screens/home/index.dart';
import '../screens/innovation/views/added_for_review_message_screen.dart';
import '../screens/innovation/views/innovation_details_screen.dart';
import '../screens/main/views/main_screen.dart';
import '../screens/notification/view/notificatios_screen.dart';
import '../screens/preferences/views/preferences_screen.dart';
import '../screens/innovation/views/add_innovation_screen.dart';
import '../screens/profile/views/components/profile_edit_screen.dart';
import '../screens/profile/views/components/profile_view_screen.dart';
import '../screens/profile/views/profile_screen.dart';
import '../screens/home/Components/prompt_screen.dart';
import '../screens/home/Components/response_list_screen.dart';
import '../screens/search/views/search_screen.dart';
import '../services/DatabaseHelper.dart';
import 'screen_export.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case signUpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => HomeScreen(dbHelper: DatabaseHelper()),
      );
    case mainScreenRoute:
      return MaterialPageRoute(
        builder: (context) => MainScreen(),
      );
    case promptScreenRoute:
      return MaterialPageRoute(
        builder: (context) => PromptScreen(dbHelper: DatabaseHelper()),
      );
    case responseScreenRoute:
      return MaterialPageRoute(
        builder: (context) => ResponseListScreen(dbHelper: DatabaseHelper()),
      );
    case passwordRecoveryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PasswordRecoveryScreen(),
      );
    case preferencesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PreferencesScreen(),
      );
    case postAnInnovationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => PostInnovationScreen(dbHelper: DatabaseHelper()),
      );
    case profileScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );
  case productDetailsScreenRoute:
    return MaterialPageRoute(
      builder: (context) {
        bool isProductAvailable = settings.arguments as bool? ?? true;
        return InnovationDetailsScreen(isAdmin: isProductAvailable);
      },
    );
    case notificationsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      );
  case editUserInfoScreenRoute:
    return MaterialPageRoute(
      builder: (context) => const ProfileEditScreen(),
    );
  case userInfoScreenRoute:
    return MaterialPageRoute(
      builder: (context) => const ProfileViewScreen(),
    );
  case searchScreenRoute:
    return MaterialPageRoute(
      builder: (context) => const SearchScreen(),
    );
    case addedForReviewMessageScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const AddedForReviewMessageScreen(),
      );
  // case onSaleScreenRoute:
  //   return MaterialPageRoute(
  //     builder: (context) => const OnSaleScreen(),
  //   );
   // case profileSetupScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProfileSetupScreen(),
    //   );
    // case verificationMethodScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const VerificationMethodScreen(),
    //   );
    // case otpScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OtpScreen(),
    //   );
    // case newPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SetNewPasswordScreen(),
    //   );
    // case doneResetPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DoneResetPasswordScreen(),
    //   );

    // case signUpVerificationScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SignUpVerificationScreen(),
    //   );

    // case productReviewsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProductReviewsScreen(),
    //   );
    // case addReviewsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddReviewScreen(),
    //   );


    // case onSaleScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OnSaleScreen(),
    //   );
    // case kidsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const KidsScreen(),
    //   );

    // case bookmarkScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const BookmarkScreen(),
    //   );
    // case getHelpScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const GetHelpScreen(),
    //   );
    // case chatScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ChatScreen(),
    //   );

    // case currentPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CurrentPasswordScreen(),
    //   );

    // case noNotificationScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoNotificationScreen(),
    //   );
    // case enableNotificationScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EnableNotificationScreen(),
    //   );
    // case notificationOptionsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NotificationOptionsScreen(),
    //   );
    // case selectLanguageScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SelectLanguageScreen(),
    //   );
    // case noAddressScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoAddressScreen(),
    //   );
    // case addressesScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddressesScreen(),
    //   );
    // case addNewAddressesScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewAddressScreen(),
    //   );
    // case ordersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrdersScreen(),
    //   );
    // case orderProcessingScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderProcessingScreen(),
    //   );
    // case orderDetailsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderDetailsScreen(),
    //   );
    // case cancleOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancleOrderScreen(),
    //   );
    // case deliveredOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DelivereOrdersdScreen(),
    //   );
    // case cancledOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancledOrdersScreen(),
    // //   );

    // case emptyPaymentScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EmptyPaymentScreen(),
    //   );
    // case emptyWalletScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EmptyWalletScreen(),
    //   );
    // case walletScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const WalletScreen(),
    //   );
    // case cartScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CartScreen(),
    //   );
    // case paymentMethodScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const PaymentMethodScreen(),
    //   );
    // case addNewCardScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewCardScreen(),
    //   );
    // case thanksForOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ThanksForOrderScreen(),
    //   );
    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (context) => const OnBordingScreen(),
      );
  }
}
