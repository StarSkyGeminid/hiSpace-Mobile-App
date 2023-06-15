import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/create_cafe_bloc.dart';

class ImageForm extends StatefulWidget {
  const ImageForm({super.key});

  @override
  State<ImageForm> createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  Future<void> _pickImage() async {
    final bloc = BlocProvider.of<CreateCafeBloc>(context);

    ImagePicker picker = ImagePicker();

    final images = await picker.pickMultiImage();

    if (images.isEmpty) return;

    bloc.add(CreateCafeAddPicture(images));
  }

  Future<bool?> _deleteImage() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Foto'),
        content: Text(
          'Apakah anda ingin menghapus foto ini?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestDeleteImage(int index) async {
    final bloc = BlocProvider.of<CreateCafeBloc>(context);

    bool? status = await _deleteImage();

    if (status != null && status) {
      bloc.add(CreateCafeDeletePicture(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: kDefaultSpacing,
              top: kDefaultSpacing,
              right: kDefaultSpacing,
            ),
            child: SvgPicture.asset(
              'assets/svg/undraw_camera_re_cnp4.svg',
              width: size.width * 0.8,
              height: size.width * 0.5,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: kDefaultSpacing,
              top: kDefaultSpacing,
              right: kDefaultSpacing,
            ),
            child: Text(
              'Tambahkan Foto-foto Cafemu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: kDefaultSpacing,
              top: kDefaultSpacing,
              right: kDefaultSpacing,
            ),
            child: Text(
              'Tambahkan foto-foto yang menarik untuk menarik perhatian pengunjung.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
       
        BlocBuilder<CreateCafeBloc, CreateCafeState>(
          buildWhen: (previous, current) =>
              previous.images.length != current.images.length,
          builder: (context, state) {
            return SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultSpacing / 2,
                vertical: kDefaultSpacing,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 10 / 16,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  if (index == state.images.length) {
                    return InkWell(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.05),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  }


                  return InkWell(
                    onLongPress: () => _requestDeleteImage(index),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return _ImageDetail(image: state.images[index]);
                      }));
                    },
                    child: Hero(
                      tag: 'AddImageCafe_${state.images[index].name}',
                      child: Image.file(
                        File(state.images[index].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                itemCount: state.images.length + 1,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ImageDetail extends StatefulWidget {
  const _ImageDetail({required this.image});

  final XFile image;

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<_ImageDetail> {
  @override
  initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'AddImageCafe_${widget.image.name}',
            child: Image.file(
              File(widget.image.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
