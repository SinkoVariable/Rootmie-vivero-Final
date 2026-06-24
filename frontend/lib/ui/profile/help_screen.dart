import 'package:flutter/material.dart';


class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        title: const Text('Centro de Ayuda 🌿', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿En qué podemos ayudarte?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona una categoría para procesar tu solicitud directamente con Rootmie Vivero.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Botón hacia Formulario PQRS
            _buildHelpButton(
              context: context,
              title: 'Radicar PQRS',
              subtitle: 'Peticiones, quejas, reclamos o sugerencias del servicio.',
              icon: Icons.assignment_outlined,
              color: Colors.green[700]!,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PqrsFormScreen()),
              ),
            ),

            const SizedBox(height: 16),


            _buildHelpButton(
              context: context,
              title: 'Solicitud de reembolso o cancelacion',
              subtitle: 'Reporta inconvenientes con pagos o estados de entrega.',
              icon: Icons.currency_exchange_rounded,
              color: Colors.amber[800]!,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RefundFormScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.2)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}


class PqrsFormScreen extends StatelessWidget {
  const PqrsFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Radicar PQRS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tu opinión nos ayuda a crecer 🌿', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Cuéntanos tu inquietud o sugerencia sobre nuestros insumos y entregas.', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 24),

            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Número de Teléfono / WhatsApp', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),


            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(labelText: 'Tipo de Solicitud', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              items: const [
                DropdownMenuItem(value: 'P', child: Text('Petición (Derechos de información)', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'Q', child: Text('Queja (Malestar con el servicio)', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'R', child: Text('Reclamo (Problema directo con un producto)', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'S', child: Text('Sugerencia (Idea de mejora)', overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),

            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Describe tu caso detalladamente...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Simulación completa: ¡PQRS enviada de forma visual! 📝'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Radicar PQRS', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RefundFormScreen extends StatelessWidget {
  const RefundFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Solicitud de Reembolso', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Solicitud de Devolución Económica 💰', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Por favor ingresa los datos de la orden para revisar la inconsistencia comercial.', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 24),

            TextFormField(
              decoration: InputDecoration(labelText: 'Código del Pedido afectado (Ej: #RM-9874)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Valor estimado a reclamar (\$)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),


            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(labelText: 'Causa del Reembolso', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              items: const [
                DropdownMenuItem(value: 'daño', child: Text('La planta o insumo llegó maltratado', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'incompleto', child: Text('Faltaron unidades en la entrega', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'cobro', child: Text('Error o duplicidad en la pasarela de pago', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'cancelado', child: Text('Cancelación oportuna del pedido', overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),

            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Información adicional (Entidad bancaria o comentarios)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Simulación completa: ¡Solicitud radicada visualmente! 💰'),
                      backgroundColor: Colors.amber,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Enviar Solicitud', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}