import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/event_card.dart';
import '../widgets/transaction_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../members/presentation/bloc/member_bloc.dart';
import '../../../auth/data/repositories/user_repository.dart';
import '../../../expenses/presentation/bloc/expense_bloc.dart';
import '../../../expenses/data/repositories/transaction_repository.dart';
import '../../../contacts/presentation/bloc/contact_bloc.dart';
import '../../../contacts/data/repositories/contact_repository.dart';
import '../../../contacts/data/models/contact_model.dart';
import '../../../events/presentation/bloc/event_bloc.dart';
import '../../../events/data/repositories/event_repository.dart';

class DashboardScreen extends StatefulWidget {
  final String userRole;
  const DashboardScreen({super.key, required this.userRole});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.userRole == 'admin';
    final screens = [
      HomeTab(isAdmin: isAdmin),
      ExpenditureTab(isAdmin: isAdmin),
      MembersTab(isAdmin: isAdmin),
      ContactsTab(isAdmin: isAdmin),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Society Manager'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: 'Expenditure'),
          NavigationDestination(icon: Icon(Icons.group), label: 'Members'),
          NavigationDestination(icon: Icon(Icons.contacts), label: 'Contacts'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final bool isAdmin;
  const HomeTab({super.key, required this.isAdmin});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ExpenseBloc(repository: TransactionRepository())..add(FetchTransactions())),
        BlocProvider(create: (_) => EventBloc(repository: EventRepository())..add(FetchEvents())),
      ],
      child: ListView(
        children: [
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              if (state is ExpenseLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ExpenseLoaded) {
                final balance = state.transactions.fold<double>(0.0, (sum, t) => t.type == 'Spent' ? sum - t.amount : sum + t.amount);
                return BalanceCard(balance: balance);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Upcoming Events', style: Theme.of(context).textTheme.titleMedium),
          ),
          BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EventLoaded) {
                final events = state.events;
                if (events.isEmpty) {
                  return const Center(child: Text('No upcoming events.'));
                }
                return Column(
                  children: [
                    ...events.map((e) => EventCard(
                          title: e.title,
                          date: e.date.toDate(),
                          description: e.description,
                        )),
                    if (isAdmin)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Show add event dialog
                          },
                          child: const Text('Add Event'),
                        ),
                      ),
                  ],
                );
              } else if (state is EventError) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

class MembersTab extends StatelessWidget {
  final bool isAdmin;
  const MembersTab({super.key, required this.isAdmin});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MemberBloc(userRepository: UserRepository())..add(FetchApprovedMembers()),
      child: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          if (state is MemberLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemberLoaded) {
            final members = state.members;
            if (members.isEmpty) {
              return const Center(child: Text('No approved members.'));
            }
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Members', style: Theme.of(context).textTheme.titleMedium),
                ),
                ...members.map((m) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(m.name),
                        subtitle: Text('Apartment: ${m.apartmentName}\nFlat: ${m.flatNumber}'),
                        trailing: isAdmin
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          final nameController = TextEditingController(text: m.name);
                                          final apartmentController = TextEditingController(text: m.apartmentName);
                                          final flatController = TextEditingController(text: m.flatNumber);
                                          final phoneController = TextEditingController(text: m.phone);
                                          return AlertDialog(
                                            title: const Text('Edit Member'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                                                TextField(controller: apartmentController, decoration: const InputDecoration(labelText: 'Apartment')),
                                                TextField(controller: flatController, decoration: const InputDecoration(labelText: 'Flat')),
                                                TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  BlocProvider.of<MemberBloc>(context).add(EditMember(
                                                    userId: m.id,
                                                    name: nameController.text,
                                                    apartmentName: apartmentController.text,
                                                    flatNumber: flatController.text,
                                                    phone: phoneController.text,
                                                  ));
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      BlocProvider.of<MemberBloc>(context).add(DeleteMember(m.id));
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),
                    )),
              ],
            );
          } else if (state is MemberError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class ExpenditureTab extends StatelessWidget {
  final bool isAdmin;
  const ExpenditureTab({super.key, this.isAdmin = false});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseBloc(repository: TransactionRepository())..add(FetchTransactions()),
      child: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpenseLoaded) {
            final transactions = state.transactions;
            final balance = transactions.fold<double>(0.0, (sum, t) => t.type == 'Spent' ? sum - t.amount : sum + t.amount);
            return ListView(
              children: [
                BalanceCard(balance: balance),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Transactions', style: Theme.of(context).textTheme.titleMedium),
                ),
                ...transactions.map((t) => TransactionCard(
                      type: t.type,
                      amount: t.amount,
                      date: t.date.toDate(),
                      description: t.description,
                    )),
                if (isAdmin)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Show add transaction dialog
                      },
                      child: const Text('Add Transaction'),
                    ),
                  ),
              ],
            );
          } else if (state is ExpenseError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class ContactsTab extends StatelessWidget {
  final bool isAdmin;
  const ContactsTab({super.key, this.isAdmin = false});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactBloc(repository: ContactRepository())..add(FetchContacts()),
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactLoaded) {
            final contacts = state.contacts;
            if (contacts.isEmpty) {
              return const Center(child: Text('No contacts found.'));
            }
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Useful Contacts', style: Theme.of(context).textTheme.titleMedium),
                ),
                ...contacts.map((c) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.contact_phone),
                        title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(c.role),
                        trailing: isAdmin
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          final nameController = TextEditingController(text: c.name);
                                          final roleController = TextEditingController(text: c.role);
                                          final phoneController = TextEditingController(text: c.phone);
                                          return AlertDialog(
                                            title: const Text('Edit Contact'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                                                TextField(controller: roleController, decoration: const InputDecoration(labelText: 'Role')),
                                                TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  BlocProvider.of<ContactBloc>(context).add(UpdateContact(
                                                    ContactModel(
                                                      id: c.id,
                                                      name: nameController.text,
                                                      role: roleController.text,
                                                      phone: phoneController.text,
                                                    ),
                                                  ));
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      BlocProvider.of<ContactBloc>(context).add(DeleteContact(c.id));
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),
                    )),
                if (isAdmin)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final nameController = TextEditingController();
                            final roleController = TextEditingController();
                            final phoneController = TextEditingController();
                            return AlertDialog(
                              title: const Text('Add Contact'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                                  TextField(controller: roleController, decoration: const InputDecoration(labelText: 'Role')),
                                  TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<ContactBloc>(context).add(AddContact(
                                      ContactModel(
                                        id: '',
                                        name: nameController.text,
                                        role: roleController.text,
                                        phone: phoneController.text,
                                      ),
                                    ));
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Add Contact'),
                    ),
                  ),
              ],
            );
          } else if (state is ContactError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
