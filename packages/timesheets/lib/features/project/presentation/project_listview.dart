import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_list_bloc/flutter_list_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/utils/utils.dart';

class ProjectListView<T extends ProjectListCubit> extends StatelessWidget {
  const ProjectListView({super.key, required this.emptyBuilder});

  final Widget Function(BuildContext context, ProjectListState state)
      emptyBuilder;

  @override
  Widget build(BuildContext context) => ContinuousListViewBlocBuilder<T,
          ProjectWithExternalData, ProjectListFilter>(
        withRefreshIndicator: true,
        emptyBuilder: emptyBuilder,
        loadingBuilder: (context, state) => const SizedBox(),
        itemBuilder: (context, state, index, projectWithExternalData) {
          final project = projectWithExternalData.project;

          return ListTile(
            leading: ColoredBar(
              color: project.color.toColorFromColorIndex,
            ),
            title: Row(
              children: [
                Icon(
                  project.isFavorite == true
                      ? CupertinoIcons.star_fill
                      : CupertinoIcons.star,
                ),
                SizedBox(
                  width: kPadding.w,
                ),
                Expanded(
                  child: Text(
                    project.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            subtitle: Text('${project.taskCount ?? 0} Tasks'),
            onTap: () async {
              final cubit = context.read<T>();
              await context.router
                  .push(ProjectDetailsRoute(projectId: project.id));

              cubit.reload();
            },
          );
        },
        builder: (context, controller, itemBuilder, itemCount) =>
            ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          padding: EdgeInsets.all(
            kPadding.h * 2,
          ),
          itemBuilder: itemBuilder,
          separatorBuilder: (context, index) => SizedBox(
            height: kPadding.h,
          ),
          itemCount: itemCount,
        ),
      );
}
