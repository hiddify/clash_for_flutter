import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:day/day.dart';
import 'package:day/plugins/relative_time.dart';

import 'package:clash_for_flutter/utils/utils.dart';
import 'package:clash_for_flutter/types/config.dart';
import 'package:clash_for_flutter/widgets/loading.dart';

class PageProfileSubItem extends StatefulWidget {
  const PageProfileSubItem({
    Key? key,
    required this.sub,
    required this.value,
    required this.onEdit,
    required this.onSelect,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  final ConfigSub sub;
  final String value;
  final void Function(ConfigSub) onEdit;
  final void Function(ConfigSub) onSelect;
  final void Function(ConfigSub) onDelete;
  final Future<void> Function(ConfigSub) onUpdate;

  @override
  State<PageProfileSubItem> createState() => _PageProfileSubItemState();
}

class _PageProfileSubItemState extends State<PageProfileSubItem> {
  final LoadingController _loadingController = LoadingController();

  Future<void> _onUpdate() async {
    _loadingController.show();
    await widget.onUpdate(widget.sub);
    _loadingController.hide();
  }

  @override
  Widget build(BuildContext context) {
    final sub = widget.sub;
    return Loading(
        controller: _loadingController,
        child: Row(
          children: [
            Text(sub.name).fontSize(14).padding(right: 10).expanded(),
            Text(sub.url ?? '-').fontSize(14).padding(right: 10).expanded(),
            Text(sub.updateTime == null ? '-' : Day().from(Day.fromUnix(sub.updateTime! * 1000))).fontSize(14).padding(right: 5).width(100),
            Text(sub.info == null ? '-' : '${bytesToSize((sub.info?.upload ?? 0) + (sub.info?.download ?? 0))}\n${bytesToSize(sub.info?.total ?? 0)}')
                .fontSize(14)
                .width(80),
            Text(sub.info == null ? '-' : Day.fromUnix((sub.info?.expire ?? 0) * 1000).format('YYYY-MM-DD')).fontSize(14).width(80),
            Row(
              children: [
                IconButton(
                  tooltip: 'Refresh',
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: (sub.url ?? '').isEmpty ? null : _onUpdate,
                ),
                IconButton(
                  tooltip: 'Edit',
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => widget.onEdit(sub),
                ),
                IconButton(
                  tooltip: 'Delete',
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.delete_forever, size: 20),
                  onPressed: widget.value == sub.name ? null : () => widget.onDelete(sub),
                ),
                Radio(
                  value: sub.name,
                  groupValue: widget.value,
                  onChanged: (v) => widget.onSelect(sub),
                )
              ],
            ).width(160),
          ],
        ).padding(left: 15, right: 15, all: 5).border(bottom: 1, color: Colors.grey.shade200));
  }
}
