import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(FriendlyChat());

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400]
);

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light
);

const String _name = 'Flavio Franco';

class FriendlyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friendly Chat',
      theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController = new TextEditingController();
  bool _isComposing = false;

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textEditingController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.trim().length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                    hintText: 'Send a message'
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                    child: Text('Send'),
                    onPressed: _isComposing ? () => _handleSubmitted(_textEditingController.text.trim()) : null
                  )
                  : IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _isComposing ? () => _handleSubmitted(_textEditingController.text.trim()) : null
                  ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();

    setState(() {
      _isComposing = false;
    });

    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 350)
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friendly Chat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (_, int index) {
                      return _messages[index];
                    }
                )
            ),
            Divider(height: 1.0,),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            )
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey[200]),
            )
          )
          : null,
      ),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {

  final String text;
  final AnimationController animationController;

  ChatMessage({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0]),),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: Theme.of(context).textTheme.subhead,),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}


