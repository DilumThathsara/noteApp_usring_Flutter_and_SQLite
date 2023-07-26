import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sql_lite/controllers/sql_controller.dart';
import 'package:sql_lite/models/note_model.dart';

class NoteProvider extends ChangeNotifier {
  //--- loder
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  //---store notes list
  List<NoteModel> _notes = [];

  List<NoteModel> get notes => _notes;

  //---fetch notes
  Future<void> startFetchNotes() async {
    try {
      //---start loder
      setLoading = true;

      _notes = await SQLController.getNote();

      Logger().w(_notes.length);

      //---stop loder
      setLoading = false;

      notifyListeners();
    } catch (e) {
      Logger().e(e);
    }
  }

  //---add notes features
  final TextEditingController _title = TextEditingController();

  TextEditingController get title => _title;

  final TextEditingController _desc = TextEditingController();

  TextEditingController get desc => _desc;

  //---insert note
  Future<void> addNewNotes(BuildContext context) async {
    try {
      //---chech if the title or description is empty
      if (_title.text.isEmpty || _desc.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Fill all the filds")));
      } else {
        //---start loder
        setLoading = true;

        await SQLController.createNote(_title.text, _desc.text);

        _title.clear();
        _desc.clear();

        //--- freshing notes list
        await startFetchNotes();

        //---stop loder
        setLoading = false;
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  //--- set textediting controllers when update
  void setControllers(String title, String desc) {
    _title.text = title;
    _desc.text = desc;
    notifyListeners();
  }

  //--- updating a note
  Future<void> updateNote(BuildContext context, int id) async {
    try {
      //---chech if the title or description is empty
      if (_title.text.isEmpty || _desc.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Fill all the filds")));
      } else {
        //---start loder
        setLoading = true;

        await SQLController.updateNote(id, _title.text, _desc.text);

        _title.clear();
        _desc.clear();

        //--- freshing notes list
        await startFetchNotes();

        //---stop loder
        setLoading = false;
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  //--- delete a note
  Future<void> deleteNote(BuildContext context, int id) async {
    try {
      //---start loder
      setLoading = true;

      await SQLController.deleteNote(id);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("You deleted a note")));

      //--- freshing notes list
      await startFetchNotes();

      //---stop loder
      setLoading = false;
    } catch (e) {
      Logger().e(e);
    }
  }
}
