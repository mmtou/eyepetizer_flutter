import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../utils/common.dart';
import '../views/photo.dart';
import '../views/video.dart';

class Moment extends StatefulWidget {
  final List _moment;
  final bool isDetail;
  final refresh;
  final load;

  Moment(this._moment, {this.isDetail = false, this.refresh, this.load});

  @override
  _Moment createState() => _Moment();
}

class _Moment extends State<Moment> {
  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      child: getListView(),
      header:
          BezierCircleHeader(backgroundColor: Theme.of(context).primaryColor),
      footer:
          BezierBounceFooter(backgroundColor: Theme.of(context).primaryColor),
      onRefresh: () async {
        if (widget.refresh != null) {
          return await widget.refresh();
        } else {
          return true;
        }
      },
      onLoad: () async {
        if (widget.load != null) {
          return await widget.load();
        } else {
          return true;
        }
      },
    );
  }

  Widget getListView() {
    return ListView.builder(
        itemCount: widget._moment.length,
        itemBuilder: (BuildContext context, int index) {
          var item = widget._moment[index];
          var type = item['type'];
          if ('textCard' == type) {
            return ListTile(
              title: Text(
                item['data']['text'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.isDetail ? Colors.white : Colors.black,
                ),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: widget.isDetail ? Colors.white : Colors.black,
              ),
              onTap: () {},
            );
          } else if ('followCard' == type) {
            var data = item['data']['content']['data'];
            return InkWell(
              onTap: () => playVideo(data),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: data['cover']['feed'],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
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
                                  Common.secondToDate(data['duration']),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Row(
                        children: <Widget>[
                          data['author'] != null
                              ? CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                      data['author']['icon']),
                                )
                              : Container(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data['title'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  data['author'] != null
                                      ? Text(
                                          data['author']['name'],
                                          style: TextStyle(fontSize: 12),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Common.share(data['playUrl']);
                            },
                            icon: Icon(Icons.share),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if ('informationCard' == type) {
            var data = item['data'];
            List titleList = data['titleList'];
            List<Widget> widgets = [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: data['backgroundImage'],
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            ];
            widgets.addAll(titleList
                .map((itemTitle) => Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        itemTitle,
                        style: TextStyle(fontSize: 12),
                      ),
                    ))
                .toList());
            return InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgets,
                ),
              ),
            );
          } else if ('videoSmallCard' == type) {
            var data = item['data'];
            return InkWell(
              onTap: () => playVideo(data),
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
                height: 86,
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: data['cover']['feed'],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            width: 137,
                            height: 86,
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
                                  Common.secondToDate(data['duration']),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data['title'],
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                  color: widget.isDetail
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Text(
                              '#${data['category']}',
                              style: TextStyle(
                                color: widget.isDetail
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 18,
                      icon: Icon(
                        Icons.share,
                        color: widget.isDetail ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        Common.share(data['playUrl']);
                      },
                    )
                  ],
                ),
              ),
            );
          } else if ('banner2' == type || 'banner' == type) {
            return InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: item['data']['image'],
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            );
          } else if ('autoPlayFollowCard' == type) {
            var data = item['data']['content']['data'];
            return InkWell(
                onTap: () => playVideo(data),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: data['cover']['feed'],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            width: double.infinity,
                          ),
                          const Positioned(
                            child: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                            ),
                            top: 6,
                            right: 6,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Text(data['description']),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: CachedNetworkImageProvider(
                                    data['owner']['avatar']),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(data['owner']['nickname']),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: Text(
                                    '${data['consumption']['collectionCount']}'),
                              ),
                              Icon(
                                Icons.favorite_border,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          } else if ('ugcSelectedCardCollection' == type) {
            var data = item['data'];
            List itemList = data['itemList'];
            var width = (MediaQuery.of(context).size.width - 32 - 4) / 2;
            return Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(data['header']['title']),
                  ),
                  Container(
                    height: width,
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: CachedNetworkImage(
                            imageUrl: itemList[0]['data']['cover']['feed'],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            width: width,
                            height: width,
                            fit: BoxFit.cover,
                          ),
                          onTap: () {
                            var itemData = itemList[0]['data'];
                            if (itemData['dataType'] == 'SimpleUgcVideoBean') {
                              playVideo(itemData);
                            } else {
                              previewPhoto(itemData['urls']);
                            }
                          },
                        ),
                        Container(
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                child: CachedNetworkImage(
                                  imageUrl: itemList[1]['data']['cover']
                                      ['feed'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  width: width,
                                  height: (width - 4) / 2,
                                  fit: BoxFit.cover,
                                ),
                                onTap: () {
                                  var itemData = itemList[1]['data'];
                                  if (itemData['dataType'] ==
                                      'SimpleUgcVideoBean') {
                                    playVideo(itemData);
                                  } else {
                                    previewPhoto(itemData['urls']);
                                  }
                                },
                              ),
                              InkWell(
                                child: CachedNetworkImage(
                                  imageUrl: itemList[2]['data']['cover']
                                      ['feed'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  width: width,
                                  height: (width - 4) / 2,
                                  fit: BoxFit.cover,
                                ),
                                onTap: () {
                                  var itemData = itemList[2]['data'];
                                  if (itemData['dataType'] ==
                                      'SimpleUgcVideoBean') {
                                    playVideo(itemData);
                                  } else {
                                    previewPhoto(itemData['urls']);
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if ('reply' == type) {
            var data = item['data'];
            return InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            CachedNetworkImageProvider(data['user']['avatar']),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data['user']['nickname'],
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9)),
                              ),
                              Text(
                                data['message'],
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 10,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          } else if ('briefCard' == type) {
            var data = item['data'];
            return InkWell(
              onTap: () {},
              child: Container(
                height: 48,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: data['icon'],
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(data['title']),
                            Text(data['description'])
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 72,
                      child: OutlineButton.icon(
                        onPressed: () {
                          BotToast.showText(
                              text: '敬请期待~', align: Alignment(0, 0));
                        },
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.3)),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 12,
                        ),
                        label: const Text(
                          '关注',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if ('columnCardList' == type) {
            var data = item['data'];
            List itemList = data['itemList'];
            double width = (MediaQuery.of(context).size.width - 32 - 6) / 2;
            return InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      data['header']['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: widget.isDetail ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: itemList.map((itemCard) {
                        var itemData = itemCard['data'];
                        return Container(
                          width: width,
                          height: 96,
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl: itemData['image'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  width: width,
                                  height: 96,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Center(
                                    child: Text(
                                      itemData['title'],
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            );
          } else if ('specialSquareCardCollection' == type) {
            var data = item['data'];
            List itemList = data['itemList'];
            double itemWidth =
                (MediaQuery.of(context).size.width - 32 - 12) / 3;
            return InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      data['header']['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: widget.isDetail ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                    height: itemWidth * 2 + 16 + 6,
                    width: double.infinity,
                    child: GridView(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      ),
                      children: itemList.map((itemCard) {
                        var itemData = itemCard['data'];
                        return Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: itemData['image'],
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                width: itemWidth,
                                height: itemWidth,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Center(
                                  child: Text(
                                    itemData['title'],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            );
          } else if ('horizontalScrollCard' == type) {
            var data = item['data'];
            List itemList = data['itemList'];
            return Container(
              width: double.infinity,
              height: 200,
              child: LiquidSwipe(
                pages: itemList.map((itemCard) {
                  var itemData = itemCard['data'];
                  return Container(
                    width: double.infinity,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: itemData['image'],
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          } else if ('simpleHotReplyScrollCard' == type) {
            List itemList = item['data']['itemList'];
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white70.withOpacity(0.3),
                  ),
                ),
              ),
              child: Column(
                children: itemList.map((card) {
                  var data = card['data'];
                  return Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            CachedNetworkImageProvider(data['avatar']),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data['nickname'],
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                data['message'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7)),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 24,
                        child: OutlineButton.icon(
                          onPressed: () {},
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(0.3)),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 12,
                          ),
                          label: const Text(
                            '关注',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          } else {
            return Container(
              child: Center(child: Text(type)),
            );
          }
        });
  }

  previewPhoto(urls) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Photo(urls)));
  }

  playVideo(detail) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Video(detail)));
  }
}
