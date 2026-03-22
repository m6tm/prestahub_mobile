/// Generated file. Do not edit.
///
/// Original: lib/l10n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 42 (21 per locale)
///
/// Built on 2026-03-22 at 15:03 UTC

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

// Path: auth.login
class _TranslationsAuthLoginFr {
	_TranslationsAuthLoginFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Connexion';
	String get subtitle => 'Bienvenue sur PrestaHub';
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
	String get submit => 'S\'inscrire';
}

// Path: auth.logout
class _TranslationsAuthLogoutFr {
	_TranslationsAuthLogoutFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get confirmTitle => 'Déconnexion';
	String get confirmMessage => 'Êtes-vous sûr de vouloir vous déconnecter ?';
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

// Path: auth.login
class _TranslationsAuthLoginEn extends _TranslationsAuthLoginFr {
	_TranslationsAuthLoginEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Login';
	@override String get subtitle => 'Welcome to PrestaHub';
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
	@override String get submit => 'Join';
}

// Path: auth.logout
class _TranslationsAuthLogoutEn extends _TranslationsAuthLogoutFr {
	_TranslationsAuthLogoutEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get confirmTitle => 'Log Out';
	@override String get confirmMessage => 'Are you sure you want to log out?';
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

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'auth.login.title': return 'Connexion';
			case 'auth.login.subtitle': return 'Bienvenue sur PrestaHub';
			case 'auth.login.emailLabel': return 'Adresse email';
			case 'auth.login.passwordLabel': return 'Mot de passe';
			case 'auth.login.forgotPassword': return 'Mot de passe oublié ?';
			case 'auth.login.submit': return 'Se connecter';
			case 'auth.signup.title': return 'Inscription';
			case 'auth.signup.subtitle': return 'Rejoignez-nous pour commencer';
			case 'auth.signup.submit': return 'S\'inscrire';
			case 'auth.welcome': return ({required Object name}) => 'Bienvenue ${name} !';
			case 'auth.logout.confirmTitle': return 'Déconnexion';
			case 'auth.logout.confirmMessage': return 'Êtes-vous sûr de vouloir vous déconnecter ?';
			case 'common.buttons.cancel': return 'Annuler';
			case 'common.buttons.confirm': return 'Confirmer';
			case 'common.buttons.save': return 'Enregistrer';
			case 'common.buttons.back': return 'Retour';
			case 'common.errors.generic': return 'Une erreur est survenue. Veuillez réessayer.';
			case 'common.errors.noConnection': return 'Pas de connexion internet.';
			case 'common.labels.loading': return 'Chargement...';
			case 'common.labels.success': return 'Succès';
			case 'common.labels.required': return 'Champ obligatoire';
			default: return null;
		}
	}
}

extension on _TranslationsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'auth.login.title': return 'Login';
			case 'auth.login.subtitle': return 'Welcome to PrestaHub';
			case 'auth.login.emailLabel': return 'Email address';
			case 'auth.login.passwordLabel': return 'Password';
			case 'auth.login.forgotPassword': return 'Forgot password?';
			case 'auth.login.submit': return 'Sign in';
			case 'auth.signup.title': return 'Sign Up';
			case 'auth.signup.subtitle': return 'Join us to get started';
			case 'auth.signup.submit': return 'Join';
			case 'auth.welcome': return ({required Object name}) => 'Welcome ${name} !';
			case 'auth.logout.confirmTitle': return 'Log Out';
			case 'auth.logout.confirmMessage': return 'Are you sure you want to log out?';
			case 'common.buttons.cancel': return 'Cancel';
			case 'common.buttons.confirm': return 'Confirm';
			case 'common.buttons.save': return 'Save';
			case 'common.buttons.back': return 'Back';
			case 'common.errors.generic': return 'Something went wrong. Please try again.';
			case 'common.errors.noConnection': return 'No internet connection.';
			case 'common.labels.loading': return 'Loading...';
			case 'common.labels.success': return 'Success';
			case 'common.labels.required': return 'Required field';
			default: return null;
		}
	}
}
