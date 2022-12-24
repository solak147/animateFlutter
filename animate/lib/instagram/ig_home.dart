import 'package:flutter/material.dart';

class IgHome extends StatelessWidget {

  IgHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double width = queryData.size.width;
    double heigt = queryData.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => print('按下選單'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.photo_camera_outlined,
              color: Colors.white,
            ),
            onPressed: () => print('按下狗掌'),
          ),
        ],
      ),
      body: GestureDetector(
        // 指定 pop 的第二個參數值
        onTap: () => Navigator.pop(context, '結果值'),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.black87,
              child:  ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(3), // Border radius
                          child: ClipOval(child:Image.asset(
                            'assets/no.jpg',
                            fit: BoxFit.fill,
                          )),
                        ),
                      ),
                      Text(
                        'text1',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Container(
                    width: 160.0,
                    color: Colors.blue,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.orange,
                  ),
                ],
              ),
              constraints: BoxConstraints(maxWidth: width, maxHeight: 140, minWidth: 50, minHeight: 50),
            ),
          ]
        ),

      ),
    );

  }


}

