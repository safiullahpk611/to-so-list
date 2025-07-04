import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../services/view_state.dart';

class BaseViewModal extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
