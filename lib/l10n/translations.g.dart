/// Generated file. Do not edit.
///
/// Original: lib/l10n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 226 (113 per locale)
///
/// Built on 2026-03-25 at 20:45 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.fr;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.fr) // set locale
/// - Locale locale = AppLocale.fr.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.fr) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	fr(languageCode: 'fr', build: Translations.build),
	en(languageCode: 'en', build: _TranslationsEn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final _TranslationsAuthFr auth = _TranslationsAuthFr._(_root);
	late final _TranslationsCommonFr common = _TranslationsCommonFr._(_root);
	late final _TranslationsHomeFr home = _TranslationsHomeFr._(_root);
	late final _TranslationsOnboardingFr onboarding = _TranslationsOnboardingFr._(_root);
}

// Path: auth
class _TranslationsAuthFr {
	_TranslationsAuthFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _TranslationsAuthLoginFr login = _TranslationsAuthLoginFr._(_root);
	late final _TranslationsAuthSignupFr signup = _TranslationsAuthSignupFr._(_root);
	String welcome({required Object name}) => 'Bienvenue ${name} !';
	late final _TranslationsAuthLogoutFr logout = _TranslationsAuthLogoutFr._(_root);
	late final _TranslationsAuthForgotPasswordScreenFr forgotPasswordScreen = _TranslationsAuthForgotPasswordScreenFr._(_root);
	late final _TranslationsAuthOtpVerificationScreenFr otpVerificationScreen = _TranslationsAuthOtpVerificationScreenFr._(_root);
	late final _TranslationsAuthNewPasswordScreenFr newPasswordScreen = _TranslationsAuthNewPasswordScreenFr._(_root);
}

// Path: common
class _TranslationsCommonFr {
	_TranslationsCommonFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _TranslationsCommonButtonsFr buttons = _TranslationsCommonButtonsFr._(_root);
	late final _TranslationsCommonErrorsFr errors = _TranslationsCommonErrorsFr._(_root);
	late final _TranslationsCommonLabelsFr labels = _TranslationsCommonLabelsFr._(_root);
}

// Path: home
class _TranslationsHomeFr {
	_TranslationsHomeFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get welcomeBack => 'Bon retour,';
	String helloUser({required Object name}) => 'Bonjour, ${name}';
	String get searchPlaceholder => 'Rechercher un service...';
	String get popularCategories => 'Catégories populaires';
	String get viewAll => 'Tout voir';
	String get nearbyProviders => 'Prestataires près de vous';
	String get locationIndicator => 'Paris, FR';
	String get view => 'Voir';
	late final _TranslationsHomeCategoriesFr categories = _TranslationsHomeCategoriesFr._(_root);
	late final _TranslationsHomeNavFr nav = _TranslationsHomeNavFr._(_root);
}

// Path: onboarding
class _TranslationsOnboardingFr {
	_TranslationsOnboardingFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get skip => 'Ignorer';
	String get start => 'Commencer';
	String get next => 'Suivant';
	late final _TranslationsOnboardingPagesFr pages = _TranslationsOnboardingPagesFr._(_root);
}

// Path: auth.login
class _TranslationsAuthLoginFr {
	_TranslationsAuthLoginFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Connexion';
	String get welcomeTitle => 'Bon retour parmi nous';
	String get welcomeSubtitle => 'Entrez vos coordonnées pour continuer';
	String get emailPhoneLabel => 'Email ou Numéro de téléphone';
	String get emailPhonePlaceholder => 'Entrez votre email ou téléphone';
	String get continueButton => 'Continuer';
	String get alternativeTitle => 'CONNEXION ALTERNATIVE';
	String get otpButton => 'OTP';
	String get passwordButton => 'Mot de passe';
	String get newUserText => 'Nouveau sur Prestahub ? ';
	String get createAccountLink => 'Créer un compte';
	String get emailLabel => 'Adresse email';
	String get passwordLabel => 'Mot de passe';
	String get forgotPassword => 'Mot de passe oublié ?';
	String get submit => 'Se connecter';
}

