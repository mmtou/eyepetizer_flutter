import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import '../components/moment.dart';
import '../utils/common.dart';
import '../utils/http.dart';

class Video extends StatefulWidget {
  final detail;

  Video(this.detail);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  IjkMediaController controller = IjkMediaController();

  List otherList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.detail['cover']['feed'],
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Color(0xFF333333).withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getPlayerWidget(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        widget.detail['title'] != null &&
                                widget.detail['title'].isNotEmpty
                            ? Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: Text(
                                  widget.detail['title'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
                        (widget.detail['author'] != null ||
                                widget.detail['owner'] != null)
                            ? Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: Text(
                                  '#${widget.detail['category'] ?? ""} / ${widget.detail['author'] != null ? widget.detail['author']['name'] : widget.detail['owner']['nickname']}',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8)),
                                ),
                              )
                            : Container(),
                        widget.detail['description'] != null
                            ? Container(
                                constraints: BoxConstraints(maxHeight: 150),
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.detail['description'],
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                ),
                              )
                            : Container(),
                        widget.detail['consumption'] != null &&
                                widget.detail['consumption'].length > 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FlatButton.icon(
                                    onPressed: () {
                                      BotToast.showText(
                                          text: '敬请期待~',
                                          align: Alignment(0, 0));
                                    },
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: Text(
                                      '${widget.detail['consumption']['collectionCount']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  FlatButton.icon(
                                    onPressed: () {
                                      Common.share(widget.detail['playUrl']);
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: Text(
                                      '${widget.detail['consumption']['shareCount']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  FlatButton.icon(
                                    onPressed: () {
                                      Common.openUrl(widget.detail['playUrl']);
                                    },
                                    icon: Icon(
                                      Icons.file_download,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: Text(
                                      '下载',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  FlatButton.icon(
                                    onPressed: () {
                                      BotToast.showText(
                                          text: '敬请期待~',
                                          align: Alignment(0, 0));
                                    },
                                    icon: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: Text(
                                      '${widget.detail['consumption']['realCollectionCount']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        Expanded(
                          child: Moment(otherList, isDetail: true),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool showVideoPoster;

  Widget getPlayerWidget() {
    List playInfos = widget.detail['playInfo'];
    double videoHeight = 256;
    if (playInfos != null && playInfos.length > 0) {
      var playInfo = playInfos[0];
      int sourceWidth = playInfo['width'];
      int sourceHeight = playInfo['height'];
      double videoWidth = MediaQuery.of(context).size.width;
      videoHeight = videoWidth * sourceHeight / sourceWidth;
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      width: MediaQuery.of(context).size.width,
      height: videoHeight,
      child: showVideoPoster
          ? Stack(
              children: <Widget>[
                IjkPlayer(
                  mediaController: controller,
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InkWell(
                    onTap: playViode,
                    child: CachedNetworkImage(
                      imageUrl: widget.detail['cover']['feed'],
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.play_circle_filled),
                      iconSize: 60,
                      color: Colors.white,
                      onPressed: playViode,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      color: Colors.black,
                      padding: EdgeInsets.all(3),
                      child: Text(
                        Common.secondToDate(widget.detail['duration']),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : IjkPlayer(
              mediaController: controller,
            ),
    );
  }

  playViode() {
    controller.play();
    setState(() {
      this.showVideoPoster = false;
    });
  }

  init() async {
    // 获取网络类型
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      controller.setNetworkDataSource(widget.detail['playUrl'], autoPlay: true);
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          this.showVideoPoster = false;
        });
      });
    } else {
      controller.setNetworkDataSource(widget.detail['playUrl'],
          autoPlay: false);
    }
    // 查询相关推荐/评论等
    List relatedList = await this.getRelated();
    List replies = await this.getReplies();
    relatedList = relatedList.map((item) {
      if (item['type'] == 'simpleHotReplyScrollCard') {
        List itemList = item['data']['itemList'];
        for (var related in itemList) {
          for (var reply in replies) {
            if (reply['type'] == 'reply') {
              var user = reply['data']['user'];
              if (user['nickname'] == related['data']['nickname']) {
                related['data']['avatar'] = user['avatar'];
                break;
              }
            }
          }
        }
      }
      return item;
    }).toList();

    relatedList.addAll(replies);
    setState(() {
      this.otherList = relatedList;
    });
  }

  Future<List> getRelated() async {
    var data = await Http()
        .get(Common.getUrl('/api/v4/video/related?id=${widget.detail['id']}'));
    return data['itemList'];
  }

  getReplies() async {
    var data = await Http().get(
        Common.getUrl('/api/v2/replies/video?videoId=${widget.detail['id']}'));
    return data['itemList'];
  }

  @override
  void initState() {
    super.initState();
    this.showVideoPoster = true;
    this.init();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
