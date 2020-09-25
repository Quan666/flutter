import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';
    return new MaterialApp(
      title: title,
      home: new MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WebSocketChannel channel =
      new IOWebSocketChannel.connect('ws://echo.websocket.org');
  TextEditingController _controller = new TextEditingController();
  List<Widget> msgListView = <Widget>[];

  ItemScrollController _scrollController = ItemScrollController();

  var keyBoradHeight = 0.0;
  var msgBoxHeight = 600.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      msgListView.add(MessageBox(Message('快开始聊天吧！', notMe: true)));
    });

    // 监听消息
    channel.stream.listen((message) {
      setState(() {
        print('收到信息');
        msgListView.add(MessageBox(Message(message, notMe: true)));
        //移动listview，让其置底
        _scrollController.scrollTo(
            index: msgListView.length, duration: Duration(seconds: 1));
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        setState(() {
          keyBoradHeight = MediaQuery.of(context).viewInsets.bottom;
        });
      } else {
        setState(() {
          keyBoradHeight = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: ListView(children: [
        new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Container(
                    height: msgBoxHeight - keyBoradHeight,
                    //该组件让listview滑到最底下的元素，实现最新消息在底下
                    child: new ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      itemCount: msgListView.length,
                      itemBuilder: (context, index) {
                        return msgListView[index];
                      },
                    )
                    // NotificationListener(
                    //   onNotification: (notification) {
                    //     switch (notification.runtimeType) {
                    //       case ScrollStartNotification:
                    //         print("开始滚动");
                    //         break;
                    //       case ScrollUpdateNotification:
                    //         print("正在滚动");
                    //         break;
                    //       case ScrollEndNotification:
                    //         print("滚动停止");
                    //         break;
                    //       case OverscrollNotification:
                    //         print("滚动到边界");
                    //         break;
                    //     }
                    //   },
                    //   child: new ListView(
                    //     children: widget.msgListView,
                    //   ),
                    // ),
                    ),
              ),
              new Form(
                child: new TextFormField(
                  controller: _controller,
                  decoration: new InputDecoration(labelText: 'Send a message'),
                  onTap: () {
                    setState(() {
                      //MediaQuery.of(context).viewInsets.bottom;
                    });
                    print('高度：' +
                        MediaQuery.of(context).viewInsets.bottom.toString());
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
      floatingActionButton: new FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: new Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
      setState(() {
        print('send');
        _scrollController.scrollTo(
          //移动listview，让其置底
            index: msgListView.length, duration: Duration(seconds: 1));
        msgListView.add(MessageBox(Message(_controller.text, notMe: false)));
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }
}

class MessageBox extends StatefulWidget {
  Message message;
  MessageBox(this.message, {Key key}) : super(key: key);

  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          //这里判断是否展示时间
          true
              ? Container(
                  child: Text('时间', style: TextStyle(color: Color(0xffffffff))),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Color(0xffdadada),
                  ),
                )
              : null,
          Row(
            textDirection:
                widget.message.notMe ? TextDirection.ltr : TextDirection.rtl,
            children: <Widget>[
              //头像
              Container(
                  margin: EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: ExtendedImage.network(
                        'https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png',
                        //加载头像图片
                        //image: CachedNetworkImage(showOnLeft ? userModel.findFriendInfo(info.owner).avatar : image),
                        //image: Image.network(''),
                        height: 30,
                        width: 30,
                        fit: BoxFit.fill),
                  )),
              //消息框
              Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(maxWidth: 240),
                decoration: BoxDecoration(
                    color: widget.message.notMe
                        ? Color(0xffffffff)
                        : Color(0xff98e165),
                    borderRadius: BorderRadius.circular(3.0)),
                child: Text(widget.message.msg),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Message {
  bool notMe = true;
  String msg = "";
  Message(this.msg, {this.notMe}) {}
}
