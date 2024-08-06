import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:my_library/src/home/home_store.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  List<CameraDescription> cameras = [];

  bool showFocusCircle = false;
  double x = 0;
  double y = 0;

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
    initCameras();
  }

  Future initCameras() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Tire uma foto para a capa')),
      body: GestureDetector(
        onTapUp: (details) {
          _onTap(details);
        },
        child: Stack(
          children: [
            Center(child: CameraPreview(controller)),
            if (showFocusCircle)
              Positioned(
                top: y - 20,
                left: x - 20,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            Positioned(
              bottom: 10.0,
              right: 100,
              left: 100,
              child: IconButton(
                icon: const Icon(
                  Icons.camera,
                  size: 50.0,
                ),
                onPressed: () async {
                  final XFile photo = await controller.takePicture();
                  String filePath = photo.path;

                  await Gal.putImage(filePath);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final homeStore = context.read<HomeStore>();
                    homeStore.changeBookCover(filePath.toString());
                    Navigator.of(context).pop();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;
      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;
      double xp = x / fullWidth;
      double yp = y / cameraHeight;
      Offset point = Offset(xp, yp);
      await controller.setFocusPoint(point);
      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }

  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    print('Permission status: $status');
  }
}
