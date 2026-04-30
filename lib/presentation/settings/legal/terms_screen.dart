import 'package:flutter/material.dart';

import '_legal_document_view.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentView(
      title: 'Conditions générales',
      subtitle: 'CGU et CGV de la plateforme',
      lastUpdated: '01/04/2026',
      sections: [
        LegalSection(
          title: 'Acceptation des conditions',
          paragraphs: [
            'Les présentes Conditions Générales d\'Utilisation régissent l\'accès à l\'application PrestaHub ainsi que les services proposés. En utilisant l\'application, l\'utilisateur accepte sans réserve ces conditions.',
            'PrestaHub se réserve le droit de modifier ces conditions à tout moment. Les utilisateurs seront notifiés en cas de changement substantiel.',
          ],
        ),
        LegalSection(
          title: 'Description du service',
          paragraphs: [
            'PrestaHub est une plateforme de mise en relation entre clients et prestataires de services. Nous ne sommes pas partie aux contrats conclus entre utilisateurs.',
            'La plateforme permet aux clients de publier des demandes, aux prestataires d\'y répondre, et aux deux parties d\'échanger via la messagerie intégrée.',
          ],
        ),
        LegalSection(
          title: 'Inscription et compte',
          paragraphs: [
            'L\'inscription est gratuite et nécessite la fourniture d\'informations exactes. Chaque utilisateur est responsable de la confidentialité de ses identifiants.',
            'Les prestataires doivent fournir des justificatifs professionnels valides. PrestaHub se réserve le droit de refuser ou suspendre un compte non conforme.',
          ],
        ),
        LegalSection(
          title: 'Obligations des utilisateurs',
          paragraphs: [
            'L\'utilisateur s\'engage à utiliser la plateforme de bonne foi, à ne pas publier de contenu illégal, trompeur ou diffamatoire, et à respecter les lois en vigueur.',
            'Tout manquement pourra entraîner une suspension immédiate du compte, sans préjudice de poursuites éventuelles.',
          ],
        ),
        LegalSection(
          title: 'Responsabilité',
          paragraphs: [
            'PrestaHub agit en tant qu\'intermédiaire technique. Nous ne sommes pas responsables de l\'exécution des prestations ni des éventuels litiges entre utilisateurs.',
            'Nous nous efforçons toutefois de proposer des mécanismes de médiation et de signalement pour accompagner nos utilisateurs.',
          ],
        ),
        LegalSection(
          title: 'Résiliation',
          paragraphs: [
            'Tout utilisateur peut supprimer son compte à tout moment depuis les paramètres. La suppression est définitive après un délai de rétention de 30 jours.',
            'PrestaHub peut suspendre ou résilier un compte en cas de violation des présentes conditions.',
          ],
        ),
      ],
    );
  }
}