// Path: auth.signup
class _TranslationsAuthSignupFr {
	_TranslationsAuthSignupFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Inscription';
	String get subtitle => 'Rejoignez-nous pour commencer';
	String get subtitleEcosystem => 'Rejoignez notre écosystème professionnel dès aujourd\'hui';
	String get roleClient => 'Client';
	String get roleProfessional => 'Professionnel';
	String get fullnameLabel => 'Nom complet';
	String get fullnamePlaceholder => 'Jean Dupont';
	String get emailLabel => 'Adresse email';
	String get emailPlaceholder => 'jean.dupont@exemple.com';
	String get phoneLabel => 'Numéro de téléphone';
	String get phonePlaceholder => '+33 6 12 34 56 78';
	String get passwordLabel => 'Mot de passe';
	String get passwordPlaceholder => '••••••••';
	String get submit => 'Créer un compte';
	String get submitProfessional => 'S\'inscrire comme prestataire';
	String get companyLabel => 'Nom de l\'entreprise / Raison sociale';
	String get companyPlaceholder => 'Ex: Presta Services SAS';
	String get siretLabel => 'Numéro SIRET / ID Fiscal';
	String get siretPlaceholder => '123 456 789 00012';
	String get categoryLabel => 'Catégorie professionnelle';
	String get categoryPlaceholder => 'Choisir une catégorie';
	late final _TranslationsAuthSignupCategoriesFr categories = _TranslationsAuthSignupCategoriesFr._(_root);
	String get termsPrefix => 'En vous inscrivant, vous acceptez nos ';
	String get termsCgu => 'Conditions Générales d\'Utilisation';
	String get termsAnd => ' et notre ';
	String get termsPrivacy => 'Politique de Confidentialité';
	String get socialDivider => 'OU CONTINUER AVEC';
	late final _TranslationsAuthSignupSocialFr social = _TranslationsAuthSignupSocialFr._(_root);
	String get alreadyHaveAccountText => 'Vous avez déjà un compte ? ';
	String get loginLink => 'Se connecter';
}

// Path: auth.logout
class _TranslationsAuthLogoutFr {
	_TranslationsAuthLogoutFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get confirmTitle => 'Déconnexion';
	String get confirmMessage => 'Êtes-vous sûr de vouloir vous déconnecter de votre compte ?';
	String get submitButton => 'Se déconnecter';
}

// Path: auth.forgotPasswordScreen
class _TranslationsAuthForgotPasswordScreenFr {
	_TranslationsAuthForgotPasswordScreenFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Mot de passe oublié';
	String get resetTitle => 'Réinitialisation';
	String get resetSubtitle => 'Entrez votre email ou numéro de téléphone pour recevoir un lien de réinitialisation';
	String get emailPhoneLabel => 'Email ou numéro de téléphone';
	String get emailPhonePlaceholder => 'Ex: nom@email.com';
	String get sendLinkButton => 'Envoyer le lien';
	String get backToLogin => 'Retour à la connexion';
}

// Path: auth.otpVerificationScreen
class _TranslationsAuthOtpVerificationScreenFr {
	_TranslationsAuthOtpVerificationScreenFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Vérification';
	String get instruction => 'Entrez le code à 6 chiffres envoyé au ';
	String get didNotReceive => 'Vous n\'avez pas reçu le code ?';
	String get resend => 'Renvoyer le code';
	String get verifyButton => 'Vérifier';
}

// Path: auth.newPasswordScreen
class _TranslationsAuthNewPasswordScreenFr {
	_TranslationsAuthNewPasswordScreenFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Nouveau mot de passe';
	String get headline => 'Créez un nouveau mot de passe';
	String get subheadline => 'Assurez-vous que votre compte reste sécurisé avec un mot de passe fort.';
	String get newPasswordLabel => 'Nouveau mot de passe';
	String get confirmPasswordLabel => 'Confirmer le mot de passe';
	String get strengthLabel => 'Force du mot de passe';
	String get strengthWeak => 'Faible';
	String get strengthMedium => 'Moyen';
	String get strengthStrong => 'Fort';
	String get requirementChars => 'Au moins 8 caractères';
	String get requirementCaseNum => 'Une majuscule et un chiffre';
	String get requirementSpecial => 'Un caractère spécial (@,';
	String get submitButton => 'Enregistrer';
}

// Path: common.buttons
class _TranslationsCommonButtonsFr {
	_TranslationsCommonButtonsFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cancel => 'Annuler';
	String get confirm => 'Confirmer';
	String get save => 'Enregistrer';
	String get back => 'Retour';
}

// Path: common.errors
class _TranslationsCommonErrorsFr {
	_TranslationsCommonErrorsFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get generic => 'Une erreur est survenue. Veuillez réessayer.';
	String get noConnection => 'Pas de connexion internet.';
}

// Path: common.labels
class _TranslationsCommonLabelsFr {
	_TranslationsCommonLabelsFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'Chargement...';
	String get success => 'Succès';
	String get required => 'Champ obligatoire';
}

// Path: home.categories
class _TranslationsHomeCategoriesFr {
	_TranslationsHomeCategoriesFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get plumbing => 'Plomberie';
	String get electricity => 'Électricité';
	String get cleaning => 'Ménage';
	String get painting => 'Peinture';
}

// Path: home.nav
class _TranslationsHomeNavFr {
	_TranslationsHomeNavFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get home => 'Accueil';
	String get search => 'Recherche';
	String get orders => 'Commandes';
	String get profile => 'Profil';
}

// Path: onboarding.pages
class _TranslationsOnboardingPagesFr {
	_TranslationsOnboardingPagesFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _TranslationsOnboardingPagesFindFr find = _TranslationsOnboardingPagesFindFr._(_root);
	late final _TranslationsOnboardingPagesBookFr book = _TranslationsOnboardingPagesBookFr._(_root);
	late final _TranslationsOnboardingPagesRateFr rate = _TranslationsOnboardingPagesRateFr._(_root);
}

