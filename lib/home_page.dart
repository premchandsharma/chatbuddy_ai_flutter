import 'package:chatbuddy_ai_flutter/feature_box.dart';
import 'package:chatbuddy_ai_flutter/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text(
          'ChatBuddy AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Chatbuddy top media
            Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    height: 120,
                    width: 120,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  height: 123,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/virtualAssistant.png'),
                    ),
                  ),
                )
              ],
            ),
            // Hello chat message
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius:
                    BorderRadius.circular(24).copyWith(topLeft: Radius.zero),
              ),
              child: const Text(
                'Hello, What can I do for you?',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(
                top: 10,
                left: 22,
              ),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Here are a few commands',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Column(
              children: [
                FeatureBox(
                  color: Colors.green,
                  headerText: 'ChatGPT',
                  descriptionText:
                      'A smarter way to stay organised and informed with ChatGPT',
                ),
                FeatureBox(
                  color: Colors.lightGreen,
                  headerText: 'Dall-E',
                  descriptionText:
                      'Get inspired and stay creative with your personal assistant powered with AI',
                ),
                FeatureBox(
                  color: Colors.green,
                  headerText: 'Smart Voice Assistant',
                  descriptionText:
                      'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Text(lastWords),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            await openAIService.isArtPromptAPI(lastWords);
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(
          Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
