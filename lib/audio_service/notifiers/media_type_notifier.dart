import 'package:flutter/foundation.dart';
import 'package:radiostream/helper/media_helper.dart';

class MediaTypeNotifier extends ValueNotifier<MediaType> {
  MediaTypeNotifier() : super(_initialValue);
  static const _initialValue = MediaType.radio;
}
