import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My Booking'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @welcomeToBooking.
  ///
  /// In en, this message translates to:
  /// **'Welcome to my booking '**
  String get welcomeToBooking;

  /// No description provided for @ultimateDestination.
  ///
  /// In en, this message translates to:
  /// **'Your ultimate destination for reservations'**
  String get ultimateDestination;

  /// No description provided for @chooseOne.
  ///
  /// In en, this message translates to:
  /// **'Choose one of the options to enjoy the application services'**
  String get chooseOne;

  /// No description provided for @facilityTypes.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilityTypes;

  /// No description provided for @showFacilities.
  ///
  /// In en, this message translates to:
  /// **'Show Facilities'**
  String get showFacilities;

  /// No description provided for @hotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get hotel;

  /// No description provided for @hall.
  ///
  /// In en, this message translates to:
  /// **'Wedding Hall'**
  String get hall;

  /// No description provided for @noHotel.
  ///
  /// In en, this message translates to:
  /// **'There are no hotels available at the moment.'**
  String get noHotel;

  /// No description provided for @chalet.
  ///
  /// In en, this message translates to:
  /// **'Chalet'**
  String get chalet;

  /// No description provided for @noChalet.
  ///
  /// In en, this message translates to:
  /// **'There are no chalets available at the moment.'**
  String get noChalet;

  /// No description provided for @checkYourInternetConnectionOrTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection or try again.'**
  String get checkYourInternetConnectionOrTryAgain;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get thisFieldIsRequired;

  /// No description provided for @nameFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name field is required.'**
  String get nameFieldIsRequired;

  /// No description provided for @emailFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email field is required.'**
  String get emailFieldIsRequired;

  /// No description provided for @thisIsNotAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'This is not a valid email.'**
  String get thisIsNotAValidEmail;

  /// No description provided for @passwordFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password field is required.'**
  String get passwordFieldIsRequired;

  /// No description provided for @newPasswordFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'New password field is required.'**
  String get newPasswordFieldIsRequired;

  /// No description provided for @confirmNewPasswordFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password field is required.'**
  String get confirmNewPasswordFieldIsRequired;

  /// No description provided for @notMatchedWithNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Does not match with new password.'**
  String get notMatchedWithNewPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @phoneFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone field is required.'**
  String get phoneFieldIsRequired;

  /// No description provided for @phoneFieldAcceptsDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'Phone field accepts digits only.'**
  String get phoneFieldAcceptsDigitsOnly;

  /// No description provided for @thisFieldAcceptsDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'This field accepts digits only.'**
  String get thisFieldAcceptsDigitsOnly;

  /// No description provided for @unableToOpenPhoneApp.
  ///
  /// In en, this message translates to:
  /// **'Unable to open phone app.'**
  String get unableToOpenPhoneApp;

  /// No description provided for @youAreNotConnectedToTheInternet.
  ///
  /// In en, this message translates to:
  /// **'You are not connected to the internet.'**
  String get youAreNotConnectedToTheInternet;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @doYouForgetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get doYouForgetYourPassword;

  /// No description provided for @byProceedingYouAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'By proceeding, you agree to the'**
  String get byProceedingYouAgreeToThe;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @newContact.
  ///
  /// In en, this message translates to:
  /// **'New Contact'**
  String get newContact;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @usingSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Using system settings'**
  String get usingSystemSettings;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @unauthorizedMessage.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view this content.'**
  String get unauthorizedMessage;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get pleaseEnterYourEmail;

  /// No description provided for @passwordResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to your email.'**
  String get passwordResetLinkSent;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get accountCreatedSuccessfully;

  /// No description provided for @pleaseCheckYourEmailForVerification.
  ///
  /// In en, this message translates to:
  /// **'Please check your email for verification.'**
  String get pleaseCheckYourEmailForVerification;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found with this email.'**
  String get userNotFound;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settings_desc.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get settings_desc;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful.'**
  String get loginSuccessful;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get pleaseEnterYourPassword;

  /// No description provided for @pleaseAcceptTheTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and conditions.'**
  String get pleaseAcceptTheTerms;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials.'**
  String get invalidCredentials;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile update failed. Please try again.'**
  String get profileUpdateFailed;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and conditions'**
  String get agreeToTerms;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @button.
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get button;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Please read the terms and conditions carefully before using the application. By using this application, you agree to abide by these terms.'**
  String get terms;

  /// No description provided for @noFacilityTypesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No facility types available'**
  String get noFacilityTypesAvailable;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again'**
  String get errorOccurred;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'capacity'**
  String get capacity;

  /// No description provided for @person.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get person;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'status'**
  String get status;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @price_list.
  ///
  /// In en, this message translates to:
  /// **'Prices'**
  String get price_list;

  /// No description provided for @priceStartFrom.
  ///
  /// In en, this message translates to:
  /// **'Price start from:'**
  String get priceStartFrom;

  /// No description provided for @riyalY.
  ///
  /// In en, this message translates to:
  /// **'R.Y'**
  String get riyalY;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @priceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Price not availablxe'**
  String get priceNotAvailable;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @address_not_available.
  ///
  /// In en, this message translates to:
  /// **'Address not available'**
  String get address_not_available;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @amenity.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenity;

  /// No description provided for @amenities_and_facilities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities_and_facilities;

  /// No description provided for @about_facility.
  ///
  /// In en, this message translates to:
  /// **'Facility overview'**
  String get about_facility;

  /// No description provided for @read_terms_before_booking.
  ///
  /// In en, this message translates to:
  /// **'Before you book… read these terms'**
  String get read_terms_before_booking;

  /// No description provided for @insurance_coverage_question.
  ///
  /// In en, this message translates to:
  /// **'What does the insurance cover?'**
  String get insurance_coverage_question;

  /// No description provided for @available_spaces.
  ///
  /// In en, this message translates to:
  /// **'Available spaces'**
  String get available_spaces;

  /// No description provided for @special_services_amenities.
  ///
  /// In en, this message translates to:
  /// **'Special services & amenities'**
  String get special_services_amenities;

  /// No description provided for @noAmenities.
  ///
  /// In en, this message translates to:
  /// **'No Amenity Available'**
  String get noAmenities;

  /// No description provided for @bookingNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookingNow;

  /// No description provided for @showAvailableDays.
  ///
  /// In en, this message translates to:
  /// **'Show available days'**
  String get showAvailableDays;

  /// No description provided for @availabilityCalendar.
  ///
  /// In en, this message translates to:
  /// **'List bookings'**
  String get availabilityCalendar;

  /// No description provided for @selectDateAndPrice.
  ///
  /// In en, this message translates to:
  /// **'Select Date And Price'**
  String get selectDateAndPrice;

  /// No description provided for @view_price_list.
  ///
  /// In en, this message translates to:
  /// **'Chooses to a available price list to choose what package suits you best'**
  String get view_price_list;

  /// No description provided for @select_period_and_day.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred period from the displayed price list and choose the day that suits you.'**
  String get select_period_and_day;

  /// No description provided for @question_title.
  ///
  /// In en, this message translates to:
  /// **'Select the day(s) you want to book'**
  String get question_title;

  /// No description provided for @question_description.
  ///
  /// In en, this message translates to:
  /// **'Please select the day you would like to book. If the selected day is not available, please choose another day.'**
  String get question_description;

  /// No description provided for @continueBooking.
  ///
  /// In en, this message translates to:
  /// **'Continue Booking'**
  String get continueBooking;

  /// No description provided for @completeTheReservation.
  ///
  /// In en, this message translates to:
  /// **'Complete the reservation'**
  String get completeTheReservation;

  /// No description provided for @reservationDetails.
  ///
  /// In en, this message translates to:
  /// **'Reservation Details'**
  String get reservationDetails;

  /// No description provided for @dateNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Date Not Available'**
  String get dateNotAvailable;

  /// No description provided for @booking_type.
  ///
  /// In en, this message translates to:
  /// **'Booking Type'**
  String get booking_type;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family(Man and Women)'**
  String get family;

  /// No description provided for @women.
  ///
  /// In en, this message translates to:
  /// **'Women Only'**
  String get women;

  /// No description provided for @men.
  ///
  /// In en, this message translates to:
  /// **'Men Only'**
  String get men;

  /// No description provided for @companies.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get companies;

  /// No description provided for @please_choose_booking_type.
  ///
  /// In en, this message translates to:
  /// **'Please choose the booking type'**
  String get please_choose_booking_type;

  /// No description provided for @adults_count.
  ///
  /// In en, this message translates to:
  /// **'Number of Adults'**
  String get adults_count;

  /// No description provided for @please_enter_adults_count.
  ///
  /// In en, this message translates to:
  /// **'Please enter the number of adults'**
  String get please_enter_adults_count;

  /// No description provided for @children_count.
  ///
  /// In en, this message translates to:
  /// **'Number of Children'**
  String get children_count;

  /// No description provided for @please_enter_children_count.
  ///
  /// In en, this message translates to:
  /// **'Please enter the number of children'**
  String get please_enter_children_count;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get not_available;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @no_facilities.
  ///
  /// In en, this message translates to:
  /// **'No facilities available right now.'**
  String get no_facilities;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get no_data;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications at the moment.'**
  String get noNotifications;

  /// No description provided for @noNotificationsHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know here as soon as anything new arrives.'**
  String get noNotificationsHint;

  /// No description provided for @please_complete_data_correctly.
  ///
  /// In en, this message translates to:
  /// **'Please complete the data correctly'**
  String get please_complete_data_correctly;

  /// No description provided for @error_occurred_during_save.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during saving'**
  String get error_occurred_during_save;

  /// No description provided for @reservation_date.
  ///
  /// In en, this message translates to:
  /// **'Reservation Date'**
  String get reservation_date;

  /// No description provided for @package.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package;

  /// No description provided for @access_time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get access_time;

  /// No description provided for @attendance_type.
  ///
  /// In en, this message translates to:
  /// **'Attendance Type'**
  String get attendance_type;

  /// No description provided for @total_price.
  ///
  /// In en, this message translates to:
  /// **'Total price'**
  String get total_price;

  /// No description provided for @amount_to_be_paid.
  ///
  /// In en, this message translates to:
  /// **'Amount to be paid'**
  String get amount_to_be_paid;

  /// No description provided for @payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get payment_methods;

  /// No description provided for @floosak.
  ///
  /// In en, this message translates to:
  /// **'Floosak'**
  String get floosak;

  /// No description provided for @payment_now.
  ///
  /// In en, this message translates to:
  /// **'Payment Now'**
  String get payment_now;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get payment;

  /// No description provided for @payment_details.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get payment_details;

  /// No description provided for @paid_amount.
  ///
  /// In en, this message translates to:
  /// **'Paid Amount'**
  String get paid_amount;

  /// No description provided for @payment_date.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get payment_date;

  /// No description provided for @confirm_payment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirm_payment;

  /// No description provided for @enter_confirmation_number.
  ///
  /// In en, this message translates to:
  /// **'Enter confirmation number'**
  String get enter_confirmation_number;

  /// No description provided for @payment_confirmed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed successfully!'**
  String get payment_confirmed_successfully;

  /// No description provided for @chalet_name.
  ///
  /// In en, this message translates to:
  /// **'Chalet Name'**
  String get chalet_name;

  /// No description provided for @check_in_date.
  ///
  /// In en, this message translates to:
  /// **'Check-in Date'**
  String get check_in_date;

  /// No description provided for @check_out_date.
  ///
  /// In en, this message translates to:
  /// **'Check-out Date'**
  String get check_out_date;

  /// No description provided for @close_and_go_back.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close_and_go_back;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @other_details.
  ///
  /// In en, this message translates to:
  /// **'Other Details'**
  String get other_details;

  /// No description provided for @remaining_amount.
  ///
  /// In en, this message translates to:
  /// **'Remaining Amount'**
  String get remaining_amount;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @persons.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get persons;

  /// No description provided for @imageGallery.
  ///
  /// In en, this message translates to:
  /// **'Image Gallery'**
  String get imageGallery;

  /// No description provided for @no_images.
  ///
  /// In en, this message translates to:
  /// **'No images available'**
  String get no_images;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @hello_user.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get hello_user;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @mapHint.
  ///
  /// In en, this message translates to:
  /// **'View all facilities on the map and pick your destination easily.'**
  String get mapHint;

  /// No description provided for @created_at.
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get created_at;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorite facilities yet'**
  String get noFavorites;

  /// No description provided for @noReservations.
  ///
  /// In en, this message translates to:
  /// **'No reservations at the moment'**
  String get noReservations;

  /// No description provided for @noReservationsHint.
  ///
  /// In en, this message translates to:
  /// **'Explore venues and make a reservation now.'**
  String get noReservationsHint;

  /// No description provided for @please_login_first.
  ///
  /// In en, this message translates to:
  /// **'Please log in first'**
  String get please_login_first;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @personal_data.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personal_data;

  /// No description provided for @personal_data_desc.
  ///
  /// In en, this message translates to:
  /// **'View or edit your personal information'**
  String get personal_data_desc;

  /// No description provided for @language_desc.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get language_desc;

  /// No description provided for @policies.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get policies;

  /// No description provided for @policies_desc.
  ///
  /// In en, this message translates to:
  /// **'Learn how we handle your personal data and protect your privacy.'**
  String get policies_desc;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support & Contact'**
  String get support;

  /// No description provided for @support_desc.
  ///
  /// In en, this message translates to:
  /// **'Contact us for any inquiry or issue'**
  String get support_desc;

  /// No description provided for @support_message.
  ///
  /// In en, this message translates to:
  /// **'We value your feedback and suggestions, and we welcome any communication through the following channels to enhance your experience.'**
  String get support_message;

  /// No description provided for @logout_desc.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get logout_desc;

  /// No description provided for @remove_from_favorites_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this facility from your favorites?'**
  String get remove_from_favorites_confirm;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @address_optional.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get address_optional;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @otp_code.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get otp_code;

  /// No description provided for @enter_verification_code_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code sent via WhatsApp.'**
  String get enter_verification_code_message;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @edit_personal_data.
  ///
  /// In en, this message translates to:
  /// **'Edit Personal Data'**
  String get edit_personal_data;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with us and log in to My Booking app.'**
  String get login_subtitle;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get are_you_sure;

  /// No description provided for @delete_account_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete the account?'**
  String get delete_account_confirmation;

  /// No description provided for @search_in_facilities.
  ///
  /// In en, this message translates to:
  /// **'Search in facilities...'**
  String get search_in_facilities;

  /// No description provided for @discoverBestPlace.
  ///
  /// In en, this message translates to:
  /// **'Discover the best place for your needs'**
  String get discoverBestPlace;

  /// No description provided for @searchByNameAddress.
  ///
  /// In en, this message translates to:
  /// **'Search by name or address, specify the number of people, select the suitable date, and sort results by price easily.'**
  String get searchByNameAddress;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Facility Name'**
  String get name;

  /// No description provided for @address_like.
  ///
  /// In en, this message translates to:
  /// **'Facility Address'**
  String get address_like;

  /// No description provided for @facility_type_id.
  ///
  /// In en, this message translates to:
  /// **'Facility Category'**
  String get facility_type_id;

  /// No description provided for @price_between.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get price_between;

  /// No description provided for @check_in_between.
  ///
  /// In en, this message translates to:
  /// **'Check-in Date'**
  String get check_in_between;

  /// No description provided for @address_near_user.
  ///
  /// In en, this message translates to:
  /// **'Nearby Location'**
  String get address_near_user;

  /// No description provided for @capacity_at_least.
  ///
  /// In en, this message translates to:
  /// **'Minimum Capacity'**
  String get capacity_at_least;

  /// No description provided for @available_on_day.
  ///
  /// In en, this message translates to:
  /// **'Availability by Day'**
  String get available_on_day;

  /// No description provided for @desc_name.
  ///
  /// In en, this message translates to:
  /// **'Search for facilities by typing part of their name.'**
  String get desc_name;

  /// No description provided for @desc_address_like.
  ///
  /// In en, this message translates to:
  /// **'Find facilities based on keywords in their address.'**
  String get desc_address_like;

  /// No description provided for @desc_price_between.
  ///
  /// In en, this message translates to:
  /// **'Select a minimum and maximum price to display suitable facilities.'**
  String get desc_price_between;

  /// No description provided for @desc_check_in_between.
  ///
  /// In en, this message translates to:
  /// **'View facilities available during a specific check-in package.'**
  String get desc_check_in_between;

  /// No description provided for @desc_address_near_user.
  ///
  /// In en, this message translates to:
  /// **'Find facilities closest to your specified address.'**
  String get desc_address_near_user;

  /// No description provided for @desc_capacity_at_least.
  ///
  /// In en, this message translates to:
  /// **'Find facilities that can accommodate at least a specified number of people.'**
  String get desc_capacity_at_least;

  /// No description provided for @desc_available_on_day.
  ///
  /// In en, this message translates to:
  /// **'View facilities available for booking on a selected day.'**
  String get desc_available_on_day;

  /// No description provided for @desc_facility_type_id.
  ///
  /// In en, this message translates to:
  /// **'Choose the facility category such as hotel, chalet, or event hall to filter results.'**
  String get desc_facility_type_id;

  /// No description provided for @hotel_sorted_by_lowest_price.
  ///
  /// In en, this message translates to:
  /// **'Hotels sorted by lowest price'**
  String get hotel_sorted_by_lowest_price;

  /// No description provided for @hotel_sorted_by_highest_price.
  ///
  /// In en, this message translates to:
  /// **'Hotels sorted by highest price'**
  String get hotel_sorted_by_highest_price;

  /// No description provided for @chalet_sorted_by_lowest_price.
  ///
  /// In en, this message translates to:
  /// **'Chalets sorted by lowest price'**
  String get chalet_sorted_by_lowest_price;

  /// No description provided for @chalet_sorted_by_highest_price.
  ///
  /// In en, this message translates to:
  /// **'Chalets sorted by highest price'**
  String get chalet_sorted_by_highest_price;

  /// No description provided for @all_available_hotels.
  ///
  /// In en, this message translates to:
  /// **'All available hotels'**
  String get all_available_hotels;

  /// No description provided for @all_available_chalets.
  ///
  /// In en, this message translates to:
  /// **'All available chalets'**
  String get all_available_chalets;

  /// No description provided for @hall_sorted_by_lowest_price.
  ///
  /// In en, this message translates to:
  /// **'Wedding halls sorted by lowest price'**
  String get hall_sorted_by_lowest_price;

  /// No description provided for @hall_sorted_by_highest_price.
  ///
  /// In en, this message translates to:
  /// **'Wedding halls sorted by highest price'**
  String get hall_sorted_by_highest_price;

  /// No description provided for @all_available_halls.
  ///
  /// In en, this message translates to:
  /// **'All available wedding halls'**
  String get all_available_halls;

  /// No description provided for @no_facilities_available.
  ///
  /// In en, this message translates to:
  /// **'No facilities available'**
  String get no_facilities_available;

  /// No description provided for @reset_filters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get reset_filters;

  /// No description provided for @no_matching_facilities.
  ///
  /// In en, this message translates to:
  /// **'No facilities match your search'**
  String get no_matching_facilities;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get available;

  /// No description provided for @on_date.
  ///
  /// In en, this message translates to:
  /// **'on date:'**
  String get on_date;

  /// No description provided for @choose_filter_type.
  ///
  /// In en, this message translates to:
  /// **'Choose filter type'**
  String get choose_filter_type;

  /// No description provided for @select_people_count.
  ///
  /// In en, this message translates to:
  /// **'Select the number of people'**
  String get select_people_count;

  /// No description provided for @people_count.
  ///
  /// In en, this message translates to:
  /// **'Number of people'**
  String get people_count;

  /// No description provided for @apply_filter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get apply_filter;

  /// No description provided for @select_availability_day.
  ///
  /// In en, this message translates to:
  /// **'Select Availability Day'**
  String get select_availability_day;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get select_date;

  /// No description provided for @enter_current_address.
  ///
  /// In en, this message translates to:
  /// **'Enter your current address'**
  String get enter_current_address;

  /// No description provided for @select_price_range.
  ///
  /// In en, this message translates to:
  /// **'Select price range'**
  String get select_price_range;

  /// No description provided for @min_price.
  ///
  /// In en, this message translates to:
  /// **'Minimum Price'**
  String get min_price;

  /// No description provided for @max_price.
  ///
  /// In en, this message translates to:
  /// **'Maximum Price'**
  String get max_price;

  /// No description provided for @share_app.
  ///
  /// In en, this message translates to:
  /// **'📲 Share the app with your loved ones...'**
  String get share_app;

  /// No description provided for @pick_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from gallery'**
  String get pick_from_gallery;

  /// No description provided for @pick_from_camera.
  ///
  /// In en, this message translates to:
  /// **'Take from camera'**
  String get pick_from_camera;

  /// No description provided for @share_subject.
  ///
  /// In en, this message translates to:
  /// **'Amazing app! Try it now 👇'**
  String get share_subject;

  /// No description provided for @share_app_message.
  ///
  /// In en, this message translates to:
  /// **'Try our new booking app now!'**
  String get share_app_message;

  /// No description provided for @number_of_days.
  ///
  /// In en, this message translates to:
  /// **'Number of days'**
  String get number_of_days;

  /// No description provided for @day_1.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day_1;

  /// No description provided for @day_2.
  ///
  /// In en, this message translates to:
  /// **'2 days'**
  String get day_2;

  /// No description provided for @day_3_10.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String day_3_10(Object count);

  /// No description provided for @day_11_plus.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String day_11_plus(Object count);

  /// No description provided for @booking_type_hint.
  ///
  /// In en, this message translates to:
  /// **'Please select the appropriate booking type (Family / Women / Men / Company)'**
  String get booking_type_hint;

  /// No description provided for @adults_hint.
  ///
  /// In en, this message translates to:
  /// **'Specify the number of adults attending.'**
  String get adults_hint;

  /// No description provided for @children_hint.
  ///
  /// In en, this message translates to:
  /// **'Specify the number of children (optional – only if applicable)'**
  String get children_hint;

  /// No description provided for @booking_not_confirmed_warning.
  ///
  /// In en, this message translates to:
  /// **'Note: The reservation is not confirmed until payment is completed. The deposit amount is non-refundable.'**
  String get booking_not_confirmed_warning;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Back and return'**
  String get go_back;

  /// No description provided for @viewFacilityDetails.
  ///
  /// In en, this message translates to:
  /// **'View Facility Details'**
  String get viewFacilityDetails;

  /// No description provided for @show_less.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get show_less;

  /// No description provided for @read_more.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get read_more;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get please_wait;

  /// No description provided for @no_rooms_available.
  ///
  /// In en, this message translates to:
  /// **'No details available for this facility'**
  String get no_rooms_available;

  /// No description provided for @show_discount_details.
  ///
  /// In en, this message translates to:
  /// **'View applied discount details'**
  String get show_discount_details;

  /// No description provided for @discounts_and_offers.
  ///
  /// In en, this message translates to:
  /// **'Discounts & Offers'**
  String get discounts_and_offers;

  /// No description provided for @discount_value.
  ///
  /// In en, this message translates to:
  /// **'Discount Value'**
  String get discount_value;

  /// No description provided for @enter_payment_code.
  ///
  /// In en, this message translates to:
  /// **'Enter payment code'**
  String get enter_payment_code;

  /// No description provided for @enter_code_from_wallet.
  ///
  /// In en, this message translates to:
  /// **'Enter the code received from Jaib Wallet'**
  String get enter_code_from_wallet;

  /// No description provided for @enter_code2_from_wallet.
  ///
  /// In en, this message translates to:
  /// **'Enter the code received from Jawali Wallet'**
  String get enter_code2_from_wallet;

  /// No description provided for @searchFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Search by facility name'**
  String get searchFieldLabel;

  /// No description provided for @no_matching_facilities_title.
  ///
  /// In en, this message translates to:
  /// **'No matching facilities'**
  String get no_matching_facilities_title;

  /// No description provided for @no_matching_facilities_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any facilities in the current search results. Try entering a different name or explore the map in another area.'**
  String get no_matching_facilities_subtitle;

  /// No description provided for @onboarding1_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with us by searching for the perfect chalet, hotel, or wedding hall, complete with photos and detailed information.'**
  String get onboarding1_subtitle;

  /// No description provided for @onboarding2_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what you like and set the date that suits you, so your place will be ready to welcome you at the perfect moment.'**
  String get onboarding2_subtitle;

  /// No description provided for @onboarding3_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your booking from anywhere with easy and secure payment options, and get ready for an unforgettable experience.'**
  String get onboarding3_subtitle;

  /// No description provided for @package_features_detailed.
  ///
  /// In en, this message translates to:
  /// **'Detailed package features'**
  String get package_features_detailed;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'amenities'**
  String get amenities;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'size'**
  String get size;

  /// No description provided for @meter2.
  ///
  /// In en, this message translates to:
  /// **' m²'**
  String get meter2;

  /// No description provided for @pleaseSelectPeriodAndPriceFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a Package and choose a day first'**
  String get pleaseSelectPeriodAndPriceFirst;

  /// No description provided for @manual_deposit_instruction.
  ///
  /// In en, this message translates to:
  /// **'Please pay the deposit manually via Jaib and then enter the received code.'**
  String get manual_deposit_instruction;

  /// No description provided for @list_your_facility.
  ///
  /// In en, this message translates to:
  /// **'Showcase your facility on our platform'**
  String get list_your_facility;

  /// No description provided for @promote_your_facility.
  ///
  /// In en, this message translates to:
  /// **'You can showcase any facility, whether it\'s a hotel, chalet, or hall, on our platform'**
  String get promote_your_facility;

  /// No description provided for @confirmExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Exit'**
  String get confirmExitTitle;

  /// No description provided for @confirmExitMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to return to the home page?'**
  String get confirmExitMessage;

  /// No description provided for @filter_and_search_facilities.
  ///
  /// In en, this message translates to:
  /// **'Filter & Search Facilities'**
  String get filter_and_search_facilities;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
