import 'package:flutter/material.dart';

/// NavigatorKey global para navegación desde cualquier parte de la app
/// Útil para navegación desde callbacks o servicios sin contexto
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

