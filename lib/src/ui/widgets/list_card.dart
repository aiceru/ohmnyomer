import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ListCard extends StatelessWidget {
  const ListCard(Widget leading, String content, String subContent,
      {Key? key, void Function()? onTap, Widget? trailing})
      : _leading = leading,
        _trailing = trailing,
        _content = content,
        _subContent = subContent,
        _onTap = onTap,
        super(key: key);

  final Widget _leading;
  final Widget? _trailing;
  final String _content;
  final String _subContent;
  final Function()? _onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: _onTap,
        leading: SizedBox(
            width: 15.w,
            child: Center(
              child: _leading,
            )
        ),
        title: Text(_content),
        subtitle: Text(_subContent),
        trailing: _trailing != null ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _trailing!,
          ],
        ) : null,
      ),
    );
  }
}
