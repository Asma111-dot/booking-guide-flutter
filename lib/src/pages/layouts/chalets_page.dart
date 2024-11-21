import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../helpers/general_helper.dart';
import '../../providers/facility/facility_provider.dart';
import '../../utils/assets.dart';
import '../../utils/routes.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/view_widget.dart';
import '../../models/facility.dart';
import 'main_layout.dart';

class ChaletsPage extends ConsumerStatefulWidget {
  const ChaletsPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ChaletsPageState();
}

class _ChaletsPageState extends ConsumerState<ChaletsPage> {
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
        body: ViewWidget<List<Facility>>(
          meta: facilitiesState.meta,
          data: facilitiesState.data,
          onLoaded: (data) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final facility = data[index];
                final firstRoom =
                    facility.rooms.isNotEmpty ? facility.rooms.first : null;

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
                      borderRadius: BorderRadius.circular(10),
                      child: firstRoom != null && firstRoom.media.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: firstRoom.media.first.original_url,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Image.asset(
                              chaletImage,
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
                        const SizedBox(height: 4),
                        Text(
                          facility.desc,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (firstRoom != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Price: \$${firstRoom.pricePerNight}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          facility.status,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
          onLoading: () => const Center(child: CircularProgressIndicator()),
          onEmpty: () => const Center(
            child: Text(
              "",
              style: TextStyle(color: CustomTheme.placeholderColor),
            ),
          ),
          showError: true,
          showEmpty: true,
        ),
      ),
    );
  }
}

// class ChaletsPage extends ConsumerStatefulWidget {
//   const ChaletsPage({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState createState() => _ChaletsPageState();
// }
//
// class _ChaletsPageState extends ConsumerState<ChaletsPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: 2);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final facilitiesState = ref.watch(facilitiesProvider);
//
//     return MainLayout(
//       currentIndex: 0, // الصفحة الرئيسية
//       child: Scaffold(
//         appBar: CustomAppBar(
//           appTitle: trans().chalet,
//           icon: const FaIcon(Icons.arrow_back_ios),
//         ),
//         body: ViewWidget<List<Facility>>(
//           meta: facilitiesState.meta,
//           data: facilitiesState.data,
//           onLoaded: (data) {
//             return ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: data.length,
//               itemBuilder: (context, index) {
//                 final facility = data[index];
//                 final firstRoom =
//                 facility.rooms.isNotEmpty ? facility.rooms.first : null;
//
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 6,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(16),
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: firstRoom != null && firstRoom.media.isNotEmpty
//                           ? CachedNetworkImage(
//                         imageUrl: firstRoom.media.first.original_url,
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) =>
//                         const CircularProgressIndicator(),
//                         errorWidget: (context, url, error) =>
//                         const Icon(Icons.error),
//                       )
//                           : Image.asset(
//                         chaletImage,
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: Text(
//                       facility.name,
//                       style: TextStyle(
//                         color: CustomTheme.primaryColor,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         Text(
//                           facility.desc,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         if (firstRoom != null) ...[
//                           const SizedBox(height: 4),
//                           Text(
//                             'Price: \$${firstRoom.pricePerNight}',
//                             style: const TextStyle(
//                               color: Colors.green,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                         const SizedBox(height: 4),
//                         Text(
//                           facility.status,
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     onTap: () {
//                       Navigator.pushNamed(
//                         context,
//                         Routes.chaletDetails,
//                         arguments: facility,
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//           onLoading: () => const Center(child: CircularProgressIndicator()),
//           onEmpty: () => const Center(
//             child: Text(
//               "",
//               style: TextStyle(color: CustomTheme.placeholderColor),
//             ),
//           ),
//           showError: true,
//           showEmpty: true,
//         ),
//       ),
//     );
//   }
// }
//
