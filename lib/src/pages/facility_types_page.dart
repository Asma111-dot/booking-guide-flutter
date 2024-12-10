import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/facility_type.dart';
import '../providers/facility_type/facility_type_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/view_widget.dart';
import '../utils/routes.dart';

class FacilityTypesPage extends ConsumerStatefulWidget {
  FacilityTypesPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FacilityTypesPageState();
}

class _FacilityTypesPageState extends ConsumerState<FacilityTypesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(facilityTypesProvider.notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilityTypesState = ref.watch(facilityTypesProvider);

    return Scaffold(
      // appBar: CustomAppBar(
      //   appTitle: trans().welcomeToBooking,
      //   icon: const FaIcon(Icons.arrow_back_ios),
      // ),
      body: ViewWidget<List<FacilityType>>(
        meta: facilityTypesState.meta,
        data: facilityTypesState.data,
        onLoaded: (data) {
          return buildFacilityTypesGrid(data, context);
        },
        onLoading: () => Center(child: CircularProgressIndicator()),
        onEmpty: () =>
            const Center(child: Text('No facility types available.')),
        requireLogin: false,
        showError: true,
        showEmpty: true,
      ),
    );
  }

  Widget buildFacilityTypesGrid(List<FacilityType> data, BuildContext context) {
    return Column(
      children: [
        CustomAppBarClipper(
          backgroundColor: CustomTheme.primaryColor,
          height: 160.0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 20.0),
              child: Text(
                trans().welcomeToBooking,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 0.0),
        Image.asset(
          logoCoverImage,
          width: 150,
          height: 150,
        ),
        const SizedBox(height: 20),
        Text(
          trans().chooseOne,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: CustomTheme.primaryColor,
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 3 / 4,
            ),
            itemCount: data.reversed.length,
            itemBuilder: (context, index) {
              final facilityType = data.reversed.toList()[index];
              final image =
                  facilityType.name == 'فنادق' ? hotelImage : chaletImage;

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    facilityType.name == 'فنادق'
                        ? Routes.hotels
                        : Routes.chalets,
                  );
                },
                child: buildFacilityTypeCard(
                  context,
                  image: image,
                  title: facilityType.name == 'فنادق'
                      ? facilityType.name
                      : facilityType.name,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildFacilityTypeCard(BuildContext context,
      {required String image, required String title}) {
    return Container(
      decoration: BoxDecoration(
        //  color: CustomTheme.primaryColor,
        border: Border.all(
            color: CustomTheme.primaryColor, width: CustomTheme.borderWidth),
        borderRadius: BorderRadius.circular(CustomTheme.radius),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(CustomTheme.radius)),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              title,
              style: TextStyle(
                color: CustomTheme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
