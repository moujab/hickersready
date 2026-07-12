import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// The application title
  ///
  /// In ar, this message translates to:
  /// **'طريق المتنزهين'**
  String get appTitle;

  /// No description provided for @menuTrailsDone.
  ///
  /// In ar, this message translates to:
  /// **'المسارات التي قمنا بها'**
  String get menuTrailsDone;

  /// No description provided for @menuTownsVisited.
  ///
  /// In ar, this message translates to:
  /// **'البلدات والقرى التي زرناها'**
  String get menuTownsVisited;

  /// No description provided for @menuGuides.
  ///
  /// In ar, this message translates to:
  /// **'مرشدونا'**
  String get menuGuides;

  /// No description provided for @menuContributors.
  ///
  /// In ar, this message translates to:
  /// **'المساهمون'**
  String get menuContributors;

  /// No description provided for @menuUpcomingHikes.
  ///
  /// In ar, this message translates to:
  /// **'الرحلات القادمة'**
  String get menuUpcomingHikes;

  /// No description provided for @menuWhoAreWe.
  ///
  /// In ar, this message translates to:
  /// **'من نحن'**
  String get menuWhoAreWe;

  /// No description provided for @menuSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get menuSettings;

  /// No description provided for @whoAreWeDescription.
  ///
  /// In ar, this message translates to:
  /// **'نحن مجموعة من المتنزهين الذين يجتمعون لاكتشاف الطبيعة والمسارات الجبلية والقرى المحلية معًا. سيتم تحديث هذا النص قريبًا بوصف كامل عن مجموعتنا.'**
  String get whoAreWeDescription;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @noItems.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عناصر لعرضها بعد'**
  String get noItems;

  /// Name of the group behind the app, shown as a credit line
  ///
  /// In ar, this message translates to:
  /// **'WALK AND DISCOVER GROUP'**
  String get groupName;

  /// No description provided for @adminLogin.
  ///
  /// In ar, this message translates to:
  /// **'دخول المشرف'**
  String get adminLogin;

  /// No description provided for @adminLogout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل خروج المشرف'**
  String get adminLogout;

  /// No description provided for @adminModeOn.
  ///
  /// In ar, this message translates to:
  /// **'وضع المشرف مفعّل'**
  String get adminModeOn;

  /// No description provided for @enterPin.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز المشرف'**
  String get enterPin;

  /// No description provided for @pin.
  ///
  /// In ar, this message translates to:
  /// **'الرمز'**
  String get pin;

  /// No description provided for @incorrectPin.
  ///
  /// In ar, this message translates to:
  /// **'رمز غير صحيح'**
  String get incorrectPin;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحذف'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا العنصر؟'**
  String get deleteConfirmMessage;

  /// No description provided for @fieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get fieldRequired;

  /// No description provided for @trailName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المسار'**
  String get trailName;

  /// No description provided for @date.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get date;

  /// No description provided for @description.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get description;

  /// No description provided for @townName.
  ///
  /// In ar, this message translates to:
  /// **'اسم البلدة/القرية'**
  String get townName;

  /// No description provided for @guideName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المرشد'**
  String get guideName;

  /// No description provided for @bio.
  ///
  /// In ar, this message translates to:
  /// **'نبذة تعريفية'**
  String get bio;

  /// No description provided for @businessName.
  ///
  /// In ar, this message translates to:
  /// **'اسم النشاط التجاري'**
  String get businessName;

  /// No description provided for @category.
  ///
  /// In ar, this message translates to:
  /// **'الفئة'**
  String get category;

  /// No description provided for @contactPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم التواصل'**
  String get contactPhone;

  /// No description provided for @productImageUrls.
  ///
  /// In ar, this message translates to:
  /// **'روابط صور المنتجات (افصل بينها بفاصلة)'**
  String get productImageUrls;

  /// No description provided for @settingsFirstName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get settingsFirstName;

  /// No description provided for @settingsFatherName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الأب'**
  String get settingsFatherName;

  /// No description provided for @settingsFamilyName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العائلة'**
  String get settingsFamilyName;

  /// No description provided for @settingsEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get settingsEmail;

  /// No description provided for @settingsPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get settingsPhone;

  /// No description provided for @invalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'بريد إلكتروني غير صحيح'**
  String get invalidEmail;

  /// No description provided for @profileSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ البيانات'**
  String get profileSaved;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @register.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get register;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @noAccountRegister.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟ أنشئ حسابًا'**
  String get noAccountRegister;

  /// No description provided for @haveAccountLogin.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟ سجّل الدخول'**
  String get haveAccountLogin;

  /// No description provided for @invalidCredentials.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني أو كلمة المرور غير صحيحة'**
  String get invalidCredentials;

  /// No description provided for @emailTaken.
  ///
  /// In ar, this message translates to:
  /// **'هذا البريد الإلكتروني مستخدم بالفعل'**
  String get emailTaken;

  /// No description provided for @passwordTooShort.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل'**
  String get passwordTooShort;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
