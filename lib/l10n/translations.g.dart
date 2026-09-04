/// Generated file. Do not edit.
///
/// Original: lib/l10n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 448 (224 per locale)
///
/// Built on 2026-08-21 at 08:00 UTC

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
	late final _TranslationsDiscoveryFr discovery = _TranslationsDiscoveryFr._(_root);
	late final _TranslationsErrorsFr errors = _TranslationsErrorsFr._(_root);
	late final _TranslationsHomeFr home = _TranslationsHomeFr._(_root);
	late final _TranslationsMessagesFr messages = _TranslationsMessagesFr._(_root);
	late final _TranslationsOnboardingFr onboarding = _TranslationsOnboardingFr._(_root);
	late final _TranslationsRequestsFr requests = _TranslationsRequestsFr._(_root);
	late final _TranslationsSettingsFr settings = _TranslationsSettingsFr._(_root);
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

// Path: discovery
class _TranslationsDiscoveryFr {
	_TranslationsDiscoveryFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _TranslationsDiscoverySearchFr search = _TranslationsDiscoverySearchFr._(_root);
	late final _TranslationsDiscoveryCategoriesFr categories = _TranslationsDiscoveryCategoriesFr._(_root);
	late final _TranslationsDiscoveryProvidersFr providers = _TranslationsDiscoveryProvidersFr._(_root);
}

