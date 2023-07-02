// import 'dart:html';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voiceass/openai_service.dart';
import 'package:voiceass/pallete.dart';
import 'feature_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text("Voice Assistance")),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ZoomIn(
              child: Stack(
                // alignment: Alignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      // child: CircleAvatar(),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        // borderRadius:BorderRadiusDirectional.circular(60)
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/virtualAssistant.png"))),
                  ),
                ],
              ),
            ),
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
                      border: Border.all(
                        color: Pallete.borderColor,
                      )),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text(
                      generatedContent == null
                          ? generatedImageUrl == null
                              ? "Hey!! How can I help you?"
                              : generatedImageUrl!
                          : generatedContent!,
                      style:const TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: 25,
                          fontFamily: 'Cera Pro'),
                    ),
                  ),
                ),
              ),
            ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Here are a few commands.",
                    style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            if(generatedImageUrl != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(generatedImageUrl!)),
            ),
            Visibility(
            visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay :const Duration(seconds: 1),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headertext: "ChatGPT",
                      descriptiontext:
                          'A smarter way to stay organized and informed with chatgpt',
                    ),
                  ),
                  SlideInLeft(
                    delay: const Duration(seconds: 2),
                    child: const FeatureBox(
                        color: Pallete.secondSuggestionBoxColor,
                        headertext: 'Dall-E',
                        descriptiontext:
                            'Get inspired and stay creative with your personal assistant powered by Dall-E'),
                  ),
                  SlideInLeft(
                    delay: const Duration(seconds: 3),
                    child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headertext: "Smart Voice Assistant",
                      descriptiontext:
                          'Get the best of both worlds with a voice assistant powered by ChatGPT and Dall-E',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission && speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              print(lastWords);
              final speech = await openAIService.isArtPromptAPI(lastWords);
              print(speech);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          backgroundColor: Pallete.firstSuggestionBoxColor,
          child: Icon(speechToText.isListening?Icons.stop:Icons.mic,
          ),
        ),
      ),
    );
  }
}
