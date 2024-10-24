import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/DI/dependency.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:fitpro/Features/AiChat/Logic/Cubit/aichat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrainerChat extends StatefulWidget {
  const TrainerChat({super.key});

  @override
  State<TrainerChat> createState() => _TrainerChatState();
}

class _TrainerChatState extends State<TrainerChat> {
  final TextEditingController _controller = TextEditingController();

  ChatUser currentUser =
      ChatUser(id: "0", firstName: "Mohamed", lastName: "Amin");
  ChatUser botUser = ChatUser(id: "1", firstName: "Coach");

  List<ChatMessage> messages = [];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: theme.scaffoldBackgroundColor,
        title:  Text.rich(TextSpan(children: [
          TextSpan(
              text: "Ai",
              style: TextStyle(
                fontFamily: AppString.font,
                fontWeight: FontWeight.w700,
              )),
          TextSpan(
              text: " Coach",
              style: TextStyle(
                  fontFamily: AppString.font, fontWeight: FontWeight.w400))
        ])),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: BlocProvider(
        create: (context) => getIT<AichatCubit>(),
        child: BlocConsumer<AichatCubit, AichatState>(
          listener: (context, state) {
            if (state is AichatLoading) {
              showDialog(
                  barrierDismissible: false,
                  barrierColor: Colors.transparent,
                  context: context,
                  builder: (_) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: ColorManager.primaryColor,
                      backgroundColor: ColorManager.backGroundColor,
                    ));
                  });
            }
            if (state is AichatLoaded) {
              // Add bot's response message
              Navigator.pop(context);
              setState(() {
                messages = [
                  ChatMessage(
                    user: botUser,
                    createdAt: DateTime.now(),
                    text: state.message,
                  ),
                  ...messages,
                ];
              });
            } else if (state is AichatError) {
              // Handle error, show a message or dialog
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }
          },
          builder: (context, state) {
            final mq = CustomMQ(context);
            return Stack(
              children: [
                // Display background image if there are no messages
                if (messages.isEmpty)
                  Center(
                    child: Image.asset(
                      height: mq.height(100),
                      width: mq.width(100),
                      'assets/images/bot.png', // Replace with your image path
                    ),
                  ),
                DashChat(
                  currentUser: currentUser,
                  onSend: (ChatMessage message) {
                    handleSendMessage(context, message);
                  },
                  messageOptions: MessageOptions(
                    currentUserContainerColor: ColorManager.primaryColor,
                  ),
                  messageListOptions:
                      const MessageListOptions(showDateSeparator: true),
                  inputOptions: InputOptions(
                    inputTextStyle: TextStyle(color: ColorManager.primaryColor),
                    inputToolbarStyle: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          color: ColorManager.lightGreyColor,
                          blurRadius: 2.0,
                          spreadRadius: 2.0,
                        )
                      ],
                    ),
                    cursorStyle: CursorStyle(color: ColorManager.primaryColor),
                    sendOnEnter: true,
                    textController: _controller,
                  ),
                  messages: messages,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Handle sending the user's message and trigger the Cubit
  void handleSendMessage(BuildContext context, ChatMessage message) {
    setState(() {
      messages = [
        message,
        ...messages,
      ];
    });

    // Call the Cubit to handle chatting
    context.read<AichatCubit>().doChatting(message.text);
  }
}
