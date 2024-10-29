import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/company.dart';
import '../models/customer.dart' as m;
import '../providers/companies/companies_provider.dart';
import '../providers/customer/customer_provider.dart';
import '../widgets/back_button.dart';
import '../widgets/view_widget.dart';

class CustomerPage extends ConsumerStatefulWidget {
  final m.Customer customer;

  const CustomerPage({super.key, required this.customer});

  @override
  ConsumerState createState() => _CustomerPageState();
}

class _CustomerPageState extends ConsumerState<CustomerPage> {

  final customerFormKey = GlobalKey<FormState>();
  bool autoValidate = false;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(getProvider().notifier).fetch(customer: widget.customer);
    });
    super.initState();
  }

  CustomerProvider getProvider() => customerProvider(company(), widget.customer.id);

  Company company() => ref.read(companiesProvider.notifier).currentCompany()!;

  @override
  Widget build(BuildContext context) {

    final customerP = ref.watch(getProvider());
    bool isCreate = customerP.data?.isCreate() ?? true;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(isCreate ? trans().newContact : trans().contactDetails),
      ),
      body: ViewWidget<m.Customer>(
        meta: customerP.meta,
        data: customerP.data,
        refresh: () async => await ref.read(getProvider().notifier).fetch(),
        forceShowLoaded: customerP.data != null,
        onLoaded: (customer) {
          return Form(
            key: customerFormKey,
            autovalidateMode: autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: RefreshIndicator(
              onRefresh: () async => await ref.read(getProvider().notifier)
                  .fetch(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    //... Data
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
