import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../utils/app_links.dart';
import '../utils/translations.dart';
import '../providers/pretest_provider.dart';
import '../providers/language_provider.dart';
import 'webview_screen.dart';
import 'info_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _launchUrl(BuildContext context, String urlString, {String title = 'Materi', VoidCallback? onFormSubmitted}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: urlString, title: title, onFormSubmitted: onFormSubmitted),
      ),
    );
  }

  void _showLKPDSelector(BuildContext context, Map<String, String> t) {
    String? expandedClass;
    final Map<String, ExpansionTileController> controllers = {
      'Class D': ExpansionTileController(),
      'Class H': ExpansionTileController(),
      'Class J': ExpansionTileController(),
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t['lkpd_selector_title']!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildLKPDClassSection(
                            context, 'Class D', AppLinks.lkpdLinks['D']!, Colors.orange, controllers['Class D']!, t,
                            (isExpanded) {
                              if (isExpanded) {
                                setState(() {
                                  if (expandedClass != null && expandedClass != 'Class D') {
                                    controllers[expandedClass!]?.collapse();
                                  }
                                  expandedClass = 'Class D';
                                });
                              } else if (expandedClass == 'Class D') {
                                setState(() => expandedClass = null);
                              }
                            }
                          ),
                          _buildLKPDClassSection(
                            context, 'Class H', AppLinks.lkpdLinks['H']!, Colors.purple, controllers['Class H']!, t,
                            (isExpanded) {
                              if (isExpanded) {
                                setState(() {
                                  if (expandedClass != null && expandedClass != 'Class H') {
                                    controllers[expandedClass!]?.collapse();
                                  }
                                  expandedClass = 'Class H';
                                });
                              } else if (expandedClass == 'Class H') {
                                setState(() => expandedClass = null);
                              }
                            }
                          ),
                          _buildLKPDClassSection(
                            context, 'Class J', AppLinks.lkpdLinks['J']!, AppTheme.primaryGreen, controllers['Class J']!, t,
                            (isExpanded) {
                              if (isExpanded) {
                                setState(() {
                                  if (expandedClass != null && expandedClass != 'Class J') {
                                    controllers[expandedClass!]?.collapse();
                                  }
                                  expandedClass = 'Class J';
                                });
                              } else if (expandedClass == 'Class J') {
                                setState(() => expandedClass = null);
                              }
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildLKPDClassSection(
    BuildContext context, 
    String title, 
    List<String> links, 
    Color color,
    ExpansionTileController controller,
    Map<String, String> t,
    Function(bool) onExpansionChanged,
  ) {
    return ExpansionTile(
      controller: controller,
      onExpansionChanged: onExpansionChanged,
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      leading: Icon(Icons.group_work, color: color),
      children: links.asMap().entries.map((entry) {
        final groupLabel = '${t['lkpd_group']} ${entry.key + 1}';
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 32),
          title: Text(groupLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.open_in_new, size: 18, color: Colors.grey),
          onTap: () {
            Navigator.pop(context);
            _launchUrl(context, entry.value, title: '$title $groupLabel');
          },
        );
      }).toList(),
    );
  }

  void _handleMenuTap(BuildContext context, Map<String, dynamic> menu, Map<String, String> t) {
    if (menu['url'] != null) {
      _launchUrl(context, menu['url'] as String, title: menu['title'] as String);
    } else if (menu['action'] == 'lkpd') {
      _showLKPDSelector(context, t);
    } else if (menu['action'] == 'info') {
      Navigator.push(context, MaterialPageRoute(builder: (c) => const InfoScreen()));
    } else if (menu['action'] == 'chat') {
      Navigator.push(context, MaterialPageRoute(builder: (c) => const ChatScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${menu['title']} ${t['coming_soon']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final t = Translations.of(language.code);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final List<Map<String, dynamic>> menus = [
      {
        'title': t['menu_intro'],
        'subtitle': t['menu_intro_sub'],
        'icon': Icons.public,
        'color': isDark ? AppTheme.primaryBlue : Colors.blue[600],
      },
      {
        'title': t['menu_pretest'],
        'subtitle': t['menu_pretest_sub'],
        'icon': Icons.assignment_outlined,
        'color': Colors.orange[600],
        'url': AppLinks.pretest,
      },
      {
        'title': t['menu_book'],
        'subtitle': t['menu_book_sub'],
        'icon': Icons.menu_book_rounded,
        'color': isDark ? AppTheme.primaryGreen : Colors.green[600],
      },
      {
        'title': t['menu_studi'],
        'subtitle': t['menu_studi_sub'],
        'icon': Icons.analytics_outlined,
        'color': Colors.redAccent,
      },
      {
        'title': t['menu_simulasi'],
        'subtitle': t['menu_simulasi_sub'],
        'icon': Icons.precision_manufacturing_outlined,
        'color': Colors.teal,
        'url': AppLinks.simulation,
      },
      {
        'title': t['menu_lkpd'],
        'subtitle': t['menu_lkpd_sub'],
        'icon': Icons.group_work_outlined,
        'color': Colors.deepOrange,
        'action': 'lkpd',
      },
      {
        'title': t['menu_posttest'],
        'subtitle': t['menu_posttest_sub'],
        'icon': Icons.assignment_turned_in_outlined,
        'color': Colors.indigo,
        'url': AppLinks.posttest,
        'requiresPretest': true,
      },
      {
        'title': t['menu_info'],
        'subtitle': t['menu_info_sub'],
        'icon': Icons.info_outline,
        'color': Colors.blueGrey,
        'action': 'info',
      },
      {
        'title': t['menu_tutor'],
        'subtitle': t['menu_tutor_sub'],
        'icon': Icons.smart_toy_outlined,
        'color': const Color(0xFF2C5364),
        'action': 'chat',
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          const DynamicHeaderWidget(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final menu = menus[index];
                  final isPretestFinished = ref.watch(pretestStatusProvider);
                  final isLocked = menu['requiresPretest'] == true && !isPretestFinished;

                  Widget card = MenuCard(
                    title: menu['title'] as String,
                    subtitle: menu['subtitle'] as String,
                    icon: isLocked ? Icons.lock : menu['icon'] as IconData,
                    color: isLocked ? Colors.grey : menu['color'] as Color,
                    onTap: () {
                      if (isLocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t['pretest_warning']!)),
                        );
                        return;
                      }
                      
                      if (menu['title'] == t['menu_pretest']) {
                        _launchUrl(context, menu['url'] as String, title: menu['title'] as String, onFormSubmitted: () {
                          ref.read(pretestStatusProvider.notifier).setCompleted();
                        });
                        return;
                      }

                      _handleMenuTap(context, menu, t);
                    },
                  );

                  if (isLocked) {
                     card = Opacity(opacity: 0.6, child: card);
                  }

                  return card.animate().fadeIn(delay: Duration(milliseconds: 50 * index))
                   .slideY(begin: 0.15, duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
                },
                childCount: menus.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}

const List<Map<String, String>> dailyInsightsList = [
  {'icon': '🌳', 'text': 'Hutan hujan bisa berubah menjadi sabana jika terus mengalami kekeringan.'},
  {'icon': '🍃', 'text': 'Daun tanaman bisa "stres" saat suhu terlalu tinggi.'},
  {'icon': '🌊', 'text': 'Rumput laut bisa mati jika suhu air naik sedikit saja.'},
  {'icon': '🐝', 'text': 'Lebah kesulitan mencari bunga karena perubahan musim.'},
  {'icon': '🌸', 'text': 'Tanaman bisa berbunga lebih cepat dari biasanya.'},
  {'icon': '🐢', 'text': 'Penyu bergantung pada suhu pasir untuk menentukan jenis kelamin.'},
  {'icon': '🐦', 'text': 'Burung bermigrasi lebih awal karena perubahan suhu.'},
  {'icon': '🌾', 'text': 'Tanah bisa kehilangan kesuburan karena panas berlebih.'},
  {'icon': '🌧️', 'text': 'Hujan ekstrem bisa merusak ekosistem darat.'},
  {'icon': '🌲', 'text': 'Pohon yang mati bisa melepaskan karbon kembali ke atmosfer.'},
  {'icon': '🐠', 'text': 'Air yang lebih hangat mengandung lebih sedikit oksigen.'},
  {'icon': '🐙', 'text': 'Banyak hewan laut sensitif terhadap perubahan suhu kecil.'},
  {'icon': '🪨', 'text': 'Lumut dan organisme kecil bisa hilang tanpa disadari.'},
  {'icon': '🐘', 'text': 'Hewan besar kesulitan beradaptasi dengan cepat.'},
  {'icon': '🌿', 'text': 'Ekosistem butuh waktu lama untuk pulih setelah rusak.'},
  {'icon': '🐧', 'text': 'Es mencair membuat hewan kutub kehilangan tempat berburu.'},
  {'icon': '🦋', 'text': 'Serangga berubah pola hidup karena suhu meningkat.'},
  {'icon': '🌻', 'text': 'Beberapa tanaman tidak bisa tumbuh di iklim baru.'},
  {'icon': '🐍', 'text': 'Reptil sangat bergantung pada suhu lingkungan.'},
  {'icon': '🌊', 'text': 'Arus laut berubah dan memengaruhi kehidupan laut.'},
  {'icon': '🐟', 'text': 'Terumbu karang adalah rumah bagi ribuan spesies laut.'},
  {'icon': '🌴', 'text': 'Hutan bakau melindungi pantai dari abrasi dan badai.'},
  {'icon': '🐬', 'text': 'Suara laut berubah karena aktivitas manusia dan suhu.'},
  {'icon': '🐾', 'text': 'Hewan berpindah ke tempat lebih dingin untuk bertahan.'},
  {'icon': '🌱', 'text': 'Tumbuhan liar bisa kalah bersaing dengan spesies invasif.'},
  {'icon': '🐜', 'text': 'Serangga bisa berkembang lebih cepat di suhu hangat.'},
  {'icon': '🌾', 'text': 'Panen bisa gagal karena perubahan musim tanam.'},
  {'icon': '🐦', 'text': 'Habitat burung bisa hilang karena deforestasi dan iklim.'},
  {'icon': '🌊', 'text': 'Air laut yang asam merusak rantai makanan laut.'},
  {'icon': '🐡', 'text': 'Beberapa spesies laut bisa punah tanpa terlihat.'},
  {'icon': '🌲', 'text': 'Hutan tropis menyimpan karbon dalam jumlah besar.'},
  {'icon': '🌵', 'text': 'Tanaman gurun bisa meluas ke wilayah baru.'},
  {'icon': '🐺', 'text': 'Predator bisa kehilangan mangsa karena perubahan ekosistem.'},
  {'icon': '🌼', 'text': 'Penyerbukan terganggu jika serangga berkurang.'},
  {'icon': '🐚', 'text': 'Cangkang hewan laut melemah karena air yang lebih asam.'},
  {'icon': '🌿', 'text': 'Ekosistem yang seimbang bisa runtuh karena perubahan kecil.'},
  {'icon': '🐾', 'text': 'Rantai makanan bisa terganggu dari satu perubahan saja.'},
  {'icon': '🌍', 'text': 'Kehilangan satu spesies bisa berdampak ke banyak spesies lain.'},
  {'icon': '🌱', 'text': 'Alam bisa beradaptasi, tapi butuh waktu yang lama.'},
  {'icon': '🌳', 'text': 'Menjaga ekosistem berarti menjaga keseimbangan bumi.'},
];

class DynamicHeaderWidget extends ConsumerWidget {
  const DynamicHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final t = Translations.of(lang.code);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return SliverAppBar(
      expandedHeight: 400.0,
      toolbarHeight: 70.0,
      collapsedHeight: 70.0,
      floating: false,
      pinned: true,
      centerTitle: false,
      titleSpacing: 24.0,
      backgroundColor: isDark ? const Color(0xFF061616) : const Color(0xFF006A6A),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.blur_circular, color: isDark ? AppTheme.surfaceTint.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.9), size: 24),
          const SizedBox(width: 8),
          Text(
            t['app_title'] ?? "EcoThermal",
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms),
      actions: [
        _buildActionButton(
          icon: Icons.language,
          color: Colors.white,
          label: lang.code.toUpperCase(),
          onPressed: () => ref.read(languageProvider.notifier).toggleLanguage(),
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: isDark ? Icons.nights_stay : Icons.wb_sunny_rounded,
          color: isDark ? Colors.blue[300]! : Colors.amberAccent,
          onPressed: () {
            ref.read(themeModeProvider.notifier).state = 
                isDark ? ThemeMode.light : ThemeMode.dark;
          },
          isDark: isDark,
        ),
        const SizedBox(width: 24),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Deep gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark ? const [
                    Color(0xFF021111),
                    Color(0xFF0A2424),
                    Color(0xFF051820),
                  ] : const [
                    Color(0xFF006A6A),
                    Color(0xFF008989),
                    Color(0xFF004D4D),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            
            // Abstract Earth Glow / Heat wave
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.deepOrange.withValues(alpha: isDark ? 0.15 : 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .scaleXY(begin: 1.0, end: 1.2, duration: 4.seconds, curve: Curves.easeInOut)
               .fade(begin: 0.6, end: 1.0, duration: 4.seconds),
            ),
            Positioned(
              bottom: 0,
              left: -100,
              child: Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient: RadialGradient(
                    colors: [
                      isDark ? const Color(0xFF004D4D).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .slideX(begin: 0, end: 0.1, duration: 5.seconds)
               .fade(begin: 0.5, end: 0.8, duration: 3.seconds),
            ),

            // Particles
            ...List.generate(6, (index) {
              return Positioned(
                left: 60.0 * index + 20,
                top: 150.0 + (index * 40 % 100),
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: isDark ? 0.4 : 0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.white.withValues(alpha: isDark ? 0.8 : 1.0), blurRadius: 4)
                    ]
                  ),
                ).animate(onPlay: (controller) => controller.repeat())
                 .moveY(begin: 0, end: -120, duration: Duration(seconds: 4 + index))
                 .fade(begin: 1.0, end: 0.0, duration: Duration(seconds: 4 + index)),
              );
            }),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 72), // Push down to clear SliverAppBar
                    Expanded(
                      child: PageView.builder(
                        itemCount: dailyInsightsList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final insight = dailyInsightsList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 56, right: 4, left: 4),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.lightbulb_outline_rounded, 
                                          color: isDark ? AppTheme.surfaceTint : Colors.white, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Daily Insight",
                                          style: TextStyle(
                                            color: isDark ? AppTheme.surfaceTint : Colors.white.withValues(alpha: 0.95),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.amberAccent.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.3)),
                                      ),
                                      child: Text(
                                        "Oh, ternyata!",
                                        style: TextStyle(
                                          color: isDark ? Colors.amberAccent : Colors.amberAccent.shade100,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        insight['icon']!,
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                    ).animate().scale(delay: 100.ms, curve: Curves.easeOutBack, duration: 600.ms),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        insight['text']!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          height: 1.4,
                                          letterSpacing: 0.2,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Swipe for more",
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.6),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_rounded, 
                                      color: Colors.white.withValues(alpha: 0.6), size: 14)
                                      .animate(onPlay: (c) => c.repeat(reverse: true))
                                      .slideX(begin: 0, end: 0.5, duration: 800.ms),
                                  ],
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    String? label,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.4)),
      ),
      child: IconButton(
        icon: label != null 
          ? Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10))
          : Icon(icon, key: ValueKey(icon), color: color, size: 24)
              .animate(key: ValueKey(icon))
              .rotate(begin: 0.5, end: 0, duration: 400.ms, curve: Curves.easeOutBack)
              .scaleXY(begin: 0.5, end: 1.0, duration: 400.ms, curve: Curves.easeOutBack),
        onPressed: onPressed,
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.15 : 0.08),
            color.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.2 : 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: color.withValues(alpha: 0.2),
          highlightColor: color.withValues(alpha: 0.1),
          child: Stack(
            children: [
              Positioned(
                right: -24,
                bottom: -24,
                child: Icon(
                  icon,
                  size: 120,
                  color: color.withValues(alpha: isDark ? 0.15 : 0.1),
                ).animate(onPlay: (c) => c.repeat(reverse: true))
                 .scaleXY(begin: 1.0, end: 1.05, duration: 3.seconds)
                 .rotate(begin: 0, end: 0.02, duration: 4.seconds),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 32,
                          color: color,
                        ),
                      ).animate().scaleXY(
                            begin: 0.8,
                            end: 1.0,
                            curve: Curves.easeOutBack,
                            duration: 500.ms,
                          )
                       .then()
                       .animate(onPlay: (c) => c.repeat(reverse: true))
                       .moveY(begin: -2.5, end: 2.5, duration: 1500.ms, curve: Curves.easeInOutSine),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
