import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Para la cámara
import 'package:file_picker/file_picker.dart';   // Para los archivos
// Para manejar el objeto File

class InterfazIA extends StatefulWidget {
  const InterfazIA({super.key});

  @override
  State<InterfazIA> createState() => _InterfazIAState();
}

class _InterfazIAState extends State<InterfazIA> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  // Lista para almacenar los nombres de los archivos seleccionados
  final List<String> _selectedFilesNames = [];

  // Colores del diseño
  final Color primaryGreen = const Color(0xFF6BCE7A);
  final Color secondaryTeal = const Color(0xFF00A99D);
  final Color darkText = const Color(0xFF334A5F);
  final Color lightGray = const Color(0xFFF5F7F9);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // FUNCIÓN PARA ABRIR LA CÁMARA
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Opcional: comprime un poco la imagen
      );
      
      if (photo != null) {
        setState(() {
          _selectedFilesNames.add("Foto: ${photo.name}");
        });
      }
    } catch (e) {
      debugPrint("Error al abrir la cámara: $e");
    }
  }

  // FUNCIÓN PARA SUBIR ARCHIVOS (PDF, DOCX, IMÁGENES, ETC.)
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, // Permite elegir varios a la vez
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          _selectedFilesNames.addAll(result.names.whereType<String>());
        });
      }
    } catch (e) {
      debugPrint("Error al seleccionar archivos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "AI Assistant",
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Fondo_SkillSwap.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        // Avatar Circular del Chatbot
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // ignore: deprecated_member_use
                            color: primaryGreen.withOpacity(0.2),
                            border: Border.all(color: primaryGreen, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/Chatbot SkillSwap re.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Hola Master, ¿cómo puedo ayudarte hoy?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkText),
                        ),
                        const SizedBox(height: 20),

                        // Acciones rápidas actualizadas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildQuickAction(Icons.camera_alt, "Tomar\nFoto", _takePhoto),
                            _buildQuickAction(Icons.folder, "Subir\nArchivo", _pickFiles),
                            _buildQuickAction(Icons.auto_awesome, "Generar\nImagen", () {}),
                          ],
                        ),
                        const SizedBox(height: 25),
                        _buildChatBubble(message: "Explícame la fotosíntesis", isUser: true),
                        _buildChatBubble(
                          message: "La fotosíntesis es el proceso que usan las plantas para crear energía a partir de la luz solar.",
                          isUser: false,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: primaryGreen.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble({required String message, required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(0),
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(20),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: isUser ? Colors.white : darkText, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]
      ),
      child: Column(
        children: [
          if (_selectedFilesNames.isNotEmpty)
            Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedFilesNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: lightGray, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file, size: 14, color: Colors.blueGrey),
                        const SizedBox(width: 5),
                        Text(_selectedFilesNames[index], style: const TextStyle(fontSize: 11)),
                        GestureDetector(
                          onTap: () => setState(() => _selectedFilesNames.removeAt(index)),
                          child: const Icon(Icons.close, size: 14, color: Colors.red),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: secondaryTeal), 
                onPressed: _pickFiles,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: lightGray, borderRadius: BorderRadius.circular(25)),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: darkText),
                    decoration: const InputDecoration(hintText: "Escribe un mensaje...", border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: secondaryTeal,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      _selectedFilesNames.clear();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}