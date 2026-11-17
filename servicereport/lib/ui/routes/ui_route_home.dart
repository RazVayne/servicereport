import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:servicereport/main.dart';
import 'package:servicereport/ui/widgets/ui_widget_card_home_report.dart';
import 'package:signals/signals_hooks.dart';

class UiRouteHome extends StatelessWidget {
  const UiRouteHome({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: SignalBuilder(
                builder: (context) => FHeader(
                  title: Text(
                    signalSqflite.unpayedReportsCount.value == 0
                        ? "No due services."
                        : "${signalSqflite.unpayedReportsCount.value} unpayed services.",
                  ),
                  suffixes: [
                    FHeaderAction(
                      icon: const Icon(FLucideIcons.plus),
                      onPress: () {},
                    ),
                  ],
                ),
              ),
              background: Image.asset(
                "assets/cover/sliverappbar_cover.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ];
      },
      body: SignalBuilder(
        builder: (context) => signalSqflite.reportsListFuture.value.map(
          data: (reportsList) {
            return reportsList.isNotEmpty
                ? UiWidgetCardHomeReport(report: reportsList.first)
                : Center(child: const Icon(FLucideIcons.ghost));
          },
          error: (err, stack) => Center(
            child: FTile(
              prefix: const Icon(FLucideIcons.bug),
              title: Text(err.toString()),
              suffix: FButton.icon(
                child: const Icon(FLucideIcons.rotateCcw),
                onPress: () {
                  signalSqflite.reportsListFuture.reload();
                },
              ),
            ),
          ),
          loading: () => Center(child: FCircularProgress()),
        ),
      ),
    );
  }
}
