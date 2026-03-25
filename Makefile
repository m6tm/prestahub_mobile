.PHONY: help install clean build run test analyze format i18n generate build-apk-debug build-apk-release build-ios-debug build-ios-release

help:
	@echo "Commandes disponibles pour PrestaHub Mobile :"
	@echo "----------------------------------------------"
	@echo "  make install            - Installe les dépendances du projet (flutter pub get)"
	@echo "  make clean              - Nettoie le projet (flutter clean) et réinstalle les dépendances"
	@echo "  make i18n               - Génère les fichiers de traduction interactifs via slang"
	@echo "  make generate           - Exécute build_runner pour générer le code (Hive, etc.)"
	@echo "  make lint            - Lance l'analyseur statique Flutter (lints)"
	@echo "  make format             - Formate le code source avec dart format"
	@echo "  make test               - Lance les tests unitaires et de widgets"
	@echo "  make run                - Lance l'application sur l'appareil/émulateur par défaut"
	@echo "  make build-apk-debug    - Construit le package Android APK (debug)"
	@echo "  make build-apk-release  - Construit le package Android APK (release)"
	@echo "  make build-ios-debug    - Construit l'application iOS (debug, sans signature)"
	@echo "  make build-ios-release  - Construit l'application iOS (release, sans signature)"

install:
	flutter pub get

clean:
	flutter clean
	flutter pub get

i18n:
	dart run slang

generate:
	dart run build_runner build --delete-conflicting-outputs

lint:
	flutter analyze

format:
	dart format lib test

test:
	flutter test

run:
	flutter run

build-apk-debug:
	flutter build apk --debug

build-apk-release:
	flutter build apk --release

build-ios-debug:
	flutter build ios --debug --no-codesign

build-ios-release:
	flutter build ios --release --no-codesign
