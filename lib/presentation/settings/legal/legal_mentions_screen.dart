import 'package:flutter/material.dart';

import '_legal_document_view.dart';

class LegalMentionsScreen extends StatelessWidget {
  const LegalMentionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentView(
      title: 'Mentions légales',
      subtitle: 'Informations sur l\'éditeur',
      lastUpdated: '01/04/2026',
      sections: [
        LegalSection(
          title: 'Éditeur',
          paragraphs: [
            'PrestaHub SAS, société par actions simplifiée, au capital de 10 000 €.',
            'Siège social : 1 rue de la République, 75001 Paris, France.',
            'RCS Paris · SIRET : 000 000 000 00000 · TVA intra : FR00000000000.',
          ],
        ),
        LegalSection(
          title: 'Directeur de la publication',
          paragraphs: [
            'Monsieur / Madame le Président de PrestaHub SAS.',
          ],
        ),
        LegalSection(
          title: 'Hébergement',
          paragraphs: [
            'L\'application PrestaHub est hébergée par nos partenaires cloud situés dans l\'Union Européenne.',
            'Des audits de sécurité réguliers sont réalisés pour garantir la protection des données.',
          ],
        ),
        LegalSection(
          title: 'Contact',
          paragraphs: [
            'Pour toute question légale, veuillez nous écrire à legal@prestahub.com.',
          ],
        ),
      ],
    );
  }
}