// Path: auth.signup.categories
class _TranslationsAuthSignupCategoriesFr {
	_TranslationsAuthSignupCategoriesFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get construction => 'Bâtiment & Travaux';
	String get cleaning => 'Nettoyage & Entretien';
	String get it => 'Informatique & Tech';
	String get events => 'Événementiel';
	String get health => 'Santé & Bien-être';
}

// Path: auth.signup.social
class _TranslationsAuthSignupSocialFr {
	_TranslationsAuthSignupSocialFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get google => 'Google';
	String get apple => 'Apple';
}

// Path: onboarding.pages.find
class _TranslationsOnboardingPagesFindFr {
	_TranslationsOnboardingPagesFindFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Trouver des experts';
	String get description => 'Connectez-vous avec des prestataires vérifiés pour tous vos besoins, où que vous soyez.';
}

// Path: onboarding.pages.book
class _TranslationsOnboardingPagesBookFr {
	_TranslationsOnboardingPagesBookFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Prendre rendez-vous';
	String get description => 'Planifiez vos interventions en quelques clics selon vos disponibilités.';
}

// Path: onboarding.pages.rate
class _TranslationsOnboardingPagesRateFr {
	_TranslationsOnboardingPagesRateFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Noter & Évaluer';
	String get description => 'Partagez votre expérience et aidez la communauté à grow en toute confiance.';
}

// Path: <root>
class _TranslationsEn extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_TranslationsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _TranslationsEn _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthEn auth = _TranslationsAuthEn._(_root);
	@override late final _TranslationsCommonEn common = _TranslationsCommonEn._(_root);
	@override late final _TranslationsHomeEn home = _TranslationsHomeEn._(_root);
	@override late final _TranslationsOnboardingEn onboarding = _TranslationsOnboardingEn._(_root);
}

// Path: auth
class _TranslationsAuthEn extends _TranslationsAuthFr {
	_TranslationsAuthEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthLoginEn login = _TranslationsAuthLoginEn._(_root);
	@override late final _TranslationsAuthSignupEn signup = _TranslationsAuthSignupEn._(_root);
	@override String welcome({required Object name}) => 'Welcome ${name} !';
	@override late final _TranslationsAuthLogoutEn logout = _TranslationsAuthLogoutEn._(_root);
	@override late final _TranslationsAuthForgotPasswordScreenEn forgotPasswordScreen = _TranslationsAuthForgotPasswordScreenEn._(_root);
	@override late final _TranslationsAuthOtpVerificationScreenEn otpVerificationScreen = _TranslationsAuthOtpVerificationScreenEn._(_root);
	@override late final _TranslationsAuthNewPasswordScreenEn newPasswordScreen = _TranslationsAuthNewPasswordScreenEn._(_root);
}

// Path: common
class _TranslationsCommonEn extends _TranslationsCommonFr {
	_TranslationsCommonEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonButtonsEn buttons = _TranslationsCommonButtonsEn._(_root);
	@override late final _TranslationsCommonErrorsEn errors = _TranslationsCommonErrorsEn._(_root);
	@override late final _TranslationsCommonLabelsEn labels = _TranslationsCommonLabelsEn._(_root);
}

// Path: home
class _TranslationsHomeEn extends _TranslationsHomeFr {
	_TranslationsHomeEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get welcomeBack => 'Welcome back,';
	@override String helloUser({required Object name}) => 'Hello, ${name}';
	@override String get searchPlaceholder => 'Search for a service...';
	@override String get popularCategories => 'Popular categories';
	@override String get viewAll => 'See all';
	@override String get nearbyProviders => 'Providers near you';
	@override String get locationIndicator => 'Paris, FR';
	@override String get view => 'View';
	@override late final _TranslationsHomeCategoriesEn categories = _TranslationsHomeCategoriesEn._(_root);
	@override late final _TranslationsHomeNavEn nav = _TranslationsHomeNavEn._(_root);
}

// Path: onboarding
class _TranslationsOnboardingEn extends _TranslationsOnboardingFr {
	_TranslationsOnboardingEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get skip => 'Skip';
	@override String get start => 'Get Started';
	@override String get next => 'Next';
	@override late final _TranslationsOnboardingPagesEn pages = _TranslationsOnboardingPagesEn._(_root);
}

// Path: auth.login
class _TranslationsAuthLoginEn extends _TranslationsAuthLoginFr {
	_TranslationsAuthLoginEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Login';
	@override String get welcomeTitle => 'Welcome back';
	@override String get welcomeSubtitle => 'Enter your details to continue';
	@override String get emailPhoneLabel => 'Email or Phone Number';
	@override String get emailPhonePlaceholder => 'Enter your email or phone';
	@override String get continueButton => 'Continue';
	@override String get alternativeTitle => 'ALTERNATIVE LOGIN';
	@override String get otpButton => 'OTP';
	@override String get passwordButton => 'Password';
	@override String get newUserText => 'New to Prestahub? ';
	@override String get createAccountLink => 'Create an account';
	@override String get emailLabel => 'Email address';
	@override String get passwordLabel => 'Password';
	@override String get forgotPassword => 'Forgot password?';
	@override String get submit => 'Sign in';
}

