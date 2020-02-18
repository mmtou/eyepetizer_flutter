import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/moment.dart';
import '../components/community.dart';
import '../utils/common.dart';
import '../utils/http.dart';

class Index extends StatefulWidget {
  @override
  _Index createState() => _Index();
}

class _Index extends State<Index> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    print('重新渲染');
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            elevation: 0,
            bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: tabs.map((tab) {
                  return Tab(text: tab['name']);
                }).toList()),
          ),
          preferredSize: Size.square(48),
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabs.map((tab) {
            if (tab['itemList'] == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (tab['name'] == '社区') {
                return Community(
                  tab['itemList'] ?? [],
                  refresh,
                  load,
                );
              } else {
                return Moment(
                  tab['itemList'] ?? [],
                  refresh: refresh,
                  load: load,
                );
              }
            }
          }).toList(),
        ),
      ),
    );
  }

  // tabs
  List tabs = [];
  int active = 0;
  TabController _tabController;

  // 获取分类
  getCategory() async {
    var data = await Http().get('/api/v5/index/tab/list');
    this.tabs.addAll(data['tabInfo']['tabList']);
    this.active = data['tabInfo']['defaultIdx'];

    _tabController = TabController(vsync: this, length: tabs.length)
      ..addListener(() async {
        this.active = _tabController.index;
        List list = this.tabs[_tabController.index]['itemList'];
        if (list == null) {
          await refresh();
        }
      });

    if (this.active != 0) {
      _tabController.animateTo(this.active);
    }
  }

  getContent({url}) async {
    var data = await Http()
        .get(Common.getUrl(url ?? this.tabs[this.active]['apiUrl']));
    var item = this.tabs[this.active];
    List itemList = item['itemList'] ?? [];
    itemList.addAll(data['itemList']);
    item['count'] = data['count'];
    item['total'] = data['total'];
    item['nextPageUrl'] = data['nextPageUrl'];
    item['adExist'] = data['adExist'];
    item['itemList'] = itemList;
    this.tabs[this.active] = item;

    setState(() {
      this.tabs = this.tabs;
    });
  }

  refresh() async {
    this.tabs[this.active]['itemList'] = [];
    await this.getContent();
    return true;
  }

  load() async {
    var nextPageUrl = this.tabs[this.active]['nextPageUrl'];
    if (nextPageUrl != null) {
      await this.getContent(url: this.tabs[this.active]['nextPageUrl']);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
