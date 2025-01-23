import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:myeuc_x_supabase/shared/buttons.dart';


class PolicyDialog extends StatefulWidget {
  PolicyDialog({
    super.key,
    required this.mdFileName,
    this.onTap,
    required this.buttonName,
  }) : assert(mdFileName.contains('.md'), 'The file must contain .md extension');

  final String mdFileName;
  final void Function()? onTap;
  final String buttonName;


  @override
  _PolicyDialogState createState() => _PolicyDialogState();
}

class _PolicyDialogState extends State<PolicyDialog> {
  late ScrollController _scrollController;
  bool _isAtEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    print("CONTROLLER ::: ${_scrollController.position}");
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      if (!_isAtEnd) {
        setState(() {
          _isAtEnd = true;
        });
      }
    } 
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 400)).then((value) {
                return rootBundle.loadString('assets/markdown/${widget.mdFileName}');
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                    controller: _scrollController,
                    data: snapshot.data ?? '',
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          if (_isAtEnd)
          MyButtonExpanded(
            onTap: widget.onTap,
            buttonName: widget.buttonName,
          ),
        ],
      ),
    );
  }
}