// Path: auth.signup
class _TranslationsAuthSignupEn extends _TranslationsAuthSignupFr {
	_TranslationsAuthSignupEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sign Up';
	@override String get subtitle => 'Join us to get started';
	@override String get subtitleEcosystem => 'Join our professional ecosystem today';
	@override String get roleClient => 'Client';
	@override String get roleProfessional => 'Professional';
	@override String get fullnameLabel => 'Full Name';
	@override String get fullnamePlaceholder => 'John Doe';
	@override String get emailLabel => 'Email Address';
	@override String get emailPlaceholder => 'john@example.com';
	@override String get phoneLabel => 'Phone Number';
	@override String get phonePlaceholder => '+1 (555) 000-0000';
	@override String get passwordLabel => 'Password';
	@override String get passwordPlaceholder => '••••••••';
	@override String get submit => 'Create Account';
	@override String get submitProfessional => 'Register as Provider';
	@override String get companyLabel => 'Company Name / Business Name';
	@override String get companyPlaceholder => 'Ex: Presta Services SAS';
	@override String get siretLabel => 'SIRET Number / Tax ID';
	@override String get siretPlaceholder => '123 456 789 00012';
	@override String get categoryLabel => 'Professional Category';
	@override String get categoryPlaceholder => 'Choose a category';
	@override late final _TranslationsAuthSignupCategoriesEn categories = _TranslationsAuthSignupCategoriesEn._(_root);
	@override String get termsPrefix => 'By signing up, you agree to our ';
	@override String get termsCgu => 'Terms of Service';
	@override String get termsAnd => ' and our ';
	@override String get termsPrivacy => 'Privacy Policy';
	@override String get socialDivider => 'OR CONTINUE WITH';
	@override late final _TranslationsAuthSignupSocialEn social = _TranslationsAuthSignupSocialEn._(_root);
	@override String get alreadyHaveAccountText => 'Already have an account? ';
	@override String get loginLink => 'Log in';
}

// Path: auth.logout
class _TranslationsAuthLogoutEn extends _TranslationsAuthLogoutFr {
	_TranslationsAuthLogoutEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get confirmTitle => 'Logout';
	@override String get confirmMessage => 'Are you sure you want to log out of your account?';
	@override String get submitButton => 'Log Out';
}

// Path: auth.forgotPasswordScreen
class _TranslationsAuthForgotPasswordScreenEn extends _TranslationsAuthForgotPasswordScreenFr {
	_TranslationsAuthForgotPasswordScreenEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Forgot Password';
	@override String get resetTitle => 'Reset Password';
	@override String get resetSubtitle => 'Enter your email or phone number to receive a reset link';
	@override String get emailPhoneLabel => 'Email or phone number';
	@override String get emailPhonePlaceholder => 'Ex: name@email.com';
	@override String get sendLinkButton => 'Send Link';
	@override String get backToLogin => 'Back to login';
}

// Path: auth.otpVerificationScreen
class _TranslationsAuthOtpVerificationScreenEn extends _TranslationsAuthOtpVerificationScreenFr {
	_TranslationsAuthOtpVerificationScreenEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Verification';
	@override String get instruction => 'Enter the 6-digit code sent to ';
	@override String get didNotReceive => 'Didn\'t receive the code?';
	@override String get resend => 'Resend code';
	@override String get verifyButton => 'Verify';
}

// Path: auth.newPasswordScreen
class _TranslationsAuthNewPasswordScreenEn extends _TranslationsAuthNewPasswordScreenFr {
	_TranslationsAuthNewPasswordScreenEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'New Password';
	@override String get headline => 'Create a new password';
	@override String get subheadline => 'Make sure your account stays secure with a strong password.';
	@override String get newPasswordLabel => 'New password';
	@override String get confirmPasswordLabel => 'Confirm password';
	@override String get strengthLabel => 'Password strength';
	@override String get strengthWeak => 'Weak';
	@override String get strengthMedium => 'Medium';
	@override String get strengthStrong => 'Strong';
	@override String get requirementChars => 'At least 8 characters';
	@override String get requirementCaseNum => 'One uppercase and one number';
	@override String get requirementSpecial => 'One special character (@,';
	@override String get submitButton => 'Save';
}

// Path: common.buttons
class _TranslationsCommonButtonsEn extends _TranslationsCommonButtonsFr {
	_TranslationsCommonButtonsEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancel';
	@override String get confirm => 'Confirm';
	@override String get save => 'Save';
	@override String get back => 'Back';
}

// Path: common.errors
class _TranslationsCommonErrorsEn extends _TranslationsCommonErrorsFr {
	_TranslationsCommonErrorsEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get generic => 'Something went wrong. Please try again.';
	@override String get noConnection => 'No internet connection.';
}

