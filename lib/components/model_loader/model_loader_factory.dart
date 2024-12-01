import 'package:threed_viewer/components/model_loader/impl/glb_loader_adapter.dart';
import 'package:threed_viewer/components/model_loader/model_loader.dart';
import 'package:threed_viewer/components/model_loader/impl/obj_loader_adapter.dart';
import 'package:threed_viewer/components/model_loader/impl/stl_loader_adapter.dart';
import 'package:threed_viewer/utils/strings.dart';

class ModelLoaderFactory {
  static ModelLoader getLoader(String filePath) {
    final fileExtension = filePath.split('.').last.toLowerCase();
    print("filepath : $filePath");

    switch (fileExtension) {
      case 'obj':
        return ObjLoaderAdapter();
      case 'glb':
        return GlbLoaderAdapter();
      case 'stl':
        return StlLoaderAdapter();
      default:
        throw UnsupportedError('${AppStrings.unSupportedError} $filePath');
    }
  }
}
