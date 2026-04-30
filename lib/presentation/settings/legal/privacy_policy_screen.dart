import 'package:flutter/material.dart';

import '_legal_document_view.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentView(
      title: 'Politique de confidentialité',
      subtitle: 'Vos données et vos droits',
      lastUpdated: '01/04/2026',
      sections: [
        LegalSection(
          title: 'Responsable du traitement',
          paragraphs: [
            'PrestaHub est responsable du traitement des données personnelles collectées dans le cadre de l\'utilisation de l\'application.',
            'Pour toute question relative à cette politique, vous pouvez nous contacter via la rubrique Aide ou par email : privacy@prestahub.com.',
          ],
        ),
        LegalSection(
          title: 'Données collectées',
          paragraphs: [
            'Nous collectons les données que vous fournissez lors de l\'inscription (nom, email, téléphone), celles générées par votre usage (demandes, messages) et certaines données techniques (type d\'appareil, adresse IP).',
            'La géolocalisation est utilisée uniquement avec votre consentement et pour faciliter la mise en relation avec les prestataires proches.',
          ],
        ),
        LegalSection(
          title: 'Finalités',
          paragraphs: [
            'Vos données sont utilisées pour fournir le service, améliorer notre plateforme, garantir la sécurité, et, avec votre accord, vous adresser des communications marketing.',
            'Aucune vente de données personnelles à des tiers n\'est effectuée.',
          ],
        ),
        LegalSection(
          title: 'Durée de conservation',
          paragraphs: [
            'Les données sont conservées pendant toute la durée de votre inscription, puis archivées ou anonymisées selon la réglementation applicable.',
            'Vous pouvez demander la suppression anticipée de vos données via la rubrique Confidentialité des paramètres.',
          ],
        ),
        LegalSection(
          title: 'Vos droits',
          paragraphs: [
            'Vous disposez d\'un droit d\'accès, de rectification, d\'effacement, de limitation, de portabilité et d\'opposition sur vos données personnelles.',
            'Pour exercer ces droits, contactez-nous à privacy@prestahub.com. Vous pouvez également introduire une réclamation auprès de la CNIL.',
          ],
        ),
        LegalSection(
          title: 'Cookies et traceurs',
          paragraphs: [
            'PrestaHub utilise uniquement les traceurs nécessaires au fonctionnement de l\'application. Les traceurs analytiques ne sont activés qu\'avec votre consentement préalable.',
          ],
        ),
      ],
    );
  }
}
