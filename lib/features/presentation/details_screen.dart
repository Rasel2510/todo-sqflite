import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/model/add_todo_model.dart';
import 'package:todo/features/data/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final ModelClass item;
  final Color containerColor;

  const DetailsScreen({
    super.key,
    required this.item,
    required this.containerColor,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController descController;
  bool isEditing = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    descController = TextEditingController(text: widget.item.age);
    isEditing = (descController.text.isEmpty);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  //open link
  Future<void> _openLink(LinkableElement link) async {
    final uri = Uri.parse(link.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Auto save on back
  Future<bool> _onWillPop() async {
    final provider = Provider.of<TodoProvider>(context, listen: false);

    widget.item.name = nameController.text;
    widget.item.age = descController.text;

    await provider.updateTodo(widget.item);

    return true;
  }

  Color getTextColor(Color bgColor) {
    return ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColor(widget.containerColor);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _onWillPop();
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.chevron_left, size: 30),
              ),
              IconButton(
                icon: const Icon(Icons.save_outlined),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final provider = Provider.of<TodoProvider>(
                    context,
                    listen: false,
                  );

                  // Update the current item
                  widget.item.name = nameController.text;
                  widget.item.age = descController.text;

                  // Save/update in provider
                  await provider.updateTodo(widget.item);
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.containerColor.withAlpha(60),
                      widget.containerColor,
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                        ),
                      ),
                      const SizedBox(height: 16),
                      isEditing
                          ? TextField(
                              autofocus: true,
                              controller: descController,
                              style: TextStyle(fontSize: 16, color: textColor),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Description",
                              ),
                              maxLines: null,
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isEditing = false;
                                });
                              },
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                              child: Linkify(
                                text: descController.text,
                                onOpen: _openLink,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                                linkStyle: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
