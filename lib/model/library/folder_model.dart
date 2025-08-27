class FolderModel {
  final bool? success;
  final int? total;
  final List<Folder>? folders;

  FolderModel({
    this.success,
    this.total,
    this.folders,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      success: json['success'] as bool?,
      total: json['total'] as int?,
      folders: (json['folders'] as List<dynamic>?)
          ?.map((e) => Folder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'total': total,
      'folders': folders?.map((e) => e.toJson()).toList(),
    };
  }
}

class Folder {
  final int? id;
  final String? folderName;

  Folder({
    this.id,
    this.folderName,
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'] as int?,
      folderName: json['folder_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'folder_name': folderName,
    };
  }
}
