import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/session_service.dart';

/// Widget que muestra advertencia cuando la sesión está por expirar
class SessionWarningWidget extends StatefulWidget {
  const SessionWarningWidget({Key? key}) : super(key: key);

  @override
  State<SessionWarningWidget> createState() => _SessionWarningWidgetState();
}

class _SessionWarningWidgetState extends State<SessionWarningWidget> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Solo mostrar si el usuario está logueado
        if (!authViewModel.isLoggedIn) {
          return SizedBox.shrink();
        }

        // Mostrar diálogo cuando hay advertencia y no se ha mostrado
        if (authViewModel.hasSessionWarning() && !_dialogShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && authViewModel.isLoggedIn) {
              _showWarningDialog(context, authViewModel);
            }
          });
        }

        return SizedBox.shrink();
      },
    );
  }

  void _showWarningDialog(BuildContext context, AuthViewModel authViewModel) {
    if (_dialogShown) return;
    _dialogShown = true;

    final sessionService = authViewModel.sessionService;
    final remainingMinutes = sessionService.warningTimeMinutes;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false, // No permitir cerrar con back button
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 32,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Sesión por Expirar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu sesión expirará en aproximadamente $remainingMinutes minutos.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Si no realizas ninguna acción, serás desconectado automáticamente.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _dialogShown = false;
                authViewModel.clearSessionWarning();
              },
              child: Text(
                'Entendido',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Extender sesión
                authViewModel.extendSession();
                if (mounted) {
                  Navigator.of(context).pop();
                  _dialogShown = false;
                  authViewModel.clearSessionWarning();

                  // Mostrar confirmación
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Sesión extendida exitosamente'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: Icon(Icons.refresh, size: 18),
              label: Text('Extender Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

