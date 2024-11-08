import "package:flutter/material.dart";
import "package:speech_to_text/speech_to_text.dart" as stt;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice to Text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceToText(),
    );
  }
}

class VoiceToText extends StatefulWidget {
  @override
  _VoiceToTextState createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Press the button to start speaking";
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Function to start or stop listening
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('onStatus: $status'),
        onError: (error) => print('onError: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center( child:  Text('Voice to Text by Gurshish', style: TextStyle(color: Colors.white),),),
        backgroundColor: Colors.teal,
        elevation: 10.0,

        
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _text,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }
}
