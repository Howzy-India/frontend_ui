part of '../main.dart';

class ApprovedProjectsView extends StatefulWidget {
  const ApprovedProjectsView({super.key, required this.builderService});

  final BuilderService builderService;

  @override
  State<ApprovedProjectsView> createState() => _ApprovedProjectsViewState();
}

class _ApprovedProjectsViewState extends State<ApprovedProjectsView> {
  final TextEditingController _searchController = TextEditingController();
  String _location = 'All Locations';
  String _type = 'All Types';
  String _segment = 'All Segments';
  String _possession = 'All Possessions';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: widget.builderService.watchApprovedBuilderProjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load projects: ${snapshot.error}'),
          );
        }

        final allItems = snapshot.data ?? [];
        final search = _searchController.text.trim().toLowerCase();
        final items = allItems.where((item) {
          final name = (item['name'] ?? '').toString().toLowerCase();
          final developer = (item['developerName'] ?? '')
              .toString()
              .toLowerCase();
          final city = (item['city'] ?? '').toString();
          final type = (item['projectType'] ?? 'Highraise').toString();
          final segment = (item['projectSegment'] ?? 'Luxury').toString();
          final possession = (item['possession'] ?? 'Under Construction')
              .toString();

          final matchesSearch =
              search.isEmpty ||
              name.contains(search) ||
              developer.contains(search);
          final matchesLocation =
              _location == 'All Locations' || city == _location;
          final matchesType = _type == 'All Types' || type == _type;
          final matchesSegment =
              _segment == 'All Segments' || segment == _segment;
          final matchesPossession =
              _possession == 'All Possessions' || possession == _possession;

          return matchesSearch &&
              matchesLocation &&
              matchesType &&
              matchesSegment &&
              matchesPossession;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Listed Projects',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search projects or developers...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFD8DEE9)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFD8DEE9)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Filters:',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                _filterDropdown(
                  value: _location,
                  values: ['All Locations', 'Hyderabad', 'Bangalore'],
                  onChanged: (value) => setState(() => _location = value),
                ),
                _filterDropdown(
                  value: _type,
                  values: ['All Types', 'Highraise', 'Gated', 'Standalone'],
                  onChanged: (value) => setState(() => _type = value),
                ),
                _filterDropdown(
                  value: _segment,
                  values: ['All Segments', 'Luxury', 'Premium', 'Mid range'],
                  onChanged: (value) => setState(() => _segment = value),
                ),
                _filterDropdown(
                  value: _possession,
                  values: ['All Possessions', 'Under Construction', 'RTMI'],
                  onChanged: (value) => setState(() => _possession = value),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD8DEE9)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'ID / RERA',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'PROJECT DETAILS',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'ATTRIBUTES',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: items.isEmpty
                          ? const Center(
                              child: Text('No projects match your filters.'),
                            )
                          : ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, index) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                final uniqueId =
                                    (item['uniqueId'] ?? 'HYD-00${index + 1}')
                                        .toString();
                                final rera =
                                    (item['reraNumber'] ?? 'P02400001234')
                                        .toString();
                                final projectType =
                                    (item['projectType'] ?? 'Highraise')
                                        .toString();
                                final segment =
                                    (item['projectSegment'] ?? 'Luxury')
                                        .toString();
                                final possession =
                                    (item['possession'] ?? 'Under Construction')
                                        .toString();

                                return Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              uniqueId,
                                              style: const TextStyle(
                                                color: Color(0xFF4F46E5),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'RERA: $rera',
                                              style: const TextStyle(
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name']?.toString() ??
                                                  'Untitled Project',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'By ${item['developerName'] ?? 'Unknown Developer'}',
                                              style: const TextStyle(
                                                color: Color(0xFF4338CA),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${item['location'] ?? ''}',
                                              style: const TextStyle(
                                                color: Color(0xFF475569),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: [
                                            _attributeChip(
                                              projectType.toUpperCase(),
                                              const Color(0xFFE2E8F0),
                                              const Color(0xFF64748B),
                                            ),
                                            _attributeChip(
                                              segment.toUpperCase(),
                                              const Color(0xFFFEF3C7),
                                              const Color(0xFFD97706),
                                            ),
                                            _attributeChip(
                                              possession.toUpperCase(),
                                              const Color(0xFFD1FAE5),
                                              const Color(0xFF059669),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _filterDropdown({
    required String value,
    required List<String> values,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8DEE9)),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox.shrink(),
        items: values
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (selected) {
          if (selected != null) {
            onChanged(selected);
          }
        },
      ),
    );
  }

  Widget _attributeChip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

class BuilderOnboardingView extends StatefulWidget {
  const BuilderOnboardingView({super.key, required this.builderService});

  final BuilderService builderService;

  @override
  State<BuilderOnboardingView> createState() => _BuilderOnboardingViewState();
}

class _BuilderOnboardingViewState extends State<BuilderOnboardingView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _developerController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationController = TextEditingController();
  final _reraController = TextEditingController();
  final _uniqueIdController = TextEditingController();
  final _uspController = TextEditingController();
  String _projectType = 'Highraise';
  PlatformFile? _agreementFile;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _developerController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    _reraController.dispose();
    _uniqueIdController.dispose();
    _uspController.dispose();
    super.dispose();
  }

  Future<void> _pickAgreementFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (!mounted || result == null || result.files.isEmpty) {
      return;
    }

    setState(() {
      _agreementFile = result.files.single;
    });
  }

  Future<void> _saveBuilder({required bool submitForApproval}) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_agreementFile == null || _agreementFile!.bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload agreement file.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
      final builderId = await widget.builderService.createBuilderDraft({
        'name': _nameController.text.trim(),
        'developerName': _developerController.text.trim(),
        'city': _cityController.text.trim(),
        'location': _locationController.text.trim(),
        'reraNumber': _reraController.text.trim(),
        'uniqueId': _uniqueIdController.text.trim(),
        'usp': _uspController.text.trim(),
        'projectType': _projectType,
        'createdByAdminUid': uid,
      });

      await widget.builderService.uploadAgreementBytes(
        builderId: builderId,
        bytes: _agreementFile!.bytes!,
        fileName: _agreementFile!.name,
        uploadedBy: uid,
        contentType: _agreementFile!.extension == 'pdf'
            ? 'application/pdf'
            : 'application/octet-stream',
      );

      if (submitForApproval) {
        await widget.builderService.submitForApproval(builderId);
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            submitForApproval
                ? 'Builder submitted for approval.'
                : 'Builder draft saved.',
          ),
        ),
      );

      _formKey.currentState!.reset();
      _nameController.clear();
      _developerController.clear();
      _cityController.clear();
      _locationController.clear();
      _reraController.clear();
      _uniqueIdController.clear();
      _uspController.clear();

      setState(() {
        _agreementFile = null;
        _projectType = 'Highraise';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $error')));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Builder Onboarding',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Project Name'),
                  validator: _required,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _developerController,
                  decoration: const InputDecoration(
                    labelText: 'Developer Name',
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'City'),
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                        validator: _required,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _reraController,
                        decoration: const InputDecoration(
                          labelText: 'RERA Number',
                        ),
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _uniqueIdController,
                        decoration: const InputDecoration(
                          labelText: 'Unique ID',
                        ),
                        validator: _required,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _projectType,
                  decoration: const InputDecoration(labelText: 'Project Type'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Highraise',
                      child: Text('Highraise'),
                    ),
                    DropdownMenuItem(value: 'Gated', child: Text('Gated')),
                    DropdownMenuItem(
                      value: 'Standalone',
                      child: Text('Standalone'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _projectType = value);
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _uspController,
                  decoration: const InputDecoration(labelText: 'USP'),
                  minLines: 2,
                  maxLines: 3,
                  validator: _required,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _submitting ? null : _pickAgreementFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Agreement'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _agreementFile?.name ?? 'No file selected',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilledButton.tonal(
                      onPressed: _submitting
                          ? null
                          : () => _saveBuilder(submitForApproval: false),
                      child: const Text('Save Draft'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: _submitting
                          ? null
                          : () => _saveBuilder(submitForApproval: true),
                      child: Text(
                        _submitting ? 'Submitting...' : 'Submit For Approval',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }
}

class AdminBuilderListView extends StatelessWidget {
  const AdminBuilderListView({super.key, required this.builderService});

  final BuilderService builderService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: builderService.watchBuilders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const Center(child: Text('No builders created yet.'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final status = item['onboardingStatus']?.toString() ?? 'draft';
            return Card(
              child: ListTile(
                title: Text(item['name']?.toString() ?? 'Untitled'),
                subtitle: Text(
                  '${item['city'] ?? ''} • ${item['developerName'] ?? ''} • $status',
                ),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () => _editBuilder(context, item),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    if (status != 'approved')
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () async {
                          await builderService.deleteBuilderIfUnapproved(
                            item['id'].toString(),
                          );
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _editBuilder(
    BuildContext context,
    Map<String, dynamic> builder,
  ) async {
    final nameController = TextEditingController(
      text: builder['name']?.toString() ?? '',
    );
    final cityController = TextEditingController(
      text: builder['city']?.toString() ?? '',
    );
    final locationController = TextEditingController(
      text: builder['location']?.toString() ?? '',
    );
    final uspController = TextEditingController(
      text: builder['usp']?.toString() ?? '',
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Builder'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Project Name'),
                ),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: uspController,
                  decoration: const InputDecoration(labelText: 'USP'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                await builderService.updateBuilder(builder['id'].toString(), {
                  'name': nameController.text.trim(),
                  'city': cityController.text.trim(),
                  'location': locationController.text.trim(),
                  'usp': uspController.text.trim(),
                });
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class SuperAdminUserManagementView extends StatelessWidget {
  const SuperAdminUserManagementView({super.key, required this.service});

  final UserManagementService service;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _showCreateUserDialog(context),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Create Admin/Agent'),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: service.watchManageableUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Failed to load users: ${snapshot.error}'),
                );
              }

              final users = snapshot.data ?? [];
              if (users.isEmpty) {
                return const Center(child: Text('No admin/agent users found.'));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final role = user['role']?.toString() ?? 'agent';
                  final disabled =
                      (user['status']?.toString() ?? 'active') == 'disabled';
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(role == 'admin' ? 'A' : 'G'),
                      ),
                      title: Text(
                        user['displayName']?.toString() ??
                            user['email']?.toString() ??
                            'Unknown',
                      ),
                      subtitle: Text(
                        '${user['email'] ?? ''} • $role • ${disabled ? 'disabled' : 'active'}',
                      ),
                      trailing: Wrap(
                        spacing: 6,
                        children: [
                          PopupMenuButton<String>(
                            tooltip: 'Change role',
                            onSelected: (value) => service.updateUserRole(
                              uid: user['uid'].toString(),
                              role: value,
                            ),
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'admin',
                                child: Text('Make Admin'),
                              ),
                              PopupMenuItem(
                                value: 'agent',
                                child: Text('Make Agent'),
                              ),
                            ],
                            child: const Icon(Icons.manage_accounts_outlined),
                          ),
                          IconButton(
                            tooltip: disabled ? 'Enable' : 'Disable',
                            onPressed: () => service.setUserDisabled(
                              uid: user['uid'].toString(),
                              disabled: !disabled,
                            ),
                            icon: Icon(
                              disabled
                                  ? Icons.lock_open_outlined
                                  : Icons.lock_outline,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete User',
                            onPressed: () =>
                                service.deleteUser(uid: user['uid'].toString()),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateUserDialog(BuildContext context) async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    String role = 'agent';

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name',
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Temporary Password',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: role,
                      items: const [
                        DropdownMenuItem(value: 'agent', child: Text('Agent')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => role = value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Role'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    await service.createAdminOrAgent(
                      email: emailController.text.trim(),
                      password: passwordController.text,
                      displayName: nameController.text.trim(),
                      role: role,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class BuilderApprovalQueueView extends StatelessWidget {
  const BuilderApprovalQueueView({super.key, required this.builderService});

  final BuilderService builderService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: builderService.watchPendingApprovals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load approvals: ${snapshot.error}'),
          );
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const Center(child: Text('No pending builder approvals.'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              child: ListTile(
                title: Text('Builder ID: ${item['entityId']}'),
                subtitle: Text(
                  'Requested by: ${item['requestedBy'] ?? 'unknown'}',
                ),
                trailing: Wrap(
                  spacing: 6,
                  children: [
                    FilledButton.tonal(
                      onPressed: () => builderService.rejectBuilder(
                        approvalId: item['id'].toString(),
                        remarks: 'Rejected by super admin',
                      ),
                      child: const Text('Reject'),
                    ),
                    FilledButton(
                      onPressed: () => builderService.approveBuilder(
                        approvalId: item['id'].toString(),
                        remarks: 'Approved',
                      ),
                      child: const Text('Approve'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