// Path: common.labels
class _TranslationsCommonLabelsEn extends _TranslationsCommonLabelsFr {
	_TranslationsCommonLabelsEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get loading => 'Loading...';
	@override String get success => 'Success';
	@override String get required => 'Required field';
}

// Path: home.categories
class _TranslationsHomeCategoriesEn extends _TranslationsHomeCategoriesFr {
	_TranslationsHomeCategoriesEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get plumbing => 'Plumbing';
	@override String get electricity => 'Electricity';
	@override String get cleaning => 'Cleaning';
	@override String get painting => 'Painting';
}

// Path: home.nav
class _TranslationsHomeNavEn extends _TranslationsHomeNavFr {
	_TranslationsHomeNavEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get home => 'Home';
	@override String get search => 'Search';
	@override String get orders => 'Orders';
	@override String get profile => 'Profile';
}

// Path: onboarding.pages
class _TranslationsOnboardingPagesEn extends _TranslationsOnboardingPagesFr {
	_TranslationsOnboardingPagesEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsOnboardingPagesFindEn find = _TranslationsOnboardingPagesFindEn._(_root);
	@override late final _TranslationsOnboardingPagesBookEn book = _TranslationsOnboardingPagesBookEn._(_root);
	@override late final _TranslationsOnboardingPagesRateEn rate = _TranslationsOnboardingPagesRateEn._(_root);
}

// Path: auth.signup.categories
class _TranslationsAuthSignupCategoriesEn extends _TranslationsAuthSignupCategoriesFr {
	_TranslationsAuthSignupCategoriesEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get construction => 'Building & Construction';
	@override String get cleaning => 'Cleaning & Maintenance';
	@override String get it => 'IT & Technology';
	@override String get events => 'Events';
	@override String get health => 'Health & Wellness';
}

// Path: auth.signup.social
class _TranslationsAuthSignupSocialEn extends _TranslationsAuthSignupSocialFr {
	_TranslationsAuthSignupSocialEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get google => 'Google';
	@override String get apple => 'Apple';
}

// Path: onboarding.pages.find
class _TranslationsOnboardingPagesFindEn extends _TranslationsOnboardingPagesFindFr {
	_TranslationsOnboardingPagesFindEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Find Professionals';
	@override String get description => 'Connect with verified experts in your area for any task you need.';
}

// Path: onboarding.pages.book
class _TranslationsOnboardingPagesBookEn extends _TranslationsOnboardingPagesBookFr {
	_TranslationsOnboardingPagesBookEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Book Appointments';
	@override String get description => 'Schedule services seamlessly at your convenience.';
}

