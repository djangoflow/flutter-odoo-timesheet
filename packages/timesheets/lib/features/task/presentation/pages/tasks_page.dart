import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage()
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with AutoRouteAwareStateMixin<TasksPage> {
  ValueNotifier<bool>? _isPageVisible;
  final mainKey = const ValueKey('tasks_list_visiblity_detector');

  @override
  void didPopNext() {
    context.read<TaskListCubit>().load(
          const TaskListFilter(),
        );
  }

  @override
  void initState() {
    super.initState();
    _isPageVisible = ValueNotifier<bool>(true);
    VisibilityDetectorController.instance.updateInterval =
        animationDurationShort;
  }

  @override
  void dispose() {
    _isPageVisible?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: mainKey,
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 0) {
            _isPageVisible?.value = false;
          } else {
            _isPageVisible?.value = true;
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: kPadding.h * 3),
          child: RefreshIndicator(
            onRefresh: () => context.read<TaskListCubit>().load(
                  const TaskListFilter(),
                ),
            child: BlocBuilder<TaskListCubit, TaskListState>(
              builder: (context, state) => state.map(
                (value) => _isPageVisible == null
                    ? const SizedBox()
                    : ValueListenableBuilder<bool>(
                        valueListenable: _isPageVisible!,
                        builder: (context, isVisible, child) => !isVisible
                            ? const SizedBox()
                            : ListView.separated(
                                itemCount: value.data?.length ?? 0,
                                separatorBuilder: (context, index) => SizedBox(
                                  height: kPadding.h,
                                ),
                                itemBuilder: (context, index) {
                                  final taskWithProjectExternalData =
                                      value.data![index];
                                  final task = taskWithProjectExternalData
                                      .taskWithExternalData.task;
                                  // final elapsedTime = task.elapsedTime;

                                  return TimesheetListTile(
                                    key: ValueKey(task.id),
                                    title: Text(task.name ?? ''),
                                    subtitle: const Text(
                                      // Should be timesheet description
                                      '',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // elapsedTime: elapsedTime,
                                    // initialTimerStatus: TimesheetStatusEnum
                                    //     .values[task.status],
                                    onTap: () {
                                      context.router.push(
                                        TaskDetailsRouter(
                                          taskId: task.id,
                                          children: const [TaskDetailsRoute()],
                                        ),
                                      );
                                    },
                                    onTimerResume: (context) {
                                      // context.read<TimerCubit>().elapsedTime =
                                      //     Duration(
                                      //   seconds: elapsedTime,
                                      // );
                                    },
                                    onTimerStateChange: (context, timerState,
                                        tickDurationInSeconds) async {
                                      // Need to update timesheet
                                    },
                                  );
                                },
                              ),
                      ),
                loading: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
                empty: (_) => const TimesheetsPlaceHolder(),
                error: (_) => const Center(
                  child: Text('Error occurred!'),
                ),
              ),
            ),
          ),
        ),
      );
}
