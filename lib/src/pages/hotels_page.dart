import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../providers/facility/facility_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/facility_widget.dart';
import '../widgets/view_widget.dart';
import '../models/facility.dart';

class HotelsPage extends ConsumerStatefulWidget {
  const HotelsPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HotelsPageState();
}

class _HotelsPageState extends ConsumerState<HotelsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider);
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: trans().hotel,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ViewWidget<List<Facility>>(
              meta: facilitiesState.meta,
              data: facilitiesState.data,
              onLoaded: (data) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final facility = data[index];
                    return FacilityWidget(facility: facility);
                  },
                );
              },
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onEmpty: () => Center(
                child: Text(trans().no_data),
              ),
              showError: true,
              showEmpty: true,
            ),
          ),
        ],
      ),
    );
  }
}