// Path: errors
class _TranslationsErrorsFr {
	_TranslationsErrorsFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get generic => 'Une erreur est survenue. Veuillez réessayer.';
	String get noConnection => 'Pas de connexion internet.';
	String get notFound => 'Ressource introuvable.';
	String get unauthorized => 'Session expirée. Veuillez vous reconnecter.';
	late final _TranslationsErrorsValidationFr validation = _TranslationsErrorsValidationFr._(_root);
	late final _TranslationsErrorsFileFr file = _TranslationsErrorsFileFr._(_root);
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

// Path: messages
class _TranslationsMessagesFr {
	_TranslationsMessagesFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Messages';
	String get empty => 'Aucune conversation';
	String get placeholder => 'Écrivez un message...';
	String get send => 'Envoyer';
	String get call => 'Appeler';
	late final _TranslationsMessagesStatusFr status = _TranslationsMessagesStatusFr._(_root);
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

// Path: requests
class _TranslationsRequestsFr {
	_TranslationsRequestsFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Demandes';
	late final _TranslationsRequestsStatusFr status = _TranslationsRequestsStatusFr._(_root);
	late final _TranslationsRequestsActionsFr actions = _TranslationsRequestsActionsFr._(_root);
	late final _TranslationsRequestsMessagesFr messages = _TranslationsRequestsMessagesFr._(_root);
	late final _TranslationsRequestsMissionFr mission = _TranslationsRequestsMissionFr._(_root);
}

// Path: settings
class _TranslationsSettingsFr {
	_TranslationsSettingsFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Paramètres';
	late final _TranslationsSettingsSectionsFr sections = _TranslationsSettingsSectionsFr._(_root);
	late final _TranslationsSettingsActionsFr actions = _TranslationsSettingsActionsFr._(_root);
	late final _TranslationsSettingsThemesFr themes = _TranslationsSettingsThemesFr._(_root);
	late final _TranslationsSettingsLanguagesFr languages = _TranslationsSettingsLanguagesFr._(_root);
	late final _TranslationsSettingsMessagesFr messages = _TranslationsSettingsMessagesFr._(_root);
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

// Path: discovery.search
class _TranslationsDiscoverySearchFr {
	_TranslationsDiscoverySearchFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get placeholder => 'Rechercher un service...';
	String get filters => 'Filtres';
	String get distance => 'Distance';
	String get pricePerHour => 'Prix/heure';
	String get min => 'Min';
	String get max => 'Max';
	String get apply => 'Appliquer';
	String get reset => 'Réinitialiser';
}

// Path: discovery.categories
class _TranslationsDiscoveryCategoriesFr {
	_TranslationsDiscoveryCategoriesFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Catégories populaires';
	String get viewAll => 'Tout voir';
	String get plumbing => 'Plomberie';
	String get electricity => 'Électricité';
	String get cleaning => 'Ménage';
	String get painting => 'Peinture';
	String get it => 'Informatique';
	String get events => 'Événementiel';
	String get health => 'Santé & Bien-être';
	String get construction => 'Bâtiment & Travaux';
}

// Path: discovery.providers
class _TranslationsDiscoveryProvidersFr {
	_TranslationsDiscoveryProvidersFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get nearby => 'Prestataires près de vous';
	String rating({required Object count}) => '${count} avis';
	String get viewProfile => 'Voir le profil';
	String get requestQuote => 'Demander un devis';
	String get freeQuote => 'Devis gratuit';
	String get about => 'À propos';
	String get services => 'Prestations';
	String get reviews => 'Derniers avis';
	String get reportReview => 'Signaler cet avis';
}

// Path: errors.validation
class _TranslationsErrorsValidationFr {
	_TranslationsErrorsValidationFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get required => 'Champ obligatoire';
	String get invalidEmail => 'Adresse email invalide';
	String get invalidPhone => 'Numéro de téléphone invalide';
	String get passwordTooWeak => 'Mot de passe trop faible';
	String get passwordsMismatch => 'Les mots de passe ne correspondent pas';
	String minLength({required Object min}) => 'Doit contenir au moins ${min} caractères';
}

// Path: errors.file
class _TranslationsErrorsFileFr {
	_TranslationsErrorsFileFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get uploadFailed => 'Impossible de charger le fichier.';
	String get imagePickerFailed => 'Impossible de sélectionner l\'image.';
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

// Path: messages.status
class _TranslationsMessagesStatusFr {
	_TranslationsMessagesStatusFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get delivered => 'Livré';
	String get read => 'Lu';
	String get typing => 'En train d\'écrire...';
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

// Path: requests.status
class _TranslationsRequestsStatusFr {
	_TranslationsRequestsStatusFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get pending => 'En attente';
	String get accepted => 'Acceptée';
	String get refused => 'Refusée';
	String get inProgress => 'En cours';
	String get completed => 'Terminée';
	String get cancelled => 'Annulée';
}

// Path: requests.actions
class _TranslationsRequestsActionsFr {
	_TranslationsRequestsActionsFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get accept => 'Accepter';
	String get refuse => 'Refuser';
	String get cancel => 'Annuler';
	String get complete => 'Terminer';
	String get confirm => 'Confirmer';
	String get viewDetails => 'Voir les détails';
}

// Path: requests.messages
class _TranslationsRequestsMessagesFr {
	_TranslationsRequestsMessagesFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get requestAccepted => 'Demande acceptée. Le client sera notifié.';
	String get requestRefused => 'Demande refusée. Le client sera informé.';
	String get statusUpdated => 'Statut mis à jour.';
	String get chatAfterAccept => 'La messagerie s\'ouvrira après acceptation.';
	String get selectRating => 'Sélectionnez une note avant d\'envoyer.';
	String get reviewThanks => 'Merci pour votre avis !';
	String get reportReason => 'Précisez le motif (minimum 10 caractères).';
}

// Path: requests.mission
class _TranslationsRequestsMissionFr {
	_TranslationsRequestsMissionFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Mission';
	String get chatComingSoon => 'Messagerie à venir.';
}

// Path: settings.sections
class _TranslationsSettingsSectionsFr {
	_TranslationsSettingsSectionsFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get account => 'Compte';
	String get preferences => 'Préférences';
	String get security => 'Sécurité';
	String get support => 'Support';
	String get legal => 'Légal';
}

// Path: settings.actions
class _TranslationsSettingsActionsFr {
	_TranslationsSettingsActionsFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get editProfile => 'Modifier le profil';
	String get addresses => 'Mes adresses';
	String get paymentMethods => 'Moyens de paiement';
	String get notifications => 'Notifications';
	String get theme => 'Thème';
	String get language => 'Langue';
	String get privacy => 'Confidentialité';
	String get changePassword => 'Changer le mot de passe';
	String get twoFactor => 'Authentification à deux facteurs';
	String get connectedDevices => 'Appareils connectés';
	String get contactSupport => 'Contacter le support';
	String get reportIssue => 'Signaler un problème';
	String get terms => 'Conditions générales';
	String get privacyPolicy => 'Politique de confidentialité';
	String get logout => 'Se déconnecter';
	String get deleteAccount => 'Supprimer mon compte';
	String get exportData => 'Exporter mes données';
	String get save => 'Enregistrer';
	String get cancel => 'Annuler';
	String get confirm => 'Confirmer';
	String get delete => 'Supprimer';
	String get edit => 'Modifier';
}

// Path: settings.themes
class _TranslationsSettingsThemesFr {
	_TranslationsSettingsThemesFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get system => 'Système';
	String get light => 'Clair';
	String get dark => 'Sombre';
}

// Path: settings.languages
class _TranslationsSettingsLanguagesFr {
	_TranslationsSettingsLanguagesFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get french => 'Français';
	String get english => 'English';
}

// Path: settings.messages
class _TranslationsSettingsMessagesFr {
	_TranslationsSettingsMessagesFr._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get profileUpdated => 'Profil mis à jour.';
	String get passwordUpdated => 'Mot de passe mis à jour.';
	String get logoutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter ?';
	String get deleteAccountConfirm => 'Cette action est irréversible. Continuer ?';
	String get dataExportInfo => 'Une archive vous sera envoyée par email sous 24h.';
	String get issueReported => 'Signalement enregistré. Merci pour votre retour.';
	String get messageSent => 'Message envoyé. Nous vous répondrons sous 24h.';
	String get deviceDisconnected => 'Appareil déconnecté.';
	String get allDevicesDisconnected => 'Toutes les autres sessions ont été déconnectées.';
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
	@override late final _TranslationsDiscoveryEn discovery = _TranslationsDiscoveryEn._(_root);
	@override late final _TranslationsErrorsEn errors = _TranslationsErrorsEn._(_root);
	@override late final _TranslationsHomeEn home = _TranslationsHomeEn._(_root);
	@override late final _TranslationsMessagesEn messages = _TranslationsMessagesEn._(_root);
	@override late final _TranslationsOnboardingEn onboarding = _TranslationsOnboardingEn._(_root);
	@override late final _TranslationsRequestsEn requests = _TranslationsRequestsEn._(_root);
	@override late final _TranslationsSettingsEn settings = _TranslationsSettingsEn._(_root);
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

// Path: discovery
class _TranslationsDiscoveryEn extends _TranslationsDiscoveryFr {
	_TranslationsDiscoveryEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsDiscoverySearchEn search = _TranslationsDiscoverySearchEn._(_root);
	@override late final _TranslationsDiscoveryCategoriesEn categories = _TranslationsDiscoveryCategoriesEn._(_root);
	@override late final _TranslationsDiscoveryProvidersEn providers = _TranslationsDiscoveryProvidersEn._(_root);
}

// Path: errors
class _TranslationsErrorsEn extends _TranslationsErrorsFr {
	_TranslationsErrorsEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get generic => 'An error occurred. Please try again.';
	@override String get noConnection => 'No internet connection.';
	@override String get notFound => 'Resource not found.';
	@override String get unauthorized => 'Session expired. Please log in again.';
	@override late final _TranslationsErrorsValidationEn validation = _TranslationsErrorsValidationEn._(_root);
	@override late final _TranslationsErrorsFileEn file = _TranslationsErrorsFileEn._(_root);
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

// Path: messages
class _TranslationsMessagesEn extends _TranslationsMessagesFr {
	_TranslationsMessagesEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Messages';
	@override String get empty => 'No conversations';
	@override String get placeholder => 'Write a message...';
	@override String get send => 'Send';
	@override String get call => 'Call';
	@override late final _TranslationsMessagesStatusEn status = _TranslationsMessagesStatusEn._(_root);
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

// Path: requests
class _TranslationsRequestsEn extends _TranslationsRequestsFr {
	_TranslationsRequestsEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Requests';
	@override late final _TranslationsRequestsStatusEn status = _TranslationsRequestsStatusEn._(_root);
	@override late final _TranslationsRequestsActionsEn actions = _TranslationsRequestsActionsEn._(_root);
	@override late final _TranslationsRequestsMessagesEn messages = _TranslationsRequestsMessagesEn._(_root);
	@override late final _TranslationsRequestsMissionEn mission = _TranslationsRequestsMissionEn._(_root);
}

// Path: settings
class _TranslationsSettingsEn extends _TranslationsSettingsFr {
	_TranslationsSettingsEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Settings';
	@override late final _TranslationsSettingsSectionsEn sections = _TranslationsSettingsSectionsEn._(_root);
	@override late final _TranslationsSettingsActionsEn actions = _TranslationsSettingsActionsEn._(_root);
	@override late final _TranslationsSettingsThemesEn themes = _TranslationsSettingsThemesEn._(_root);
	@override late final _TranslationsSettingsLanguagesEn languages = _TranslationsSettingsLanguagesEn._(_root);
	@override late final _TranslationsSettingsMessagesEn messages = _TranslationsSettingsMessagesEn._(_root);
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

// Path: discovery.search
class _TranslationsDiscoverySearchEn extends _TranslationsDiscoverySearchFr {
	_TranslationsDiscoverySearchEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get placeholder => 'Search for a service...';
	@override String get filters => 'Filters';
	@override String get distance => 'Distance';
	@override String get pricePerHour => 'Price per hour';
	@override String get min => 'Min';
	@override String get max => 'Max';
	@override String get apply => 'Apply';
	@override String get reset => 'Reset';
}

// Path: discovery.categories
class _TranslationsDiscoveryCategoriesEn extends _TranslationsDiscoveryCategoriesFr {
	_TranslationsDiscoveryCategoriesEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Popular categories';
	@override String get viewAll => 'View all';
	@override String get plumbing => 'Plumbing';
	@override String get electricity => 'Electricity';
	@override String get cleaning => 'Cleaning';
	@override String get painting => 'Painting';
	@override String get it => 'IT & Technology';
	@override String get events => 'Events';
	@override String get health => 'Health & Wellness';
	@override String get construction => 'Building & Construction';
}

// Path: discovery.providers
class _TranslationsDiscoveryProvidersEn extends _TranslationsDiscoveryProvidersFr {
	_TranslationsDiscoveryProvidersEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get nearby => 'Nearby providers';
	@override String rating({required Object count}) => '${count} reviews';
	@override String get viewProfile => 'View profile';
	@override String get requestQuote => 'Request a quote';
	@override String get freeQuote => 'Free quote';
	@override String get about => 'About';
	@override String get services => 'Services';
	@override String get reviews => 'Latest reviews';
	@override String get reportReview => 'Report this review';
}

// Path: errors.validation
class _TranslationsErrorsValidationEn extends _TranslationsErrorsValidationFr {
	_TranslationsErrorsValidationEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get required => 'Required field';
	@override String get invalidEmail => 'Invalid email address';
	@override String get invalidPhone => 'Invalid phone number';
	@override String get passwordTooWeak => 'Password is too weak';
	@override String get passwordsMismatch => 'Passwords do not match';
	@override String minLength({required Object min}) => 'Must contain at least ${min} characters';
}

// Path: errors.file
class _TranslationsErrorsFileEn extends _TranslationsErrorsFileFr {
	_TranslationsErrorsFileEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get uploadFailed => 'Unable to upload the file.';
	@override String get imagePickerFailed => 'Unable to select the image.';
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

// Path: messages.status
class _TranslationsMessagesStatusEn extends _TranslationsMessagesStatusFr {
	_TranslationsMessagesStatusEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get delivered => 'Delivered';
	@override String get read => 'Read';
	@override String get typing => 'Typing...';
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

// Path: requests.status
class _TranslationsRequestsStatusEn extends _TranslationsRequestsStatusFr {
	_TranslationsRequestsStatusEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get pending => 'Pending';
	@override String get accepted => 'Accepted';
	@override String get refused => 'Refused';
	@override String get inProgress => 'In progress';
	@override String get completed => 'Completed';
	@override String get cancelled => 'Cancelled';
}

// Path: requests.actions
class _TranslationsRequestsActionsEn extends _TranslationsRequestsActionsFr {
	_TranslationsRequestsActionsEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get accept => 'Accept';
	@override String get refuse => 'Refuse';
	@override String get cancel => 'Cancel';
	@override String get complete => 'Complete';
	@override String get confirm => 'Confirm';
	@override String get viewDetails => 'View details';
}

// Path: requests.messages
class _TranslationsRequestsMessagesEn extends _TranslationsRequestsMessagesFr {
	_TranslationsRequestsMessagesEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get requestAccepted => 'Request accepted. The client will be notified.';
	@override String get requestRefused => 'Request refused. The client will be informed.';
	@override String get statusUpdated => 'Status updated.';
	@override String get chatAfterAccept => 'Messaging will open after acceptance.';
	@override String get selectRating => 'Please select a rating before submitting.';
	@override String get reviewThanks => 'Thank you for your review!';
	@override String get reportReason => 'Please specify the reason (minimum 10 characters).';
}

// Path: requests.mission
class _TranslationsRequestsMissionEn extends _TranslationsRequestsMissionFr {
	_TranslationsRequestsMissionEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mission';
	@override String get chatComingSoon => 'Messaging coming soon.';
}

// Path: settings.sections
class _TranslationsSettingsSectionsEn extends _TranslationsSettingsSectionsFr {
	_TranslationsSettingsSectionsEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get account => 'Account';
	@override String get preferences => 'Preferences';
	@override String get security => 'Security';
	@override String get support => 'Support';
	@override String get legal => 'Legal';
}

// Path: settings.actions
class _TranslationsSettingsActionsEn extends _TranslationsSettingsActionsFr {
	_TranslationsSettingsActionsEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get editProfile => 'Edit profile';
	@override String get addresses => 'My addresses';
	@override String get paymentMethods => 'Payment methods';
	@override String get notifications => 'Notifications';
	@override String get theme => 'Theme';
	@override String get language => 'Language';
	@override String get privacy => 'Privacy';
	@override String get changePassword => 'Change password';
	@override String get twoFactor => 'Two-factor authentication';
	@override String get connectedDevices => 'Connected devices';
	@override String get contactSupport => 'Contact support';
	@override String get reportIssue => 'Report an issue';
	@override String get terms => 'Terms of service';
	@override String get privacyPolicy => 'Privacy policy';
	@override String get logout => 'Log out';
	@override String get deleteAccount => 'Delete my account';
	@override String get exportData => 'Export my data';
	@override String get save => 'Save';
	@override String get cancel => 'Cancel';
	@override String get confirm => 'Confirm';
	@override String get delete => 'Delete';
	@override String get edit => 'Edit';
}

// Path: settings.themes
class _TranslationsSettingsThemesEn extends _TranslationsSettingsThemesFr {
	_TranslationsSettingsThemesEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get system => 'System';
	@override String get light => 'Light';
	@override String get dark => 'Dark';
}

// Path: settings.languages
class _TranslationsSettingsLanguagesEn extends _TranslationsSettingsLanguagesFr {
	_TranslationsSettingsLanguagesEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get french => 'Français';
	@override String get english => 'English';
}

// Path: settings.messages
class _TranslationsSettingsMessagesEn extends _TranslationsSettingsMessagesFr {
	_TranslationsSettingsMessagesEn._(_TranslationsEn root) : this._root = root, super._(root);

