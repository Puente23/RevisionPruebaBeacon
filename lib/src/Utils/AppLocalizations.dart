import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Fonts.dart';

class AppLocalizations {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Aquí irían las traducciones en inglés
      'title': Strings.appBarTitle,
      'nombreAplicacion': Strings.appName,
      'inicioSesion': Strings.signIn,
      'usuario': Strings.username,
      'contrasena': Strings.password,
      'mensajeCamposVacios': Strings.emptyFieldsMessage,
      'mensajeCredencialesInvalidas': Strings.invalidCredentialsMessage,
      'descripcionApp': Strings.appDescription,
      'iniciarSesion': Strings.logIn,
      'ajustes': Strings.settings,
      'modoOscuro': Strings.darkMode,
      'ubicacion': Strings.location,
      'zona': Strings.zone,
      'actividad': Strings.activity,
      'cancelar': Strings.cancel,
      'finalizar': Strings.finish,
      'continuar': Strings.continueButton,
      'preguntas': Strings.questions,
      'preguntasContestadas': Strings.answeredQuestions,
      'preguntasFaltantes': Strings.remainingQuestions,
      'appBarTitle': Strings.appBarTitle0,
      'identifierLabel': Strings.identifierLabel0,
      'informationLabel': Strings.informationLabel0,
      'settingsLabel': Strings.settingsLabel0,
      'inicioLabel': Strings.homeLabel,
      'ajustesLabel': Strings.settingsLabel1,
    },
    'es': {
      // Aquí irían las traducciones en español
      'title': Strings.appBarTitle,
      'nombreAplicacion': Strings.nombreAplicacion,
      'inicioSesion': Strings.inicioSesion,
      'usuario': Strings.usuario,
      'contrasena': Strings.contrasena,
      'mensajeCamposVacios': Strings.mensajeCamposVacios,
      'mensajeCredencialesInvalidas': Strings.mensajeCredencialesInvalidas,
      'descripcionApp': Strings.descripcionApp,
      'iniciarSesion': Strings.iniciarSesion,
      'ajustes': Strings.ajustes,
      'modoOscuro': Strings.modoOscuro,
      'ubicacion': Strings.ubicacion,
      'zona': Strings.zona,
      'actividad': Strings.actividad,
      'cancelar': Strings.cancelar,
      'finalizar': Strings.finalizar,
      'continuar': Strings.continuar,
      'preguntas': Strings.preguntas,
      'preguntasContestadas': Strings.preguntasContestadas,
      'preguntasFaltantes': Strings.preguntasFaltantes,
      'appBarTitle': Strings.appBarTitle,
      'identifierLabel': Strings.identifierLabel,
      'informationLabel': Strings.informationLabel,
      'settingsLabel': Strings.settingsLabel,
      'inicioLabel': Strings.inicioLabel,
      'ajustesLabel': Strings.ajustesLabel,
    },
    'pt': {
      // Aquí irían las traducciones en portugués
    },
    'de': {
      // Aquí irían las traducciones en alemán
    },
  };

  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Funciones para obtener las traducciones

  String get title {
    return _localizedValues[locale.languageCode]!['title']!;
  }

  String get nombreAplicacion {
    return _localizedValues[locale.languageCode]!['nombreAplicacion']!;
  }

  String get inicioSesion {
    return _localizedValues[locale.languageCode]!['inicioSesion']!;
  }

  String get usuario {
    return _localizedValues[locale.languageCode]!['usuario']!;
  }

  String get contrasena {
    return _localizedValues[locale.languageCode]!['contrasena']!;
  }

  String get mensajeCamposVacios {
    return _localizedValues[locale.languageCode]!['mensajeCamposVacios']!;
  }

  String get mensajeCredencialesInvalidas {
    return _localizedValues[locale.languageCode]![
        'mensajeCredencialesInvalidas']!;
  }

  String get descripcionApp {
    return _localizedValues[locale.languageCode]!['descripcionApp']!;
  }

  String get iniciarSesion {
    return _localizedValues[locale.languageCode]!['iniciarSesion']!;
  }

  String get ajustes {
    return _localizedValues[locale.languageCode]!['ajustes']!;
  }

  String get modoOscuro {
    return _localizedValues[locale.languageCode]!['modoOscuro']!;
  }

  String get ubicacion {
    return _localizedValues[locale.languageCode]!['ubicacion']!;
  }

  String get zona {
    return _localizedValues[locale.languageCode]!['zona']!;
  }

  String get actividad {
    return _localizedValues[locale.languageCode]!['actividad']!;
  }

  String get cancelar {
    return _localizedValues[locale.languageCode]!['cancelar']!;
  }

  String get finalizar {
    return _localizedValues[locale.languageCode]!['finalizar']!;
  }

  String get continuar {
    return _localizedValues[locale.languageCode]!['continuar']!;
  }

  String get preguntas {
    return _localizedValues[locale.languageCode]!['preguntas']!;
  }

  String get preguntasContestadas {
    return _localizedValues[locale.languageCode]!['preguntasContestadas']!;
  }

  String get preguntasFaltantes {
    return _localizedValues[locale.languageCode]!['preguntasFaltantes']!;
  }

  String get appBarTitle {
    return _localizedValues[locale.languageCode]!['appBarTitle']!;
  }

  String get identifierLabel {
    return _localizedValues[locale.languageCode]!['identifierLabel']!;
  }

  String get informationLabel {
    return _localizedValues[locale.languageCode]!['informationLabel']!;
  }

  String get settingsLabel {
    return _localizedValues[locale.languageCode]!['settingsLabel']!;
  }

  String get inicioLabel {
    return _localizedValues[locale.languageCode]!['inicioLabel']!;
  }

  String get ajustesLabel {
    return _localizedValues[locale.languageCode]!['ajustesLabel']!;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) {
    // Aquí se especifican los idiomas soportados por la aplicación
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
