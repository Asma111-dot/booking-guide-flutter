import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../providers/facility/facility_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/back_button.dart';
import '../widgets/view_widget.dart';
import '../models/facility.dart';
import 'hotel_details_page.dart';

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
      appBar: AppBar(
        leading: BackButtonWidget(), // Add the back button widget here
        title: Text(
          trans().hotel,
          style: TextStyle(color: CustomTheme.placeholderColor),
        ),
        backgroundColor: CustomTheme.primaryColor,
        centerTitle: true,
      ),
      body: ViewWidget<List<Facility>>(
        meta: facilitiesState.meta,
        data: facilitiesState.data,
        onLoaded: (data) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final facility = data[index];
              return buildFacilityCard(context, facility);
            },
          );
        },
        onLoading: () => Center(child: CircularProgressIndicator()),
        onEmpty: () => const Center(
            child: Text(
         // trans().noHotel,
              "",
          style: TextStyle(color: CustomTheme.placeholderColor),
        )),
        showError: true,
        showEmpty: true,
      ),
    );
  }

  Widget buildFacilityCard(BuildContext context, Facility facility) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            hotelImage,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          facility.name,
          style: TextStyle(
            color: CustomTheme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              "${facility.desc} ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "${facility.status}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, color: CustomTheme.primaryColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDetailsPage(facility: facility),
            ),
          );
        },
      ),
    );
  }
}