	@override final _TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get profileUpdated => 'Profile updated.';
	@override String get passwordUpdated => 'Password updated.';
	@override String get logoutConfirm => 'Are you sure you want to log out?';
	@override String get deleteAccountConfirm => 'This action is irreversible. Continue?';
	@override String get dataExportInfo => 'An archive will be sent to you by email within 24 hours.';
	@override String get issueReported => 'Report saved. Thank you for your feedback.';
	@override String get messageSent => 'Message sent. We will reply within 24 hours.';
	@override String get deviceDisconnected => 'Device disconnected.';
	@override String get allDevicesDisconnected => 'All other sessions have been disconnected.';
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
			case 'discovery.search.placeholder': return 'Rechercher un service...';
			case 'discovery.search.filters': return 'Filtres';
			case 'discovery.search.distance': return 'Distance';
			case 'discovery.search.pricePerHour': return 'Prix/heure';
			case 'discovery.search.min': return 'Min';
			case 'discovery.search.max': return 'Max';
			case 'discovery.search.apply': return 'Appliquer';
			case 'discovery.search.reset': return 'Réinitialiser';
			case 'discovery.categories.title': return 'Catégories populaires';
			case 'discovery.categories.viewAll': return 'Tout voir';
			case 'discovery.categories.plumbing': return 'Plomberie';
			case 'discovery.categories.electricity': return 'Électricité';
			case 'discovery.categories.cleaning': return 'Ménage';
			case 'discovery.categories.painting': return 'Peinture';
			case 'discovery.categories.it': return 'Informatique';
			case 'discovery.categories.events': return 'Événementiel';
			case 'discovery.categories.health': return 'Santé & Bien-être';
			case 'discovery.categories.construction': return 'Bâtiment & Travaux';
			case 'discovery.providers.nearby': return 'Prestataires près de vous';
			case 'discovery.providers.rating': return ({required Object count}) => '${count} avis';
			case 'discovery.providers.viewProfile': return 'Voir le profil';
			case 'discovery.providers.requestQuote': return 'Demander un devis';
			case 'discovery.providers.freeQuote': return 'Devis gratuit';
			case 'discovery.providers.about': return 'À propos';
			case 'discovery.providers.services': return 'Prestations';
			case 'discovery.providers.reviews': return 'Derniers avis';
			case 'discovery.providers.reportReview': return 'Signaler cet avis';
			case 'errors.generic': return 'Une erreur est survenue. Veuillez réessayer.';
			case 'errors.noConnection': return 'Pas de connexion internet.';
			case 'errors.notFound': return 'Ressource introuvable.';
			case 'errors.unauthorized': return 'Session expirée. Veuillez vous reconnecter.';
			case 'errors.validation.required': return 'Champ obligatoire';
			case 'errors.validation.invalidEmail': return 'Adresse email invalide';
			case 'errors.validation.invalidPhone': return 'Numéro de téléphone invalide';
			case 'errors.validation.passwordTooWeak': return 'Mot de passe trop faible';
			case 'errors.validation.passwordsMismatch': return 'Les mots de passe ne correspondent pas';
			case 'errors.validation.minLength': return ({required Object min}) => 'Doit contenir au moins ${min} caractères';
			case 'errors.file.uploadFailed': return 'Impossible de charger le fichier.';
			case 'errors.file.imagePickerFailed': return 'Impossible de sélectionner l\'image.';
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
			case 'messages.title': return 'Messages';
			case 'messages.empty': return 'Aucune conversation';
			case 'messages.placeholder': return 'Écrivez un message...';
			case 'messages.send': return 'Envoyer';
			case 'messages.call': return 'Appeler';
			case 'messages.status.delivered': return 'Livré';
			case 'messages.status.read': return 'Lu';
			case 'messages.status.typing': return 'En train d\'écrire...';
			case 'onboarding.skip': return 'Ignorer';
			case 'onboarding.start': return 'Commencer';
			case 'onboarding.next': return 'Suivant';
			case 'onboarding.pages.find.title': return 'Trouver des experts';
			case 'onboarding.pages.find.description': return 'Connectez-vous avec des prestataires vérifiés pour tous vos besoins, où que vous soyez.';
			case 'onboarding.pages.book.title': return 'Prendre rendez-vous';
			case 'onboarding.pages.book.description': return 'Planifiez vos interventions en quelques clics selon vos disponibilités.';
			case 'onboarding.pages.rate.title': return 'Noter & Évaluer';
			case 'onboarding.pages.rate.description': return 'Partagez votre expérience et aidez la communauté à grow en toute confiance.';
			case 'requests.title': return 'Demandes';
			case 'requests.status.pending': return 'En attente';
			case 'requests.status.accepted': return 'Acceptée';
			case 'requests.status.refused': return 'Refusée';
			case 'requests.status.inProgress': return 'En cours';
			case 'requests.status.completed': return 'Terminée';
			case 'requests.status.cancelled': return 'Annulée';
			case 'requests.actions.accept': return 'Accepter';
			case 'requests.actions.refuse': return 'Refuser';
			case 'requests.actions.cancel': return 'Annuler';
			case 'requests.actions.complete': return 'Terminer';
			case 'requests.actions.confirm': return 'Confirmer';
			case 'requests.actions.viewDetails': return 'Voir les détails';
			case 'requests.messages.requestAccepted': return 'Demande acceptée. Le client sera notifié.';
			case 'requests.messages.requestRefused': return 'Demande refusée. Le client sera informé.';
			case 'requests.messages.statusUpdated': return 'Statut mis à jour.';
			case 'requests.messages.chatAfterAccept': return 'La messagerie s\'ouvrira après acceptation.';
			case 'requests.messages.selectRating': return 'Sélectionnez une note avant d\'envoyer.';
			case 'requests.messages.reviewThanks': return 'Merci pour votre avis !';
			case 'requests.messages.reportReason': return 'Précisez le motif (minimum 10 caractères).';
			case 'requests.mission.title': return 'Mission';
			case 'requests.mission.chatComingSoon': return 'Messagerie à venir.';
			case 'settings.title': return 'Paramètres';
			case 'settings.sections.account': return 'Compte';
			case 'settings.sections.preferences': return 'Préférences';
			case 'settings.sections.security': return 'Sécurité';
			case 'settings.sections.support': return 'Support';
			case 'settings.sections.legal': return 'Légal';
			case 'settings.actions.editProfile': return 'Modifier le profil';
			case 'settings.actions.addresses': return 'Mes adresses';
			case 'settings.actions.paymentMethods': return 'Moyens de paiement';
			case 'settings.actions.notifications': return 'Notifications';
			case 'settings.actions.theme': return 'Thème';
			case 'settings.actions.language': return 'Langue';
			case 'settings.actions.privacy': return 'Confidentialité';
			case 'settings.actions.changePassword': return 'Changer le mot de passe';
			case 'settings.actions.twoFactor': return 'Authentification à deux facteurs';
			case 'settings.actions.connectedDevices': return 'Appareils connectés';
			case 'settings.actions.contactSupport': return 'Contacter le support';
			case 'settings.actions.reportIssue': return 'Signaler un problème';
			case 'settings.actions.terms': return 'Conditions générales';
			case 'settings.actions.privacyPolicy': return 'Politique de confidentialité';
			case 'settings.actions.logout': return 'Se déconnecter';
			case 'settings.actions.deleteAccount': return 'Supprimer mon compte';
			case 'settings.actions.exportData': return 'Exporter mes données';
			case 'settings.actions.save': return 'Enregistrer';
			case 'settings.actions.cancel': return 'Annuler';
			case 'settings.actions.confirm': return 'Confirmer';
			case 'settings.actions.delete': return 'Supprimer';
			case 'settings.actions.edit': return 'Modifier';
			case 'settings.themes.system': return 'Système';
			case 'settings.themes.light': return 'Clair';
			case 'settings.themes.dark': return 'Sombre';
			case 'settings.languages.french': return 'Français';
			case 'settings.languages.english': return 'English';
			case 'settings.messages.profileUpdated': return 'Profil mis à jour.';
			case 'settings.messages.passwordUpdated': return 'Mot de passe mis à jour.';
			case 'settings.messages.logoutConfirm': return 'Êtes-vous sûr de vouloir vous déconnecter ?';
			case 'settings.messages.deleteAccountConfirm': return 'Cette action est irréversible. Continuer ?';
			case 'settings.messages.dataExportInfo': return 'Une archive vous sera envoyée par email sous 24h.';
			case 'settings.messages.issueReported': return 'Signalement enregistré. Merci pour votre retour.';
			case 'settings.messages.messageSent': return 'Message envoyé. Nous vous répondrons sous 24h.';
			case 'settings.messages.deviceDisconnected': return 'Appareil déconnecté.';
			case 'settings.messages.allDevicesDisconnected': return 'Toutes les autres sessions ont été déconnectées.';
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
			case 'discovery.search.placeholder': return 'Search for a service...';
			case 'discovery.search.filters': return 'Filters';
			case 'discovery.search.distance': return 'Distance';
			case 'discovery.search.pricePerHour': return 'Price per hour';
			case 'discovery.search.min': return 'Min';
			case 'discovery.search.max': return 'Max';
			case 'discovery.search.apply': return 'Apply';
			case 'discovery.search.reset': return 'Reset';
			case 'discovery.categories.title': return 'Popular categories';
			case 'discovery.categories.viewAll': return 'View all';
			case 'discovery.categories.plumbing': return 'Plumbing';
			case 'discovery.categories.electricity': return 'Electricity';
			case 'discovery.categories.cleaning': return 'Cleaning';
			case 'discovery.categories.painting': return 'Painting';
			case 'discovery.categories.it': return 'IT & Technology';
			case 'discovery.categories.events': return 'Events';
			case 'discovery.categories.health': return 'Health & Wellness';
			case 'discovery.categories.construction': return 'Building & Construction';
			case 'discovery.providers.nearby': return 'Nearby providers';
			case 'discovery.providers.rating': return ({required Object count}) => '${count} reviews';
			case 'discovery.providers.viewProfile': return 'View profile';
			case 'discovery.providers.requestQuote': return 'Request a quote';
			case 'discovery.providers.freeQuote': return 'Free quote';
			case 'discovery.providers.about': return 'About';
			case 'discovery.providers.services': return 'Services';
			case 'discovery.providers.reviews': return 'Latest reviews';
			case 'discovery.providers.reportReview': return 'Report this review';
			case 'errors.generic': return 'An error occurred. Please try again.';
			case 'errors.noConnection': return 'No internet connection.';
			case 'errors.notFound': return 'Resource not found.';
			case 'errors.unauthorized': return 'Session expired. Please log in again.';
			case 'errors.validation.required': return 'Required field';
			case 'errors.validation.invalidEmail': return 'Invalid email address';
			case 'errors.validation.invalidPhone': return 'Invalid phone number';
			case 'errors.validation.passwordTooWeak': return 'Password is too weak';
			case 'errors.validation.passwordsMismatch': return 'Passwords do not match';
			case 'errors.validation.minLength': return ({required Object min}) => 'Must contain at least ${min} characters';
			case 'errors.file.uploadFailed': return 'Unable to upload the file.';
			case 'errors.file.imagePickerFailed': return 'Unable to select the image.';
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
			case 'messages.title': return 'Messages';
			case 'messages.empty': return 'No conversations';
			case 'messages.placeholder': return 'Write a message...';
			case 'messages.send': return 'Send';
			case 'messages.call': return 'Call';
			case 'messages.status.delivered': return 'Delivered';
			case 'messages.status.read': return 'Read';
			case 'messages.status.typing': return 'Typing...';
			case 'onboarding.skip': return 'Skip';
			case 'onboarding.start': return 'Get Started';
			case 'onboarding.next': return 'Next';
			case 'onboarding.pages.find.title': return 'Find Professionals';
			case 'onboarding.pages.find.description': return 'Connect with verified experts in your area for any task you need.';
			case 'onboarding.pages.book.title': return 'Book Appointments';
			case 'onboarding.pages.book.description': return 'Schedule services seamlessly at your convenience.';
			case 'onboarding.pages.rate.title': return 'Rate & Review';
			case 'onboarding.pages.rate.description': return 'Share your experience and help the community grow.';
			case 'requests.title': return 'Requests';
			case 'requests.status.pending': return 'Pending';
			case 'requests.status.accepted': return 'Accepted';
			case 'requests.status.refused': return 'Refused';
			case 'requests.status.inProgress': return 'In progress';
			case 'requests.status.completed': return 'Completed';
			case 'requests.status.cancelled': return 'Cancelled';
			case 'requests.actions.accept': return 'Accept';
			case 'requests.actions.refuse': return 'Refuse';
			case 'requests.actions.cancel': return 'Cancel';
			case 'requests.actions.complete': return 'Complete';
			case 'requests.actions.confirm': return 'Confirm';
			case 'requests.actions.viewDetails': return 'View details';
			case 'requests.messages.requestAccepted': return 'Request accepted. The client will be notified.';
			case 'requests.messages.requestRefused': return 'Request refused. The client will be informed.';
			case 'requests.messages.statusUpdated': return 'Status updated.';
			case 'requests.messages.chatAfterAccept': return 'Messaging will open after acceptance.';
			case 'requests.messages.selectRating': return 'Please select a rating before submitting.';
			case 'requests.messages.reviewThanks': return 'Thank you for your review!';
			case 'requests.messages.reportReason': return 'Please specify the reason (minimum 10 characters).';
			case 'requests.mission.title': return 'Mission';
			case 'requests.mission.chatComingSoon': return 'Messaging coming soon.';
			case 'settings.title': return 'Settings';
			case 'settings.sections.account': return 'Account';
			case 'settings.sections.preferences': return 'Preferences';
			case 'settings.sections.security': return 'Security';
			case 'settings.sections.support': return 'Support';
			case 'settings.sections.legal': return 'Legal';
			case 'settings.actions.editProfile': return 'Edit profile';
			case 'settings.actions.addresses': return 'My addresses';
			case 'settings.actions.paymentMethods': return 'Payment methods';
			case 'settings.actions.notifications': return 'Notifications';
			case 'settings.actions.theme': return 'Theme';
			case 'settings.actions.language': return 'Language';
			case 'settings.actions.privacy': return 'Privacy';
			case 'settings.actions.changePassword': return 'Change password';
			case 'settings.actions.twoFactor': return 'Two-factor authentication';
			case 'settings.actions.connectedDevices': return 'Connected devices';
			case 'settings.actions.contactSupport': return 'Contact support';
			case 'settings.actions.reportIssue': return 'Report an issue';
			case 'settings.actions.terms': return 'Terms of service';
			case 'settings.actions.privacyPolicy': return 'Privacy policy';
			case 'settings.actions.logout': return 'Log out';
			case 'settings.actions.deleteAccount': return 'Delete my account';
			case 'settings.actions.exportData': return 'Export my data';
			case 'settings.actions.save': return 'Save';
			case 'settings.actions.cancel': return 'Cancel';
			case 'settings.actions.confirm': return 'Confirm';
			case 'settings.actions.delete': return 'Delete';
			case 'settings.actions.edit': return 'Edit';
			case 'settings.themes.system': return 'System';
			case 'settings.themes.light': return 'Light';
			case 'settings.themes.dark': return 'Dark';
			case 'settings.languages.french': return 'Français';
			case 'settings.languages.english': return 'English';
			case 'settings.messages.profileUpdated': return 'Profile updated.';
			case 'settings.messages.passwordUpdated': return 'Password updated.';
			case 'settings.messages.logoutConfirm': return 'Are you sure you want to log out?';
			case 'settings.messages.deleteAccountConfirm': return 'This action is irreversible. Continue?';
			case 'settings.messages.dataExportInfo': return 'An archive will be sent to you by email within 24 hours.';
			case 'settings.messages.issueReported': return 'Report saved. Thank you for your feedback.';
			case 'settings.messages.messageSent': return 'Message sent. We will reply within 24 hours.';
			case 'settings.messages.deviceDisconnected': return 'Device disconnected.';
			case 'settings.messages.allDevicesDisconnected': return 'All other sessions have been disconnected.';
			default: return null;
		}
	}
}
