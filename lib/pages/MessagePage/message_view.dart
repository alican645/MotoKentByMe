import 'package:flutter/material.dart';
import 'package:moto_kent/components/custom_textfield.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  ScrollController? _scrollController;
  TextEditingController _textEditingController=TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController=ScrollController();
    // Sayfa açıldığında listeyi en sona kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController!.hasClients) {
      _scrollController!.jumpTo(_scrollController!.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 5,
            itemBuilder: (context, index) => Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.sizeOf(context).width / 1.5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Lorem ipsum odor amet, consectetuer adipiscing elit. Sociosqu mattis viverra morbi nascetur pretium metus. Cras mi nisi penatibus placerat habitasse habitasse viverra sed est. Potenti ipsum hendrerit dolor amet venenatis dolor malesuada convallis? Dolor ad nascetur euismod tellus dui sagittis tempor nullam aliquet. Etiam maecenas libero lobortis porttitor nunc feugiat diam neque? Potenti habitasse mollis erat congue eget."),
              ),
            ),
          ),),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(child: CustomTextField(controller: _textEditingController, labelText: "Mesajınızı giriniz")),
              IconButton(onPressed: () {
              }, icon: Icon(Icons.send))
            ],
          ),
        )

      ],
    );
  }
}
