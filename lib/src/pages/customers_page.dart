import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../helpers/general_helper.dart';
import '../models/company.dart';
import '../models/customer.dart';
import '../providers/companies/companies_provider.dart';
import '../providers/customer/customers_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/customer_item_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/view_widget.dart';

class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {

  Company company() => ref.read(companiesProvider.notifier).currentCompany()!;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(customersProvider(company()).notifier).fetch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final customersP = ref.watch(customersProvider(company()));

    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(trans().contacts),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(addIcon),
        onPressed: () => Navigator.pushNamed(context, Routes.customer, arguments: Customer.init()),
        label: Text(trans().newContact),
      ),
      body: ViewWidget<List<Customer>>(
        meta: customersP.meta,
        data: customersP.data,
        refresh: () async => await ref.read(customersProvider(company()).notifier)
            .fetch(reset: true),
        forceShowLoaded: customersP.data?.isNotEmpty ?? false,
        onLoaded: (customers) {
          return LazyLoadScrollView(
            onEndOfPage: () {
              if(!customersP.isLast()){
                ref.read(customersProvider(company()).notifier).fetch();
              }
            },
            child: RefreshIndicator(
              onRefresh: () async => await ref.read(customersProvider(company()).notifier)
                  .fetch(reset: true,),
              child: ListView.separated(
                itemCount: customers.length,
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CustomerItemWidget(
                        customer: customers[index],
                        canNavigate: true,
                      ),

                      if(!customersP.meta.isLast() && index == customers.length - 1)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: LoadingWidget(height: 100),
                        )
                      else if(index == customers.length - 1)
                        const SizedBox(height: 72,),
                    ],
                  );
                },
              ),
            ), // A subclass of `ScrollView`
          );
        },
      ),
    );
  }
}
