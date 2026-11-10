import 'package:flutter/material.dart';
import 'package:ai_assistant/domain/responsive.dart';
import 'package:ai_assistant/presentation/uiKit/colors.dart';
import 'package:ai_assistant/presentation/uiKit/custom_footer.dart';

// Каркас всех экранов:
//  * шапка всегда закреплена вверху и стоит на одном и том же месте на любом экране;
//  * контент прокручивается под шапкой;
//  * футер прижат к нижней части экрана (или идёт сразу за контентом, если он длиннее экрана).
// Если scroll == false, контент занимает всю доступную высоту (например, окно чата).
class AppScaffold extends StatelessWidget {
  final Widget header;
  final Widget child;
  final bool scroll;
  final bool showFooter;
  final double headerDividerWidth;

  const AppScaffold({super.key, required this.header, required this.child, this.scroll = true, this.showFooter = true, this.headerDividerWidth = 856});

  @override
  Widget build(BuildContext context) {
    final compact = isCompact(context);
    final hPad = pageHPadding(context);

    final body = scroll
        ? CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, compact ? 16 : 32, hPad, 0),
                  child: child,
                ),
              ),
              if (showFooter)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, compact ? 12 : 24),
                    child: const Align(alignment: Alignment.bottomCenter, child: CustomFooter()),
                  ),
                ),
            ],
          )
        : Padding(
            padding: EdgeInsets.fromLTRB(hPad, compact ? 12 : 24, hPad, compact ? 8 : 24),
            child: Column(children: [Expanded(child: child), if (showFooter) const CustomFooter()]),
          );

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                // Шапка фиксированной высоты — на всех экранах в одной и той же позиции
                Padding(
                  padding: EdgeInsets.fromLTRB(hPad, compact ? 12 : 28, hPad, 0),
                  child: SizedBox(height: 40, child: Center(child: header)),
                ),
                const SizedBox(height: 10),
                Container(constraints: BoxConstraints(maxWidth: headerDividerWidth), margin: EdgeInsets.symmetric(horizontal: hPad), height: 1, color: borderLight),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
