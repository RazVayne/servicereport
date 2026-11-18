import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart';

class UiRouteFormAddReport extends StatefulWidget {
  const UiRouteFormAddReport({super.key});

  @override
  State<UiRouteFormAddReport> createState() => _UiRouteFormAddReportState();
}

class _UiRouteFormAddReportState extends State<UiRouteFormAddReport> {
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerScroll) => [
        SliverAppBar(
          title: FHeader(
            title: const Text("Add service report"),
            suffixes: [
              FButton.icon(
                child: const Icon(FLucideIcons.check),
                onPress: () {},
              ),
            ],
          ),
        ),
      ],
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FCard(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                spacing: 18.0,
                children: [
                  FDateField(
                    description: const Text("Service date"),
                    autovalidateMode: .onUserInteraction,
                    validator: (value) =>
                        (value != null && value.toIso8601String().isEmpty)
                        ? "Date can't be empty"
                        : null,
                  ),
                  FTextFormField(
                    description: const Text("Location"),
                    autovalidateMode: .always,
                    validator: (value) => (value!.length > 1)
                        ? null
                        : "Field has less than 2 characters.",
                  ), //TODO: Implement iterable list from LOCATION fields in DB
                  FTextFormField(
                    description: const Text("Description"),
                    autovalidateMode: .always,
                    validator: (value) => (value!.length > 1)
                        ? null
                        : "Field has less than 2 characters.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
