import 'package:bytelogik_task/featrues/counter/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final counter = ref.watch(counterProvider);
    final size = MediaQuery.of(context).size;
print("name in counter page is ${user},");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Counter Page"),
        centerTitle: true,
        actions: [
IconButton(
  icon: const Icon(Icons.logout),
  onPressed: () async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout Confirmation"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      ref.read(authProvider.notifier).logout();
      Navigator.pushReplacementNamed(context, '/login');
    }
  },
)

        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 12,
            shadowColor: Colors.black38,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.05, horizontal: size.width * 0.08),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(

                    'Welcome ${user?.name}',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Counter Value: $counter",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(counterProvider.notifier).increment(),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text("+1", style: TextStyle(fontSize: 18)),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(counterProvider.notifier).decrement(),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text("-1", style: TextStyle(fontSize: 18)),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(counterProvider.notifier).reset(),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child:
                            const Text("Reset", style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
