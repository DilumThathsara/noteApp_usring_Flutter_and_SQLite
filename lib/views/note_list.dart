import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_lite/models/note_model.dart';
import 'package:sql_lite/providers/note_provider.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      //---start fetch notes when app loads
      Provider.of<NoteProvider>(context, listen: false).startFetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, value, child) {
          return value.isLoading
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return NoteCard(
                      model: value.notes[index],
                    );
                  },
                  itemCount: value.notes.length,
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return const ModelSheetWidget();
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class ModelSheetWidget extends StatelessWidget {
  const ModelSheetWidget({
    Key? key,
    this.isUpdating = false,
    this.id,
  }) : super(key: key);

  final bool isUpdating;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Consumer<NoteProvider>(
            builder: (context, value, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: value.title,
                    decoration: const InputDecoration(hintText: "title here"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: value.desc,
                    decoration:
                        const InputDecoration(hintText: "description here"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (isUpdating) {
                        value.updateNote(context, id!);
                      } else {
                        value.addNewNotes(context);
                      }
                    },
                    child: Text(isUpdating ? "Update note" : "Save Note"),
                  ),
                ],
              );
            },
          )),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final NoteModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        tileColor: Colors.purple[100],
        title: Text(model.title),
        subtitle: Text(model.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Provider.of<NoteProvider>(context, listen: false)
                    .setControllers(model.title, model.description);
                showBottomSheet(
                    context: context,
                    builder: (context) {
                      return ModelSheetWidget(
                        isUpdating: true,
                        id: model.id,
                      );
                    });
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => Provider.of<NoteProvider>(context, listen: false)
                  .deleteNote(context, model.id!),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
