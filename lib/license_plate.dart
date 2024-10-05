import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // For text recognition
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; // Import HTTP package
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabic Text Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TextRecognitionScreen(),
    );
  }
}

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({super.key});

  @override
  State<TextRecognitionScreen> createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  File? _image;
  String _recognizedText = 'No text recognized yet';
  bool _isProcessing = false;

  // Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        _image = File(image.path);
        _isProcessing = true; // Set the state to processing
      });

      // Perform text recognition
      await _recognizeText(_image!);
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
    }
  }

  // Load image from network URL
  Future<void> _loadNetworkImage(String url) async {
    try {
      // Fetch image from network
      final response = await http.get(Uri.parse(url));

      // Check if the request is successful
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/network_image.jpg');

        // Write the image bytes to a file
        await tempFile.writeAsBytes(response.bodyBytes);

        setState(() {
          _image = tempFile;
          _isProcessing = true; // Start processing
        });

        // Perform text recognition
        await _recognizeText(_image!);
      } else {
        if (kDebugMode) {
          print('Failed to load network image: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading network image: $e');
      }
    }
  }

  // Perform text recognition using Google ML Kit
  Future<void> _recognizeText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        _recognizedText = recognizedText.text.isNotEmpty
            ? recognizedText.text
            : 'No text recognized in the image';
        _isProcessing = false; // Stop processing
      });
    } catch (e) {
      setState(() {
        _recognizedText = 'Error recognizing text: $e';
        _isProcessing = false; // Stop processing
      });
      if (kDebugMode) {
        print('Error during text recognition: $e');
      }
    } finally {
      textRecognizer.close();
    }
  }

  // Sample network image URL with Arabic text
  final String _arabicImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/d/d1/Egypt_-_License_Plate_-_Private_Giza.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabic Text Recognition'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[300],
                child: Center(
                  child: _image == null
                      ? const Icon(
                    Icons.add_a_photo,
                    size: 60,
                  )
                      : Image.file(_image!),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Pick Image from Gallery'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Take a Photo'),
              ),
              ElevatedButton(
                onPressed: () => _loadNetworkImage(_arabicImageUrl),
                child: const Text('Load Network Arabic Image'),
              ),
              const SizedBox(height: 20),
              _isProcessing
                  ? const CircularProgressIndicator() // Show loading spinner while processing
                  : Text(
                _recognizedText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
