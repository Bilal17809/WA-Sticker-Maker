import 'dart:io';

class GalleryState {
  final File? imageFile;
  final bool isSaving;

  const GalleryState({this.imageFile, this.isSaving = false});

  GalleryState copyWith({File? imageFile, bool? isSaving}) {
    return GalleryState(
      imageFile: imageFile ?? this.imageFile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
