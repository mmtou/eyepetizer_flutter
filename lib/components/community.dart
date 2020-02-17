import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../views/photo.dart';
import '../views/video.dart';

class Community extends StatefulWidget {
  final List _moment;
  final refresh;
  final load;

  Community(this._moment, this.refresh, this.load);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 32 - 6) / 2;

    return EasyRefresh(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: widget._moment.map((item) {
            var data = item['data']['content']['data'];
            if (item['type'] == 'pictureFollowCard') {
              List urls = data['urls'];
              return InkWell(
                  onTap: () => previewPhoto(urls),
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl: data['cover']['feed'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  width: width,
                                  height: width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              child: Icon(
                                urls.length > 1
                                    ? Icons.photo_library
                                    : Icons.photo,
                                color: Colors.white,
                              ),
                              top: 6,
                              right: 6,
                            ),
                          ],
                        ),
                        Container(
                          width: width,
                          padding: const EdgeInsets.only(top: 6, bottom: 6),
                          child: Text(
                            data['description'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            softWrap: true,
                          ),
                        ),
                        Container(
                          width: width,
                          padding: const EdgeInsets.only(top: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              data['owner']['avatar']),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                          data['owner']['nickname'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Text(
                                        '${data['consumption']['collectionCount']}'),
                                  ),
                                  const Icon(
                                    Icons.favorite_border,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            } else if (item['type'] == 'autoPlayFollowCard') {
              return InkWell(
                  onTap: () => playVideo(data),
                  child: Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl: data['cover']['feed'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  width: width,
                                  height: width,
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                          child: Text(
                            data['description'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            softWrap: true,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundImage: CachedNetworkImageProvider(
                                        data['owner']['avatar']),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Text(
                                        data['owner']['nickname'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: Text(
                                      '${data['consumption']['collectionCount']}'),
                                ),
                                const Icon(
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
            } else {
              return Container();
            }
          }).toList(),
        ),
      ),
      header:
          BezierCircleHeader(backgroundColor: Theme.of(context).primaryColor),
      footer:
          BezierBounceFooter(backgroundColor: Theme.of(context).primaryColor),
      onRefresh: () async {
        return await widget.refresh();
      },
      onLoad: () async {
        return await widget.load();
      },
    );
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
