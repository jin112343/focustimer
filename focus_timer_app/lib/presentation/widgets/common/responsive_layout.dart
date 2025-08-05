import 'package:flutter/material.dart';
import '../../../core/utils/responsive_utils.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? ipad;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.ipad,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveUtils.isIPad(context)) {
          return ipad ?? tablet ?? mobile;
        } else if (ResponsiveUtils.isDesktop(context)) {
          return desktop ?? ipad ?? tablet ?? mobile;
        } else if (ResponsiveUtils.isTablet(context)) {
          return tablet ?? ipad ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? ResponsiveUtils.getContentWidth(context),
      height: height,
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      margin: margin ?? ResponsiveUtils.getContentMargin(context),
      decoration: decoration,
      child: child,
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getResponsiveGridColumns(context);
    
    return Padding(
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: runSpacing,
          childAspectRatio: ResponsiveUtils.getResponsiveAspectRatio(context),
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets? padding;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? ResponsiveUtils.getHorizontalPadding(context),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}

class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets? padding;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}

class ResponsiveListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveListView({
    super.key,
    required this.children,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: children.length,
      separatorBuilder: (context, index) => SizedBox(
        height: ResponsiveUtils.getResponsiveSpacing(context),
      ),
      itemBuilder: (context, index) => children[index],
    );
  }
}

class ResponsiveSafeArea extends StatelessWidget {
  final Widget child;
  final bool maintainBottomViewPadding;

  const ResponsiveSafeArea({
    super.key,
    required this.child,
    this.maintainBottomViewPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: ResponsiveSafeArea(child: body),
    );
  }
}

class ResponsiveAspectRatio extends StatelessWidget {
  final Widget child;
  final double? aspectRatio;

  const ResponsiveAspectRatio({
    super.key,
    required this.child,
    this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio ?? ResponsiveUtils.getResponsiveAspectRatio(context),
      child: child,
    );
  }
}

class ResponsiveExpanded extends StatelessWidget {
  final Widget child;
  final int flex;

  const ResponsiveExpanded({
    super.key,
    required this.child,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: child,
    );
  }
}

class ResponsiveFlexible extends StatelessWidget {
  final Widget child;
  final int flex;
  final FlexFit fit;

  const ResponsiveFlexible({
    super.key,
    required this.child,
    this.flex = 1,
    this.fit = FlexFit.loose,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: child,
    );
  }
}

// New iPad-specific layout widget
class IPadLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? maxWidth;

  const IPadLayout({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (!ResponsiveUtils.isIPad(context)) {
      return child;
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? ResponsiveUtils.getMaxContentWidth(context),
        ),
        padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
        margin: margin ?? ResponsiveUtils.getContentMargin(context),
        child: child,
      ),
    );
  }
}

// New responsive card widget for better iPad support
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
      padding: padding ?? EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context)),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(ResponsiveUtils.getResponsiveSpacing(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: elevation ?? ResponsiveUtils.getResponsiveSpacing(context),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
} 