import 'package:flutter/cupertino.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import '/core/common_widgets/common_widgets.dart';

class ProImageEditorService {
  static final config = ProImageEditorConfigs(
    designMode: ImageEditorDesignMode.material,
    mainEditor: MainEditorConfigs(
      enableZoom: true,
      widgets: MainEditorWidgets(
        wrapBody: (state, stream, child) {
          return CheckerBackground(
            child: Center(
              child: SizedBox(
                width: 512,
                height: 512,
                child: ClipRect(child: child),
              ),
            ),
          );
        },
      ),
    ),
    paintEditor: const PaintEditorConfigs(enabled: true),
    textEditor: const TextEditorConfigs(enabled: true),
    cropRotateEditor: const CropRotateEditorConfigs(enabled: true),
    filterEditor: const FilterEditorConfigs(enabled: true),
    blurEditor: const BlurEditorConfigs(enabled: true),
    emojiEditor: const EmojiEditorConfigs(enabled: true),
  );
}
