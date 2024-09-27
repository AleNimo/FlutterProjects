import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String link;

  const MenuItem({
    required this.title,
    required this.icon,
    required this.link,
  });
}

const List<MenuItem> menuItems = [
  MenuItem(
    title: 'Perfil de Usuario',
    icon: Icons.person,
    link: '/userProfile',
  ),
  MenuItem(
    title: 'Configuración',
    icon: Icons.settings,
    link: '/configuration',
  ),
  MenuItem(
    title: 'Cerrar sesión',
    icon: Icons.logout,
    link: '/login', //(vuelve a pantalla de login)
  ),
];
