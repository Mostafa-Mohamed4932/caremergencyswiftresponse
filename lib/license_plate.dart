import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

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
  final String _apiKey = 'K85860302188957'; // Your OCR Space API key
  final TextEditingController _urlController = TextEditingController();

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
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/network_image.jpg');

        await tempFile.writeAsBytes(response.bodyBytes);

        setState(() {
          _image = tempFile; // Update the image
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

  // Perform text recognition using OCR Space API
  Future<void> _recognizeText(File imageFile) async {
    try {
      final url = Uri.parse('https://api.ocr.space/parse/image');

      // Convert the image file to base64 string
      String base64Image = base64Encode(await imageFile.readAsBytes());

      // Make the API request
      var response = await http.post(
        url,
        headers: {
          'apikey': _apiKey,
        },
        body: {
          'base64Image': 'data:image/jpeg;base64,$base64Image',
          'language': 'ara', // Specify Arabic for text recognition
        },
      );

      // Handle the response
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['ParsedResults'] != null && jsonResponse['ParsedResults'].isNotEmpty) {
          var extractedText = jsonResponse['ParsedResults'][0]['ParsedText'];
          setState(() {
            _recognizedText = extractedText.isNotEmpty
                ? extractedText
                : 'No text recognized in the image';
            _isProcessing = false; // Stop processing
          });
        } else {
          setState(() {
            _recognizedText = 'No text recognized in the image';
            _isProcessing = false; // Stop processing
          });
        }
      } else {
        setState(() {
          _recognizedText = 'Error: ${response.reasonPhrase}';
          _isProcessing = false; // Stop processing
        });
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}. Response: ${response.body}');
        }
      }
    } catch (e) {
      setState(() {
        _recognizedText = 'Error recognizing text: $e';
        _isProcessing = false; // Stop processing
      });
      if (kDebugMode) {
        print('Error during text recognition: $e');
      }
    }
  }

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
                      : Image.file(_image!), // Display the selected image
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Enter Image URL',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Load image from the entered URL
                  _loadNetworkImage(_urlController.text);
                },
                child: const Text('Load Network Image'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Pick Image from Gallery'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: const Text('Take a Photo'),
              ),
              const SizedBox(height: 20),
              _isProcessing
                  ? const CircularProgressIndicator() // Show loading spinner while processing
                  : Text(
                _recognizedText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24), // Increased font size
              ),
            ],
          ),
        ),
      ),
    );
  }
}
