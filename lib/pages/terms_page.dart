import 'package:flutter/material.dart';
import 'package:snde/functions.dart';

class TermsPage extends StatefulWidget {
  TermsPage({Key? key}) : super(key: key);

  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t(context, 'terms')), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: [
          Text("""Conditions générales d'utilisation de la plateforme

La plateforme est accessible gratuitement en tout lieu à tout Utilisateur ayant un accès à Internet. Tous les frais supportés par l'Utilisateur pour accéder au service (matériel informatique, logiciels, connexion Internet, etc.) sont à sa charge.

L’Utilisateur non membre n'a pas accès aux services réservés. Pour cela, il doit s’inscrire en remplissant le formulaire. En acceptant de s’inscrire aux services réservés, l’Utilisateur membre s’engage à fournir des informations sincères et exactes concernant son état civil et ses coordonnées, notamment son téléphone et sa référence.

Pour accéder aux services, l’Utilisateur devra s'identifier à l'aide de son N° Téléphone et de son mot de passe. Son mot de passe est strictement personnel. A ce titre, il s’en interdit toute divulgation. Dans le cas contraire, il restera seul responsable de l’usage qui en sera fait

L'Utilisateur s'assure de garder son mot de passe secret. Toute divulgation du mot de passe, quelle que soit sa forme, est interdite. Il assume les risques liés à l'utilisation de son identifiant et mot de passe. Le site décline toute responsabilité.

Tout contenu mis en ligne par l'Utilisateur est de sa seule responsabilité. L'Utilisateur s'engage à ne pas mettre en ligne des contenus pouvant porter atteinte aux intérêts de tierces personnes. Tout recours en justice engagé par un tiers lésé contre la plateforme sera pris en charge par l'Utilisateur.


          """, textAlign: TextAlign.left)
        ]),
      ),
    );
  }
}