// Path: onboarding.pages.rate
class _TranslationsOnboardingPagesRateEn extends _TranslationsOnboardingPagesRateFr {
	_TranslationsOnboardingPagesRateEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Rate & Review';
	@override String get description => 'Share your experience and help the community grow.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'auth.login.title': return 'Connexion';
			case 'auth.login.welcomeTitle': return 'Bon retour parmi nous';
			case 'auth.login.welcomeSubtitle': return 'Entrez vos coordonnées pour continuer';
			case 'auth.login.emailPhoneLabel': return 'Email ou Numéro de téléphone';
			case 'auth.login.emailPhonePlaceholder': return 'Entrez votre email ou téléphone';
			case 'auth.login.continueButton': return 'Continuer';
			case 'auth.login.alternativeTitle': return 'CONNEXION ALTERNATIVE';
			case 'auth.login.otpButton': return 'OTP';
			case 'auth.login.passwordButton': return 'Mot de passe';
			case 'auth.login.newUserText': return 'Nouveau sur Prestahub ? ';
			case 'auth.login.createAccountLink': return 'Créer un compte';
			case 'auth.login.emailLabel': return 'Adresse email';
			case 'auth.login.passwordLabel': return 'Mot de passe';
			case 'auth.login.forgotPassword': return 'Mot de passe oublié ?';
			case 'auth.login.submit': return 'Se connecter';
			case 'auth.signup.title': return 'Inscription';
			case 'auth.signup.subtitle': return 'Rejoignez-nous pour commencer';
			case 'auth.signup.subtitleEcosystem': return 'Rejoignez notre écosystème professionnel dès aujourd\'hui';
			case 'auth.signup.roleClient': return 'Client';
			case 'auth.signup.roleProfessional': return 'Professionnel';
			case 'auth.signup.fullnameLabel': return 'Nom complet';
			case 'auth.signup.fullnamePlaceholder': return 'Jean Dupont';
			case 'auth.signup.emailLabel': return 'Adresse email';
			case 'auth.signup.emailPlaceholder': return 'jean.dupont@exemple.com';
			case 'auth.signup.phoneLabel': return 'Numéro de téléphone';
			case 'auth.signup.phonePlaceholder': return '+33 6 12 34 56 78';
			case 'auth.signup.passwordLabel': return 'Mot de passe';
			case 'auth.signup.passwordPlaceholder': return '••••••••';
			case 'auth.signup.submit': return 'Créer un compte';
			case 'auth.signup.submitProfessional': return 'S\'inscrire comme prestataire';
			case 'auth.signup.companyLabel': return 'Nom de l\'entreprise / Raison sociale';
			case 'auth.signup.companyPlaceholder': return 'Ex: Presta Services SAS';
			case 'auth.signup.siretLabel': return 'Numéro SIRET / ID Fiscal';
			case 'auth.signup.siretPlaceholder': return '123 456 789 00012';
			case 'auth.signup.categoryLabel': return 'Catégorie professionnelle';
			case 'auth.signup.categoryPlaceholder': return 'Choisir une catégorie';
			case 'auth.signup.categories.construction': return 'Bâtiment & Travaux';
			case 'auth.signup.categories.cleaning': return 'Nettoyage & Entretien';
			case 'auth.signup.categories.it': return 'Informatique & Tech';
			case 'auth.signup.categories.events': return 'Événementiel';
			case 'auth.signup.categories.health': return 'Santé & Bien-être';
			case 'auth.signup.termsPrefix': return 'En vous inscrivant, vous acceptez nos ';
			case 'auth.signup.termsCgu': return 'Conditions Générales d\'Utilisation';
			case 'auth.signup.termsAnd': return ' et notre ';
			case 'auth.signup.termsPrivacy': return 'Politique de Confidentialité';
			case 'auth.signup.socialDivider': return 'OU CONTINUER AVEC';
			case 'auth.signup.social.google': return 'Google';
			case 'auth.signup.social.apple': return 'Apple';
			case 'auth.signup.alreadyHaveAccountText': return 'Vous avez déjà un compte ? ';
			case 'auth.signup.loginLink': return 'Se connecter';
			case 'auth.welcome': return ({required Object name}) => 'Bienvenue ${name} !';
			case 'auth.logout.confirmTitle': return 'Déconnexion';
			case 'auth.logout.confirmMessage': return 'Êtes-vous sûr de vouloir vous déconnecter de votre compte ?';
			case 'auth.logout.submitButton': return 'Se déconnecter';
			case 'auth.forgotPasswordScreen.title': return 'Mot de passe oublié';
			case 'auth.forgotPasswordScreen.resetTitle': return 'Réinitialisation';
			case 'auth.forgotPasswordScreen.resetSubtitle': return 'Entrez votre email ou numéro de téléphone pour recevoir un lien de réinitialisation';
			case 'auth.forgotPasswordScreen.emailPhoneLabel': return 'Email ou numéro de téléphone';
			case 'auth.forgotPasswordScreen.emailPhonePlaceholder': return 'Ex: nom@email.com';
			case 'auth.forgotPasswordScreen.sendLinkButton': return 'Envoyer le lien';
			case 'auth.forgotPasswordScreen.backToLogin': return 'Retour à la connexion';
			case 'auth.otpVerificationScreen.title': return 'Vérification';
			case 'auth.otpVerificationScreen.instruction': return 'Entrez le code à 6 chiffres envoyé au ';
			case 'auth.otpVerificationScreen.didNotReceive': return 'Vous n\'avez pas reçu le code ?';
			case 'auth.otpVerificationScreen.resend': return 'Renvoyer le code';
			case 'auth.otpVerificationScreen.verifyButton': return 'Vérifier';
			case 'auth.newPasswordScreen.title': return 'Nouveau mot de passe';
			case 'auth.newPasswordScreen.headline': return 'Créez un nouveau mot de passe';
			case 'auth.newPasswordScreen.subheadline': return 'Assurez-vous que votre compte reste sécurisé avec un mot de passe fort.';
			case 'auth.newPasswordScreen.newPasswordLabel': return 'Nouveau mot de passe';
			case 'auth.newPasswordScreen.confirmPasswordLabel': return 'Confirmer le mot de passe';
			case 'auth.newPasswordScreen.strengthLabel': return 'Force du mot de passe';
			case 'auth.newPasswordScreen.strengthWeak': return 'Faible';
			case 'auth.newPasswordScreen.strengthMedium': return 'Moyen';
			case 'auth.newPasswordScreen.strengthStrong': return 'Fort';
			case 'auth.newPasswordScreen.requirementChars': return 'Au moins 8 caractères';
			case 'auth.newPasswordScreen.requirementCaseNum': return 'Une majuscule et un chiffre';
			case 'auth.newPasswordScreen.requirementSpecial': return 'Un caractère spécial (@,';
			case 'auth.newPasswordScreen.submitButton': return 'Enregistrer';
			case 'common.buttons.cancel': return 'Annuler';
			case 'common.buttons.confirm': return 'Confirmer';
			case 'common.buttons.save': return 'Enregistrer';
			case 'common.buttons.back': return 'Retour';
			case 'common.errors.generic': return 'Une erreur est survenue. Veuillez réessayer.';
			case 'common.errors.noConnection': return 'Pas de connexion internet.';
			case 'common.labels.loading': return 'Chargement...';
			case 'common.labels.success': return 'Succès';
			case 'common.labels.required': return 'Champ obligatoire';
			case 'home.welcomeBack': return 'Bon retour,';
			case 'home.helloUser': return ({required Object name}) => 'Bonjour, ${name}';
			case 'home.searchPlaceholder': return 'Rechercher un service...';
			case 'home.popularCategories': return 'Catégories populaires';
			case 'home.viewAll': return 'Tout voir';
			case 'home.nearbyProviders': return 'Prestataires près de vous';
			case 'home.locationIndicator': return 'Paris, FR';
			case 'home.view': return 'Voir';
			case 'home.categories.plumbing': return 'Plomberie';
			case 'home.categories.electricity': return 'Électricité';
			case 'home.categories.cleaning': return 'Ménage';
			case 'home.categories.painting': return 'Peinture';
			case 'home.nav.home': return 'Accueil';
			case 'home.nav.search': return 'Recherche';
			case 'home.nav.orders': return 'Commandes';
			case 'home.nav.profile': return 'Profil';
			case 'onboarding.skip': return 'Ignorer';
			case 'onboarding.start': return 'Commencer';
			case 'onboarding.next': return 'Suivant';
			case 'onboarding.pages.find.title': return 'Trouver des experts';
			case 'onboarding.pages.find.description': return 'Connectez-vous avec des prestataires vérifiés pour tous vos besoins, où que vous soyez.';
			case 'onboarding.pages.book.title': return 'Prendre rendez-vous';
			case 'onboarding.pages.book.description': return 'Planifiez vos interventions en quelques clics selon vos disponibilités.';
			case 'onboarding.pages.rate.title': return 'Noter & Évaluer';
			case 'onboarding.pages.rate.description': return 'Partagez votre expérience et aidez la communauté à grow en toute confiance.';
			default: return null;
		}
	}
}

