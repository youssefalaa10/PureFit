import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/DI/dependency.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/AiChat/Logic/Cubit/aichat_cubit.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
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
      ChatUser(id: '0', firstName: 'Mohamed', lastName: 'Amin');
  ChatUser botUser = ChatUser(id: '1', firstName: 'Coach');

  List<ChatMessage> messages = [];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: theme.scaffoldBackgroundColor,
        title: Text.rich(TextSpan(children: [
          TextSpan(
              text: 'Ai',
              style: TextStyle(
                fontFamily: AppString.font,
                fontWeight: FontWeight.w700,
              )),
          TextSpan(
              text: ' Coach',
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
              showDialog<void>(
                  barrierDismissible: false,
                  barrierColor: Colors.transparent,
                  context: context,
                  builder: (_) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: ColorManager.primaryColor,
                          backgroundColor: ColorManager.backGroundColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'AI Coach is thinking...',
                          style: TextStyle(
                            fontFamily: AppString.font,
                            color: theme.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
              // Dismiss loading dialog first
              Navigator.pop(context);

              // Show error message with retry option
              showDialog<void>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text(
                      'AI Coach Error',
                      style: TextStyle(fontFamily: AppString.font),
                    ),
                    content: Text(
                      state.message,
                      style: TextStyle(fontFamily: AppString.font),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontFamily: AppString.font,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            final mq = CustomMQ(context);
            final theme = Theme.of(context);
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
                  inputOptions: InputOptions(
                    inputTextStyle: TextStyle(color: theme.primaryColor),
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
