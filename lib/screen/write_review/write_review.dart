import 'package:cafe_repository/cafe_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/bloc/authentication/authentication_bloc.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/formz_models/review.dart';
import 'package:hispace_mobile_app/screen/write_review/cubit/write_review_cubit.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';

class WriteReview extends StatelessWidget {
  const WriteReview({super.key, required this.locationId});

  final String locationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WriteReviewCubit(
        RepositoryProvider.of<CafeRepository>(context),
        BlocProvider.of<AuthenticationBloc>(context).state.user,
        locationId,
      ),
      child: const _WriteReviewView(),
    );
  }
}

class _WriteReviewView extends StatelessWidget {
  const _WriteReviewView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<WriteReviewCubit, WriteReviewState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == WriteReviewStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );

            Navigator.pop(context);
          } else if (state.status == WriteReviewStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tulis Review'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(kDefaultSpacing),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: BlocBuilder<WriteReviewCubit, WriteReviewState>(
                    builder: (context, state) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => context
                              .read<WriteReviewCubit>()
                              .ratingChanged(index),
                          child: Icon(
                            state.rating >= index
                                ? Icons.star
                                : Icons.star_border,
                            color: ColorPallete.light.yellow,
                            size: 45,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const _ReviewForm(),
              ],
            ),
          ),
          bottomNavigationBar: const Padding(
            padding: EdgeInsets.all(kDefaultSpacing),
            child: _SubmitReviewButton(),
          ),
        ),
      ),
    );
  }
}

class _SubmitReviewButton extends StatelessWidget {
  const _SubmitReviewButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WriteReviewCubit, WriteReviewState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('writeReviewForm_submitButton'),
          onPressed:
              state.isValidated && state.status != WriteReviewStatus.loading
                  ? () => context.read<WriteReviewCubit>().submit()
                  : null,
          child: Padding(
            padding: const EdgeInsets.all(kDefaultSpacing),
            child: state.status == WriteReviewStatus.loading
                ? const SizedBox(
                    height: kDefaultSpacing,
                    width: kDefaultSpacing,
                    child: CircularProgressIndicator.adaptive())
                : const Text('Kirim'),
          ),
        );
      },
    );
  }
}

class _ReviewForm extends StatelessWidget {
  const _ReviewForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WriteReviewCubit, WriteReviewState>(
      builder: (context, state) {
        return CustomTextFormField(
          title: 'Tulis ulasanmu dibawah',
          hintText: 'Tulis ulasan disini',
          maxLines: null,
          maxLength: 1000,
          errorText: state.review.displayError?.text(),
          onChanged: (review) =>
              context.read<WriteReviewCubit>().reviewChanged(review),
          decoration: InputDecoration(
            counter: Text('${state.review.value.length}/1000'),
          ),
        );
      },
    );
  }
}
