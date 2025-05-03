import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'credentials.dart';



void main() {
  Gemini.init(apiKey: API_KEY,enableDebugging: true);// Initialize Gemini with the API key and enable debugging
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _controller = TextEditingController();//Controller for the input field
  final List<Map<String,String>> _messages = [];//List to store the chat messages

  void _sendMessage() async{
    final inputText = _controller.text.trim();//Get And trim input text
    if(inputText.isEmpty) return;//This will do nothing if input is empty

    //this will add the user's message to the chat
    setState(() {
      _messages.add({'sender':'user','text':inputText});
    });
    _controller.clear();//Clean the input field

    final parts = [Part.text(inputText)];//This will Prepare the input for the Gemini API
    final response = await Gemini.instance.prompt(parts: parts);//Get the response from Gemini

      //Add the bot's response to the chat
    setState(() {
      _messages.add({
        'sender':'bot',
        'text':response?.output ?? 'No response generated',//Handle null responses
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hanis ChatBot"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context,index){
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      :Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 4,horizontal: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.blue[100]
                          :Colors.grey[300],
                      borderRadius:
                        BorderRadius.circular(8)
                    ),
                    child:
                    Text(message['text'] ?? ''),
                    ),
                  );
                ),

              }
            ))
          ],
        ),
      ),
    );
  }
}


