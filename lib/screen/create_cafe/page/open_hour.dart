import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

import '../bloc/create_cafe_bloc.dart';

class OpenHourForm extends StatelessWidget {
  const OpenHourForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DescriptionFormView();
  }
}

class _DescriptionFormView extends StatefulWidget {
  const _DescriptionFormView();

  @override
  State<_DescriptionFormView> createState() => _DescriptionFormViewState();
}

class _DescriptionFormViewState extends State<_DescriptionFormView> {
  List<String> listDay = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  Future<void> getTime(bool isOpen, int index, Days days) async {
    final bloc = BlocProvider.of<CreateCafeBloc>(context);

    bool isClosed = false;
    TimeOfDay? time = TimeOfDay.now();

    time = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child!,
              ElevatedButton(
                  onPressed: () {
                    isClosed = true;
                    Navigator.pop(context);
                  },
                  child: const Text('Cafe Tutup'))
            ],
          ),
        ),
      ),
    );

    OpenTime openTime = bloc.state.openTime;

    Day day = openTime.getFromIndex(index) ?? Day(day: days);

    if (!isClosed && time != null) {
      if (isOpen) {
        day = day.copyWith(open: time);
      } else {
        day = day.copyWith(close: time);
      }
    } else if (isClosed && time == null) {
      day = Day(day: days, open: null, close: null);
    }

    OpenTime open = openTime.setFromIndex(index, day);

    bloc.add(
      CreateCafeOpenTimeChanged(open),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListView(
      shrinkWrap: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(kDefaultSpacing),
      children: [
        const SizedBox(height: kDefaultSpacing),
        SvgPicture.asset(
          'assets/svg/undraw_time_management_re_tk5w.svg',
          width: size.width * 0.8,
          height: size.width * 0.5,
        ),
        const SizedBox(height: kDefaultSpacing),
        Text(
          'Kapan saja cafemu buka?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Text(
          'Beberapa orang ingin tahu kapan saja cafemu buka, jadi pastikan kamu mengisi dengan benar ya!',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kDefaultSpacing * 2),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listDay.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: kDefaultSpacing / 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(listDay[index],
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  Flexible(
                    child: _TimeInput(
                      onTap: () => getTime(true, index, Days.values[index]),
                      index: index,
                      isOpen: true,
                    ),
                  ),
                  const SizedBox(width: kDefaultSpacing / 2),
                  Flexible(
                    child: _TimeInput(
                      index: index,
                      isOpen: false,
                      onTap: () => getTime(false, index, Days.values[index]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: kDefaultSpacing / 2),
      ],
    );
  }
}

class _TimeInput extends StatefulWidget {
  const _TimeInput(
      {required this.onTap, required this.index, required this.isOpen});

  final VoidCallback onTap;
  final int index;
  final bool isOpen;

  @override
  State<_TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<_TimeInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text =
        getTime(BlocProvider.of<CreateCafeBloc>(context).state.openTime);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getTime(OpenTime openTime) {
    TimeOfDay? time;

    if (widget.isOpen) {
      time = openTime.getFromIndex(widget.index)?.open;
    } else {
      time = openTime.getFromIndex(widget.index)?.close;
    }

    if (time == null || !openTime.getFromIndex(widget.index)!.openOnTheDay()) {
      return '-';
    }

    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCafeBloc, CreateCafeState>(
      listenWhen: (previous, current) => previous.openTime != current.openTime,
      listener: (context, state) {
        _controller.text = getTime(state.openTime);
      },
      child: CustomTextFormField(
        key: Key('TimeChanger${widget.index}'),
        readOnly: true,
        controller: _controller,
        onTap: widget.onTap,
        style: Theme.of(context).textTheme.bodyLarge,
        radius: 10,
      ),
    );
  }
}
