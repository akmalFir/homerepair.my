import 'package:flutter/material.dart';
import 'package:home_repair_service/component/snack_bar_component.dart';

class ServiceCategoryComponent extends StatelessWidget {
  final String serviceCategory;
  final String imgPath;
  final Widget? page;
  final Color colors;

  const ServiceCategoryComponent({
    super.key,
    required this.serviceCategory,
    required this.imgPath,
    this.page,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          try {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page!));
          } on Exception catch (e) {
            SnackbarComponent.showSnackbar(context, e.toString());
          }
        } else {
          SnackbarComponent.showSnackbar(context, "Not Set Yet");
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        padding: const EdgeInsets.all(0),
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          color: colors,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: const Color(0xFF9471A5), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 70,
              width: 70,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                imgPath,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              serviceCategory,
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                color: Color(0xff000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
