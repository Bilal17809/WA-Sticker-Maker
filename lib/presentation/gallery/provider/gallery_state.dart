import 'dart:io';

class GalleryState {
  final File? originalFile;
  final File? editedFile;
  final bool isSaving;

  const GalleryState({
    this.originalFile,
    this.editedFile,
    this.isSaving = false,
  });

  GalleryState copyWith({
    File? originalFile,
    File? editedFile,
    bool? isSaving,
  }) {
    return GalleryState(
      originalFile: originalFile ?? this.originalFile,
      editedFile: editedFile ?? this.editedFile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
