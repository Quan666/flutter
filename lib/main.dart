import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animations/animations.dart';

void main() {
  //安卓沉浸式效果
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  //强制竖屏显示,打包apk时需要放开注释
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //只能纵向
    DeviceOrientation.portraitDown, //只能纵向
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '留言墙'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const double _img_circular = 8.0; //图片圆角
  static const double _myElevation = 0.0; //卡片阴影
  static const int LIKE_YES = 1;
  static const int LIKE_NO = 0;
  //渐变色
  var myGradientColor = BoxDecoration(
    gradient: LinearGradient(colors: [
      Color(0xff0ec5c9),
      Color(0xff54eb9e),
    ], begin: Alignment.bottomLeft, end: Alignment.topRight),
  );

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  var list = [
    {
      "messageid": "1",
      "img":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "imghead":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "username": "用户名1",
      "userid": "1",
      "messageinfo":
          "这里是留言的具体内容，它最多两行，超出会省略,这里是留言的具体内容，它最多两行，超出会省略,这里是留言的具体内容，它最多两行，超出会省略",
      "comment": "961",
      "like": "56",
      "like_yes": "0"
    },
    {
      "messageid": "2",
      "img":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "imghead":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "username": "用户名2",
      "userid": "2",
      "messageinfo": "这里是留言的具体内容，它最多两行，超出会省略",
      "comment": "96",
      "like": "56",
      "like_yes": "1"
    },
    {
      "messageid": "3",
      "img":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "imghead":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "username": "用户名3",
      "userid": "3",
      "messageinfo": "这里是留言的具体内容，它最多两行，超出会省略",
      "comment": "96",
      "like": "56",
      "like_yes": "0"
    },
    {
      "messageid": "4",
      "img":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "imghead":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "username": "用户名4",
      "userid": "4",
      "messageinfo": "这里是留言的具体内容，它最多两行，超出会省略",
      "comment": "96",
      "like": "56123",
      "like_yes": "1"
    },
    {
      "messageid": "5",
      "img":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "imghead":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "username": "用户名5",
      "userid": "5",
      "messageinfo": "这里是留言的具体内容，它最多两行，超出会省略",
      "comment": "96",
      "like": "56123",
      "like_yes": "1"
    },
    {
      "messageid": "6",
      "img":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "imghead":
          "https://cdn.jsdelivr.net/gh/Quan666/CDN@master/pic/78075652_p0.png",
      "username": "用户名6",
      "userid": "6",
      "messageinfo": "这里是留言的具体内容，它最多两行，超出会省略",
      "comment": "96",
      "like": "56123",
      "like_yes": "1"
    },
  ];

  Widget _getCard(index) {
    //关键代码
    var card = new SizedBox(
      //height: 4000.0, //设置高度
      child: new Card(
        elevation: _myElevation, //设置阴影
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(_img_circular))), //设置圆角
        child: new Column(
          // card只能有一个widget，但这个widget内容可以包含其他的widget
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: index == 0 ? 14 : 9,
                child: InkWell(
                  onTap: () {
                    print('进入留言 $index 详情页');
                  },
                  child: new ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(_img_circular),
                        topRight: Radius.circular(_img_circular),
                      ),
                      child: ExtendedImage.network(
                        list[index]['img'],
                        fit: BoxFit.cover,
                        height: 500,
                        width: 500,
                        cache: true,
                        //border: Border.all(color: Colors.red, width: 1.0),
                        borderRadius:
                            BorderRadius.all(Radius.circular(_img_circular)),
                        //cancelToken: cancellationToken,
                      )),
                )),
            Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    print("点击了用户:" + list[index]['username']);
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: new ClipOval(
                          child: ExtendedImage.network(
                            list[index]['imghead'],
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover,
                            cache: true,
                            borderRadius:
                                BorderRadius.all(Radius.circular(300.0)),
                            //cancelToken: cancellationToken,
                          ),
                        ),
                      ),
                      new Text(list[index]['username'],
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black54)),
                    ],
                  ),
                )),
            Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    print('进入留言详情页');
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 5, 5),
                    child: new Text(list[index]['messageinfo'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 12,
                        )),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                              child: ImageIcon(
                                AssetImage('assets/comments.png'),
                                color: Colors.black45,
                                size: 16,
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(2, 1, 5, 5),
                              child: Text(list[index]['comment'].toString(),
                                  style: new TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  )))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          new InkWell(
                              // When the user taps the button, show a snackbar
                              onTap: () async {
                                print("like$index");

                                setState(() {
                                  if (list[index]['like_yes'] ==
                                      LIKE_YES.toString()) {
                                    list[index]['like_yes'] =
                                        LIKE_NO.toString();
                                    list[index]['like'] =
                                        (int.parse(list[index]['like']) - 1)
                                            .toString();
                                    //之后调用服务器接口，不喜欢
                                  } else {
                                    list[index]['like_yes'] =
                                        LIKE_YES.toString();
                                    list[index]['like'] =
                                        (int.parse(list[index]['like']) + 1)
                                            .toString();
                                    //之后调用服务器接口，喜欢
                                  }
                                });
                              },
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(2, 0, 0, 5),
                                  child: ImageIcon(
                                    list[index]['like_yes'] ==
                                            LIKE_YES.toString()
                                        ? AssetImage('assets/like_yes.png')
                                        : AssetImage('assets/like.png'),
                                    //color: Color(0xdd0ec5c9),
                                    //color: Color(0xff54eb9e),
                                    //color: Colors.black45,
                                    color: list[index]['like_yes'] ==
                                            LIKE_YES.toString()
                                        ? Colors.red
                                        : Colors.black45,
                                    size: 16,
                                  ))),
                          Padding(
                              padding: EdgeInsets.fromLTRB(2, 1, 5, 5),
                              child: Text(
                                list[index]['like'].toString(),
                                style: new TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45,
                                  fontSize: 12,
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: card,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f3f8),
        appBar: AppBar(
          elevation: 1,
          title: Text(widget.title),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: myGradientColor,
          ),
        ),
        body: new StaggeredGridView.countBuilder(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          crossAxisCount: 4,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) => _getCard(index),
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index == 0 ? 4 : 3),
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
        floatingActionButton: ClipOval(
          child: Container(
            width: 50,
            height: 50,
            decoration: myGradientColor,
            child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Colors.transparent, // 设为透明色
                elevation: 0, // 正常时阴影隐藏
                highlightElevation: 0, // 点击时阴影隐藏
                onPressed: () async {
                  final result = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => _MyPage()));
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text('$result')));
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                )),
          ),
        ));
  }
}

class _MyPage extends StatelessWidget {
  const _MyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('测试页'),
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () => Navigator.of(context).pop('返回结果'),
            child: Text('点击返回'),
          ),
        ),
      ),
    );
  }
}
