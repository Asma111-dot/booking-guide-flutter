import 'package:flutter/material.dart';
import '../helpers/general_helper.dart';
import '../utils/assets.dart';
import '../widgets/custom_app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        appTitle: trans().policies,
        icon: arrowBackIcon,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            privacyPolicyContent,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

const String privacyPolicyContent = '''
سياسة الخصوصية – تطبيق حجوزاتي

نحن في تطبيق "حجوزاتي" نهتم بخصوصيتك وملتزمون بحماية معلوماتك الشخصية. توضح هذه السياسة كيفية جمعنا واستخدامنا وحمايتنا للبيانات عند استخدامك لخدماتنا.

🔹 المعلومات التي نقوم بجمعها:
- الاسم الكامل.
- رقم الهاتف.
- عنوان البريد الإلكتروني.
- معلومات الحجز (المنشأة، التاريخ، الوقت).
- تفاصيل الدفع (مثل إثبات العربون).

🔹 كيف نستخدم هذه المعلومات؟
- لتمكينك من تصفح وحجز الفنادق والشاليهات المتوفرة.
- لإظهار الأوقات المتاحة للحجز.
- لإرسال إشعارات تأكيد الحجز والتحديثات.
- لتحسين تجربة المستخدم وتقديم دعم فني فعّال.
- لتأمين عملية الدفع بشكل آمن وسلس.

🔹 حماية البيانات:
- يتم حفظ بياناتك في خوادم مؤمنة وفقًا لأعلى معايير الأمان.
- لا تتم مشاركة بياناتك مع أي طرف ثالث بدون إذن صريح منك.
- نستخدم تقنيات تشفير وتحديثات دورية لحماية المعلومات من أي وصول غير مصرح به.

🔹 حقوق المستخدم:
- يمكنك في أي وقت تعديل أو حذف معلوماتك.
- يحق لك طلب نسخة من بياناتك المحفوظة لدينا.
- لديك الحرية في إلغاء الحساب أو الحذف النهائي للبيانات عند الطلب.

🔹 القبول:
باستخدامك لتطبيق "حجوزاتي"، فإنك توافق على جميع الشروط المذكورة في هذه السياسة. قد نقوم بتحديث هذه السياسة من وقت لآخر، وسيتم إشعارك بأي تغييرات.

لأي استفسار أو طلب متعلق بالخصوصية، يمكنك التواصل معنا عبر صفحة الدعم.

نحن نعتز بثقتك، ونعمل باستمرار على تقديم خدمة آمنة ومريحة.
''';
