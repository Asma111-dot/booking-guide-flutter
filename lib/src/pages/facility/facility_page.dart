import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/facility/facility_provider.dart';
import '../../widgets/view_widget.dart';
import '../../models/facility.dart';

abstract class FacilityPage extends ConsumerStatefulWidget {
  final int facilityTypeId;
  final String pageTitle;

  const FacilityPage({
    Key? key,
    required this.facilityTypeId,
    required this.pageTitle,
  }) : super(key: key);

  Widget buildFacilityCard(BuildContext context, Facility facility);

  @override
  ConsumerState createState() => _FacilityPageState();
}

class _FacilityPageState extends ConsumerState<FacilityPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: widget.facilityTypeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.pageTitle)),
      body: ViewWidget<List<Facility>>(
        meta: facilitiesState.meta,
        data: facilitiesState.data,
        onLoaded: (data) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final facility = data[index];
              return widget.buildFacilityCard(context, facility);
            },
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () => const Center(child: Text("No data available")),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
