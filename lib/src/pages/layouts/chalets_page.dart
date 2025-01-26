import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../filters/action_buttons_row.dart';
import '../../helpers/general_helper.dart';
import '../../providers/facility/facility_provider.dart';
import '../../utils/assets.dart';
import '../../utils/routes.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/map_dialog_widget.dart';
import '../../widgets/view_widget.dart';
import '../../models/facility.dart';
import 'main_layout.dart';

class ChaletsPage extends ConsumerStatefulWidget {
  const ChaletsPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ChaletsPageState();
}

class _ChaletsPageState extends ConsumerState<ChaletsPage> {

  void _showMapDialog(Facility facility, List<Facility> facilities) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MapDialog(
          facility: facility,
          facilities: facilities,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider);
    return MainLayout(
      currentIndex: 0,
      child: Scaffold(
        appBar: CustomAppBar(
          appTitle: trans().chalet,
          icon: const FaIcon(Icons.arrow_back_ios),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ActionButtonsRow(),
            ),
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
                      final firstRoom = facility.rooms.isNotEmpty
                          ? facility.rooms.first
                          : null;
                      final firstPrice =
                          firstRoom?.roomPrices.first.amount ?? 0.0;
                      // print("رابط الصورة: ${facility.logo}");

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              //imageUrl: facility.logo ?? '',
                              imageUrl: facility.logo?.isNotEmpty == true
                                  ? facility.logo!
                                  : '',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.asset(chaletImage, fit: BoxFit.cover),
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
                              Text(
                                firstPrice > 0
                                    ? '${trans().priceStartFrom} ${firstPrice}${trans().riyalY}'
                                    : '${trans().priceNotAvailable}',
                                style: TextStyle(
                                  color: firstPrice > 0
                                      ? Colors.amberAccent
                                      : Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                facility.address ?? '${trans().address}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.location_on_outlined),
                            onPressed: () {
                              _showMapDialog(facility, data);
                            },
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.chaletDetails,
                              arguments: facility,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                onLoading: () =>
                    const Center(child: CircularProgressIndicator()),
                onEmpty: () => Center(
                  child: Text(trans().no_data),
                ),
                showError: true,
                showEmpty: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
