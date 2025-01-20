import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'welcome_back': 'Welcome Back!',
          'email': 'Email',
          'password': 'Password',
          'login': 'Login',
          "don't_have_account": "Don't have an account? Register",
          'create_account': 'Create Account',
          'full_name': 'Full Name',
          'register': 'Register',
          'already_have_account': 'Already have an account? Login',
        },
        'fr_FR': {
          'welcome_back': 'Bon Retour !',
          'email': 'E-mail',
          'password': 'Mot de passe',
          'login': 'Se connecter',
          "don't_have_account": "Vous n'avez pas de compte ? Inscrivez-vous",
          'create_account': 'Créer un Compte',
          'full_name': 'Nom Complet',
          'register': "S'inscrire",
          'already_have_account': 'Vous avez déjà un compte ? Connectez-vous',
        },
      };
}
