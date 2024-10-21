import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/utils/assets.gen.dart';

class EmptyProjectsPlaceholder extends EmptyPlaceholder {
  EmptyProjectsPlaceholder({super.key, super.onGetStarted, String? title})
      : super(
          icon: DecoratedSvgImage(
            image: Assets.iconsWork,
            height: 96,
            width: 96,
          ),
          title: title ?? 'You don\'t have any projects',
          message: 'Create a project to begin',
        );
}
