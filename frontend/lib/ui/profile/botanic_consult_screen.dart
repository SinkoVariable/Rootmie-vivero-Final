import 'package:flutter/material.dart';

class BotanicConsultScreen extends StatelessWidget {
  const BotanicConsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Asesoría Botánica 🌿', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agenda tu cita con un experto ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Completa los datos para la programación de una asesoria sobre el cuidado de tus plantas.',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 24),


            TextFormField(
              decoration: InputDecoration(
                labelText: '¿Qué planta o insumo deseas revisar?',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Principal síntoma o motivo',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: '1', child: Text('Hojas amarillas o secas', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: '2', child: Text('Presencia de plagas u hongos', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: '3', child: Text('Asesoría de trasplante/sustrato', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: '4', child: Text('Diseño de jardín/interiores', overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Horario de preferencia',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: 'M', child: Text('Mañana (8:00 AM - 12:00 PM)', overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 'T', child: Text('Tarde (2:00 PM - 6:00 PM)', overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),

            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Cuéntanos brevemente la historia de tu planta...',
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
                      content: Text('¡Asesoría solicitada! 🌿'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Agendar Asesoría ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}