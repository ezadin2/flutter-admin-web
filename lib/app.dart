import 'package:adminpanel/common/widgets/layouts/templates/site_layout.dart';
import 'package:adminpanel/common/widgets/responsive/responsive_design.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/widgets/containers/rounded_container.dart';
import 'utils/constants/colors.dart';
import 'utils/constants/text_strings.dart';
import 'utils/device/web_material_scroll.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      home: ResponsiveDesign(),
    );
  }
}

class ResponsiveDesign extends StatelessWidget {
  const ResponsiveDesign({super.key});
  @override
  Widget build(BuildContext context) {
    return TSiteTemplate( desktop: Desktop(),mobile: Mobile(),tablet: Tablet(),);
  }
}

class Desktop extends StatelessWidget {
  const Desktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: TRoundedContainer(
              height: 450,
              backgroundColor: Colors.blue.withOpacity(0.2),
              child: Center(child: Text('Box 1')),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: TRoundedContainer(
              height: 450,
              backgroundColor: Colors.blue.withOpacity(0.2),
              child: Center(child: Text('Box 2')),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: TRoundedContainer(
              height: 215,
              backgroundColor: Colors.blue.withOpacity(0.2),
              child: Center(child: Text('Box 3')),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: TRoundedContainer(
              height: 215,
              backgroundColor: Colors.blue.withOpacity(0.2),
              child: Center(child: Text('Box 4')),
            ),
          ),
        ]),
      ],
    );
  }
}

class Tablet extends StatelessWidget {
  const Tablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(
              children: [
                TRoundedContainer(
                  height: 450,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: Center(
                    child: Text('Box 1'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                TRoundedContainer(
                  height: 215,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: Center(child: Text('Box 2')),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                TRoundedContainer(
                  height: 450,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: Center(child: Text('Box 3')),
                ),
              ],
            ),
          ),
        ]),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TRoundedContainer(
              height: 190,
              width: double.infinity,
              backgroundColor: Colors.red.withOpacity(0.2),
              child: Center(
                child: Text('Box 5'),
              ),
            ),
            SizedBox(height: 20),
            TRoundedContainer(
              height: 190,
              width: double.infinity,
              backgroundColor: Colors.red.withOpacity(0.2),
              child: Center(
                child: Text("Box 6"),
              ),
            )
          ],
        )
      ],
    );
  }
}

class Mobile extends StatelessWidget {
  const Mobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TRoundedContainer(
          height: 450,
          width: double.infinity,
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: Center(
            child: Text('Box 1'),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TRoundedContainer(
          height: 215,
          width: double.infinity,
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: Center(child: Text('Box 2')),
        ),
        SizedBox(
          height: 20,
        ),
        TRoundedContainer(
          height: 215,
          width: double.infinity,
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: Center(child: Text('Box 3')),
        ),
        SizedBox(
          height: 20,
        ),
        TRoundedContainer(
          height: 215,
          width: double.infinity,
          backgroundColor: Colors.red.withOpacity(0.2),
          child: Center(
            child: Text('Box 4'),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TRoundedContainer(
          height: 215,
          width: double.infinity,
          backgroundColor: Colors.red.withOpacity(0.2),
          child: Center(
            child: Text("Box 5"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TRoundedContainer(
          height: 215,
          width: double.infinity,
          backgroundColor: Colors.red.withOpacity(0.2),
          child: Center(
            child: Text("Box 6"),
          ),
        ),
      ],
    );
  }
}
