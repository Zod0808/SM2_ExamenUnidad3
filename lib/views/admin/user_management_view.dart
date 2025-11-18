import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../models/usuario_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/status_widgets.dart';

class UserManagementView extends StatefulWidget {
  @override
  _UserManagementViewState createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsuarios();
    });
  }

  Future<void> _loadUsuarios() async {
    final adminViewModel = Provider.of<AdminViewModel>(context, listen: false);
    await adminViewModel.loadUsuarios();
  }

  void _showCreateUserDialog() {
    showDialog(context: context, builder: (context) => CreateUserDialog());
  }

  void _showChangePasswordDialog(UsuarioModel usuario) {
    showDialog(
      context: context,
      builder: (context) => ChangePasswordDialog(usuario: usuario),
    );
  }

  void _showEditUserDialog(UsuarioModel usuario) {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(usuario: usuario),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        if (adminViewModel.isLoading && adminViewModel.usuarios.isEmpty) {
          return LoadingWidget(message: 'Cargando usuarios...');
        }

        if (adminViewModel.errorMessage != null &&
            adminViewModel.usuarios.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              SizedBox(height: 16),
              Text(adminViewModel.errorMessage!, textAlign: TextAlign.center),
              SizedBox(height: 16),
              CustomButton(text: 'Reintentar', onPressed: _loadUsuarios),
            ],
          );
        }

        return RefreshIndicator(
          onRefresh: _loadUsuarios,
          child: Column(
            children: [
              // Header con botón para crear usuario
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gestión de Usuarios',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    CustomButton(
                      text: 'Nuevo Usuario',
                      icon: Icons.person_add,
                      isLoading: adminViewModel.isLoading,
                      onPressed: _showCreateUserDialog,
                    ),
                  ],
                ),
              ),

              // Mensajes de estado
              if (adminViewModel.successMessage != null)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    border: Border.all(color: Colors.green[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          adminViewModel.successMessage!,
                          style: TextStyle(color: Colors.green[700]),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18),
                        onPressed: () => adminViewModel.clearMessages(),
                      ),
                    ],
                  ),
                ),

              if (adminViewModel.errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red[600], size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          adminViewModel.errorMessage!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18),
                        onPressed: () => adminViewModel.clearMessages(),
                      ),
                    ],
                  ),
                ),

              // Lista de usuarios
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: adminViewModel.usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = adminViewModel.usuarios[index];
                    return _buildUserCard(usuario);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserCard(UsuarioModel usuario) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor:
              usuario.isAdmin ? Colors.purple[100] : Colors.blue[100],
          child: Icon(
            usuario.isAdmin ? Icons.admin_panel_settings : Icons.person,
            color: usuario.isAdmin ? Colors.purple : Colors.blue,
          ),
        ),
        title: Text(
          usuario.nombreCompleto,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('Email: ${usuario.email}'),
            Text('DNI: ${usuario.dni}'),
            Text('Rango: ${usuario.rango}'),
            if (usuario.puertaACargo != null)
              Text('Puerta: ${usuario.puertaACargo}'),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Toggle de estado activo/inactivo
            Consumer<AdminViewModel>(
              builder: (context, adminViewModel, child) {
                return Switch(
                  value: usuario.isActive,
                  activeColor: Colors.green,
                  onChanged:
                      adminViewModel.isLoading
                          ? null
                          : (bool value) async {
                            // Confirmación antes de desactivar (US007)
                            if (!value) {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(Icons.warning, color: Colors.orange),
                                      SizedBox(width: 8),
                                      Text('Desactivar Usuario'),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '¿Está seguro de que desea desactivar la cuenta de:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${usuario.nombreCompleto}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
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
                                            Icon(Icons.info_outline, 
                                              color: Colors.orange[700], size: 20),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'El usuario no podrá iniciar sesión hasta que sea reactivado.',
                                                style: TextStyle(
                                                  fontSize: 12,
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
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: Text('Desactivar'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm != true) {
                                return; // Usuario canceló
                              }
                            }

                            // Ejecutar cambio de estado
                            final success = await adminViewModel
                                .toggleUserStatus(usuario.id, value);
                            
                            if (mounted) {
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          value ? Icons.check_circle : Icons.block,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            value
                                                ? '✅ Usuario activado exitosamente'
                                                : '⚠️ Usuario desactivado. No podrá iniciar sesión.',
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: value ? Colors.green : Colors.orange,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '❌ Error al cambiar estado del usuario',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                );
              },
            ),
            // Estado del usuario
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: usuario.isActive ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                usuario.estado,
                style: TextStyle(
                  color: usuario.isActive ? Colors.green[700] : Colors.red[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Menú de acciones
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditUserDialog(usuario);
                } else if (value == 'change_password') {
                  _showChangePasswordDialog(usuario);
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Editar Usuario'),
                        ],
                      ),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'change_password',
                      child: Row(
                        children: [
                          Icon(Icons.lock_reset, size: 18),
                          SizedBox(width: 8),
                          Text('Cambiar Contraseña'),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreateUserDialog extends StatefulWidget {
  @override
  _CreateUserDialogState createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _puertaController = TextEditingController();

  String _selectedRango = 'guardia';

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    _puertaController.dispose();
    super.dispose();
  }

  void _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final adminViewModel = Provider.of<AdminViewModel>(context, listen: false);

    final nuevoUsuario = UsuarioModel(
      id: '', // Se genera en el servidor
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      dni: _dniController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rango: _selectedRango,
      estado: 'activo',
      telefono:
          _telefonoController.text.trim().isEmpty
              ? null
              : _telefonoController.text.trim(),
      puertaACargo:
          _puertaController.text.trim().isEmpty
              ? null
              : _puertaController.text.trim(),
    );

    bool success = await adminViewModel.createUsuario(nuevoUsuario);
    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Crear Nuevo Usuario'),
      content: Container(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Nombre',
                  controller: _nombreController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                CustomTextField(
                  label: 'Apellido',
                  controller: _apellidoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el apellido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                CustomTextField(
                  label: 'DNI',
                  controller: _dniController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el DNI';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  isEmail: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                CustomTextField(
                  label: 'Contraseña',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese la contraseña';
                    }
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Selector de rango
                DropdownButtonFormField<String>(
                  value: _selectedRango,
                  decoration: InputDecoration(
                    labelText: 'Rango',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'guardia', child: Text('Guardia')),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Administrador'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRango = value!;
                    });
                  },
                ),
                SizedBox(height: 16),

                CustomTextField(
                  label: 'Teléfono (Opcional)',
                  controller: _telefonoController,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),

                CustomTextField(
                  label: 'Puerta a Cargo (Opcional)',
                  controller: _puertaController,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        Consumer<AdminViewModel>(
          builder: (context, adminViewModel, child) {
            return ElevatedButton(
              onPressed: adminViewModel.isLoading ? null : _handleCreate,
              child:
                  adminViewModel.isLoading
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text('Crear Usuario'),
            );
          },
        ),
      ],
    );
  }
}

class ChangePasswordDialog extends StatefulWidget {
  final UsuarioModel usuario;

  const ChangePasswordDialog({Key? key, required this.usuario})
    : super(key: key);

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final adminViewModel = Provider.of<AdminViewModel>(context, listen: false);

    bool success = await adminViewModel.changeUserPassword(
      widget.usuario.id,
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cambiar Contraseña'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cambiar contraseña para: ${widget.usuario.nombreCompleto}'),
            SizedBox(height: 16),

            CustomTextField(
              label: 'Nueva Contraseña',
              controller: _passwordController,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese la nueva contraseña';
                }
                if (value.length < 6) {
                  return 'Mínimo 6 caracteres';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            CustomTextField(
              label: 'Confirmar Contraseña',
              controller: _confirmPasswordController,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirme la contraseña';
                }
                if (value != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        Consumer<AdminViewModel>(
          builder: (context, adminViewModel, child) {
            return ElevatedButton(
              onPressed:
                  adminViewModel.isLoading ? null : _handleChangePassword,
              child:
                  adminViewModel.isLoading
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text('Cambiar'),
            );
          },
        ),
      ],
    );
  }
}

class EditUserDialog extends StatefulWidget {
  final UsuarioModel usuario;

  const EditUserDialog({Key? key, required this.usuario}) : super(key: key);

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _apellidoController;
  late final TextEditingController _dniController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _puertaController;
  late String _selectedRango;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.usuario.nombre);
    _apellidoController = TextEditingController(text: widget.usuario.apellido);
    _dniController = TextEditingController(text: widget.usuario.dni);
    _emailController = TextEditingController(text: widget.usuario.email);
    _telefonoController = TextEditingController(text: widget.usuario.telefono ?? '');
    _puertaController = TextEditingController(text: widget.usuario.puertaACargo ?? '');
    _selectedRango = widget.usuario.rango;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _puertaController.dispose();
    super.dispose();
  }

  void _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final adminViewModel = Provider.of<AdminViewModel>(context, listen: false);

    final usuarioActualizado = UsuarioModel(
      id: widget.usuario.id,
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      dni: _dniController.text.trim(),
      email: _emailController.text.trim(),
      password: widget.usuario.password, // No cambiar contraseña aquí
      rango: _selectedRango,
      estado: widget.usuario.estado, // No cambiar estado aquí
      telefono: _telefonoController.text.trim().isEmpty
          ? null
          : _telefonoController.text.trim(),
      puertaACargo: _puertaController.text.trim().isEmpty
          ? null
          : _puertaController.text.trim(),
      fechaCreacion: widget.usuario.fechaCreacion,
      fechaActualizacion: DateTime.now(),
    );

    bool success = await adminViewModel.updateUsuario(usuarioActualizado);
    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Usuario actualizado exitosamente'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit, color: Theme.of(context).primaryColor),
          SizedBox(width: 8),
          Text('Editar Usuario'),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Nombre',
                  controller: _nombreController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Apellido',
                  controller: _apellidoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el apellido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'DNI',
                  controller: _dniController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el DNI';
                    }
                    if (value.length != 8) {
                      return 'DNI debe tener 8 dígitos';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  isEmail: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRango,
                  decoration: InputDecoration(
                    labelText: 'Rango',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'guardia', child: Text('Guardia')),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Administrador'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRango = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Teléfono (Opcional)',
                  controller: _telefonoController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value.length < 9 || value.length > 12) {
                        return 'Teléfono inválido';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  label: 'Puerta a Cargo (Opcional)',
                  controller: _puertaController,
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Los cambios se registrarán en el historial de modificaciones.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        Consumer<AdminViewModel>(
          builder: (context, adminViewModel, child) {
            return ElevatedButton.icon(
              onPressed: adminViewModel.isLoading ? null : _handleUpdate,
              icon: Icon(Icons.save, size: 18),
              label: adminViewModel.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Guardar Cambios'),
            );
          },
        ),
      ],
    );
  }
}