extension on _TranslationsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'auth.login.title': return 'Login';
			case 'auth.login.welcomeTitle': return 'Welcome back';
			case 'auth.login.welcomeSubtitle': return 'Enter your details to continue';
			case 'auth.login.emailPhoneLabel': return 'Email or Phone Number';
			case 'auth.login.emailPhonePlaceholder': return 'Enter your email or phone';
			case 'auth.login.continueButton': return 'Continue';
			case 'auth.login.alternativeTitle': return 'ALTERNATIVE LOGIN';
			case 'auth.login.otpButton': return 'OTP';
			case 'auth.login.passwordButton': return 'Password';
			case 'auth.login.newUserText': return 'New to Prestahub? ';
			case 'auth.login.createAccountLink': return 'Create an account';
			case 'auth.login.emailLabel': return 'Email address';
			case 'auth.login.passwordLabel': return 'Password';
			case 'auth.login.forgotPassword': return 'Forgot password?';
			case 'auth.login.submit': return 'Sign in';
			case 'auth.signup.title': return 'Sign Up';
			case 'auth.signup.subtitle': return 'Join us to get started';
			case 'auth.signup.subtitleEcosystem': return 'Join our professional ecosystem today';
			case 'auth.signup.roleClient': return 'Client';
			case 'auth.signup.roleProfessional': return 'Professional';
			case 'auth.signup.fullnameLabel': return 'Full Name';
			case 'auth.signup.fullnamePlaceholder': return 'John Doe';
			case 'auth.signup.emailLabel': return 'Email Address';
			case 'auth.signup.emailPlaceholder': return 'john@example.com';
			case 'auth.signup.phoneLabel': return 'Phone Number';
			case 'auth.signup.phonePlaceholder': return '+1 (555) 000-0000';
			case 'auth.signup.passwordLabel': return 'Password';
			case 'auth.signup.passwordPlaceholder': return '••••••••';
			case 'auth.signup.submit': return 'Create Account';
			case 'auth.signup.submitProfessional': return 'Register as Provider';
			case 'auth.signup.companyLabel': return 'Company Name / Business Name';
			case 'auth.signup.companyPlaceholder': return 'Ex: Presta Services SAS';
			case 'auth.signup.siretLabel': return 'SIRET Number / Tax ID';
			case 'auth.signup.siretPlaceholder': return '123 456 789 00012';
			case 'auth.signup.categoryLabel': return 'Professional Category';
			case 'auth.signup.categoryPlaceholder': return 'Choose a category';
			case 'auth.signup.categories.construction': return 'Building & Construction';
			case 'auth.signup.categories.cleaning': return 'Cleaning & Maintenance';
			case 'auth.signup.categories.it': return 'IT & Technology';
			case 'auth.signup.categories.events': return 'Events';
			case 'auth.signup.categories.health': return 'Health & Wellness';
			case 'auth.signup.termsPrefix': return 'By signing up, you agree to our ';
			case 'auth.signup.termsCgu': return 'Terms of Service';
			case 'auth.signup.termsAnd': return ' and our ';
			case 'auth.signup.termsPrivacy': return 'Privacy Policy';
			case 'auth.signup.socialDivider': return 'OR CONTINUE WITH';
			case 'auth.signup.social.google': return 'Google';
			case 'auth.signup.social.apple': return 'Apple';
			case 'auth.signup.alreadyHaveAccountText': return 'Already have an account? ';
			case 'auth.signup.loginLink': return 'Log in';
			case 'auth.welcome': return ({required Object name}) => 'Welcome ${name} !';
			case 'auth.logout.confirmTitle': return 'Logout';
			case 'auth.logout.confirmMessage': return 'Are you sure you want to log out of your account?';
			case 'auth.logout.submitButton': return 'Log Out';
			case 'auth.forgotPasswordScreen.title': return 'Forgot Password';
			case 'auth.forgotPasswordScreen.resetTitle': return 'Reset Password';
			case 'auth.forgotPasswordScreen.resetSubtitle': return 'Enter your email or phone number to receive a reset link';
			case 'auth.forgotPasswordScreen.emailPhoneLabel': return 'Email or phone number';
			case 'auth.forgotPasswordScreen.emailPhonePlaceholder': return 'Ex: name@email.com';
			case 'auth.forgotPasswordScreen.sendLinkButton': return 'Send Link';
			case 'auth.forgotPasswordScreen.backToLogin': return 'Back to login';
			case 'auth.otpVerificationScreen.title': return 'Verification';
			case 'auth.otpVerificationScreen.instruction': return 'Enter the 6-digit code sent to ';
			case 'auth.otpVerificationScreen.didNotReceive': return 'Didn\'t receive the code?';
			case 'auth.otpVerificationScreen.resend': return 'Resend code';
			case 'auth.otpVerificationScreen.verifyButton': return 'Verify';
			case 'auth.newPasswordScreen.title': return 'New Password';
			case 'auth.newPasswordScreen.headline': return 'Create a new password';
			case 'auth.newPasswordScreen.subheadline': return 'Make sure your account stays secure with a strong password.';
			case 'auth.newPasswordScreen.newPasswordLabel': return 'New password';
			case 'auth.newPasswordScreen.confirmPasswordLabel': return 'Confirm password';
			case 'auth.newPasswordScreen.strengthLabel': return 'Password strength';
			case 'auth.newPasswordScreen.strengthWeak': return 'Weak';
			case 'auth.newPasswordScreen.strengthMedium': return 'Medium';
			case 'auth.newPasswordScreen.strengthStrong': return 'Strong';
			case 'auth.newPasswordScreen.requirementChars': return 'At least 8 characters';
			case 'auth.newPasswordScreen.requirementCaseNum': return 'One uppercase and one number';
			case 'auth.newPasswordScreen.requirementSpecial': return 'One special character (@,';
			case 'auth.newPasswordScreen.submitButton': return 'Save';
			case 'common.buttons.cancel': return 'Cancel';
			case 'common.buttons.confirm': return 'Confirm';
			case 'common.buttons.save': return 'Save';
			case 'common.buttons.back': return 'Back';
			case 'common.errors.generic': return 'Something went wrong. Please try again.';
			case 'common.errors.noConnection': return 'No internet connection.';
			case 'common.labels.loading': return 'Loading...';
			case 'common.labels.success': return 'Success';
			case 'common.labels.required': return 'Required field';
			case 'home.welcomeBack': return 'Welcome back,';
			case 'home.helloUser': return ({required Object name}) => 'Hello, ${name}';
			case 'home.searchPlaceholder': return 'Search for a service...';
			case 'home.popularCategories': return 'Popular categories';
			case 'home.viewAll': return 'See all';
			case 'home.nearbyProviders': return 'Providers near you';
			case 'home.locationIndicator': return 'Paris, FR';
			case 'home.view': return 'View';
			case 'home.categories.plumbing': return 'Plumbing';
			case 'home.categories.electricity': return 'Electricity';
			case 'home.categories.cleaning': return 'Cleaning';
			case 'home.categories.painting': return 'Painting';
			case 'home.nav.home': return 'Home';
			case 'home.nav.search': return 'Search';
			case 'home.nav.orders': return 'Orders';
			case 'home.nav.profile': return 'Profile';
			case 'onboarding.skip': return 'Skip';
			case 'onboarding.start': return 'Get Started';
			case 'onboarding.next': return 'Next';
			case 'onboarding.pages.find.title': return 'Find Professionals';
			case 'onboarding.pages.find.description': return 'Connect with verified experts in your area for any task you need.';
			case 'onboarding.pages.book.title': return 'Book Appointments';
			case 'onboarding.pages.book.description': return 'Schedule services seamlessly at your convenience.';
			case 'onboarding.pages.rate.title': return 'Rate & Review';
			case 'onboarding.pages.rate.description': return 'Share your experience and help the community grow.';
			default: return null;
		}
	}
}
