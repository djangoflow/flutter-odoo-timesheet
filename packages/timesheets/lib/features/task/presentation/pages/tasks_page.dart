import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/task/presentation/task_list_tile.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timer/blocs/timer_cubit/timer_cubit.dart';

@RoutePage()
class TasksPage extends StatelessWidget with AutoRouteWrapper {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings_outlined,
                size: kPadding.r * 4,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kPadding.r),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          child: Icon(
            Icons.add,
            size: kPadding.r * 4,
          ),
          onPressed: () async {},
        ),
        body: Padding(
          padding: EdgeInsets.only(top: kPadding.h * 3),
          child: RefreshIndicator(
            onRefresh: () => context.read<TasksListCubit>().load(
                  const TasksListFilter(),
                ),
            child: BlocBuilder<TasksListCubit, TasksListState>(
              builder: (context, state) => state.map(
                (value) => ListView.separated(
                  itemCount: value.data?.length ?? 0,
                  separatorBuilder: (context, index) => SizedBox(
                    height: kPadding.h,
                  ),
                  itemBuilder: (context, index) {
                    final task = value.data![index];
                    return TaskListTile(
                      key: ValueKey(task.id),
                      title: Text(task.name),
                      subtitle: Text(task.description),
                      elapsedTime: task.duration,
                      initialTimerStatus: TimerStatus.values[task.status],
                      onTap: () {},
                      onTimerStateChange: (timerState, tickDurationInSeconds) {
                        final updatableSeconds =
                            (timerState.status == TimerStatus.running
                                ? tickDurationInSeconds
                                : 0);
                        context.read<TasksListCubit>().updateTask(
                              task.copyWith(
                                duration: task.duration + updatableSeconds,
                                status: timerState.status.index,
                              ),
                            );
                      },
                    );
                  },
                ),
                loading: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
                empty: (_) => const TasksPlaceHolder(),
                error: (_) => const Center(
                  child: Text('Error occurred!'),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<TasksListCubit>(
        create: (context) => TasksListCubit(
          context.read<TasksRepository>(),
        )..load(
            const TasksListFilter(),
          ),
        child: this,
      );
}