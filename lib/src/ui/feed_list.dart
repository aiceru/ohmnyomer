import 'package:flutter/material.dart';

class FeedList extends StatelessWidget {
  const FeedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.separated(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return const ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              foregroundImage: AssetImage('assets/dev/bowl-full.jpeg'),
            ),
            title: Text('오전 07:23'),
            trailing: Text('1/4 컵'),
            // tileColor: Colors.lightGreenAccent,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }
}
