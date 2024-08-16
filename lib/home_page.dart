import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //gemini chat instance
  final Gemini gemini = Gemini.instance;

  //message list store data of messsge
  List<ChatMessage> messages = [];

  //dash chat users
  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "User",
  );
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Zippy AI",
      profileImage: "assets/images/profile.png");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/home.png'),
          ),
        ),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        // Centered text when the messages list is empty
        if (messages.isEmpty)
          Center(
            child: Text(
              "Ask Gemini anything...",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),

        // DashChat UI
        DashChat(
          inputOptions: InputOptions(
            // trailing: [
            //   Padding(
            //     padding: const EdgeInsets.only(left: 4),
            //     child: IconButton(
            //       padding: EdgeInsets.zero,
            //       onPressed: _sendMediaMessage,
            //       icon: Container(
            //         alignment: Alignment.center,
            //         height: 55,
            //         width: 50,
            //         decoration: const BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(12)),
            //           color: Color.fromARGB(59, 255, 255, 255),
            //         ),
            //         child: Image.asset(
            //           'assets/images/paperclip (1).png',
            //           color: Colors.white,
            //           scale: 20,
            //         ),
            //       ),
            //     ),
            //   )
            // ],
            leading: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: _sendMediaMessage,
                  icon: Container(
                    alignment: Alignment.center,
                    height: 55,
                    width: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Color.fromARGB(59, 255, 255, 255),
                    ),
                    child: Image.asset(
                      'assets/images/paperclip (1).png',
                      color: Colors.white,
                      scale: 20,
                    ),
                  ),
                ),
              )
            ],
            inputDecoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(59, 255, 255, 255),
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                borderSide: BorderSide.none,
              ),
              hintText: " Ask a question",
              hintStyle: TextStyle(
                color: Color.fromARGB(145, 255, 255, 255),
              ),
            ),
            inputTextStyle: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
            sendButtonBuilder: (VoidCallback sendMessage) {
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Container(
                  alignment: Alignment.center,
                  height: 55,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(59, 255, 255, 255),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: sendMessage,
                    icon: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/images/Vector.png',
                        scale: 1.8,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          messageOptions: MessageOptions(
            borderRadius: 22,
            containerColor: const Color.fromARGB(95, 0, 94, 60),
            messagePadding: const EdgeInsets.all(12),
            textColor: Colors.white,
            currentUserContainerColor: const Color.fromARGB(36, 255, 255, 255),
            messageTextBuilder: (message, previousMessage, nextMessage) {
              return Text(
                message.text ?? '',
                style: const TextStyle(fontSize: 15, color: Colors.white),
              );
            },
          ),
          currentUser: currentUser,
          onSend: _sendMessage,
          messages: messages,
        ),
      ],
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? image;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        image = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      gemini
          .streamGenerateContent(
        question,
        images: image,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);

          String respones = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";

          lastMessage.text += respones;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String respones = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: respones,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      // Prompt user for input when sending an image
      String? userInput = await _askForInput();

      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: userInput ?? "",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image)
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  // Function to prompt the user for input
  Future<String?> _askForInput() async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          backgroundColor: const Color.fromARGB(231, 0, 94, 60),
          title: Text(
            'Send a message with the image',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          content: TextField(
            cursorColor: Colors.white,
            controller: controller,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(59, 255, 255, 255),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                borderSide: BorderSide.none,
              ),
              hintText: " Ask about Image",
              hintStyle: TextStyle(
                color: Color.fromARGB(145, 255, 255, 255),
              ),
            ),
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(
                'Send',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
