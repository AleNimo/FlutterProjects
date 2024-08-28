import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tp2_log_in/domain/policy.dart';
import 'package:tp2_log_in/data/policies_repository.dart';

class PoliciesScreen extends StatelessWidget {
  PoliciesScreen({super.key, required this.userName});

  final String userName;
  final List<Policy> policies = policyList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido $userName. Seleccione una Política'),
      ),
      body: _PoliciesView(
        policies: policies,
      ),
    );
  }
}

class _PoliciesView extends StatelessWidget {
  const _PoliciesView({required this.policies});

  final List<Policy> policies;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //ListViewBuilder sirve para listas dinamicas, ya tiene función de scroll, etc
      itemCount: 4,
      itemBuilder: (context, index) {
        //Vendría a ser una especie de forEach que recorre todos los elementos y retorna un widget para cada item
        return _PolicyItem(policy: policies[index]);
      },
    );
  }
}

class _PolicyItem extends StatelessWidget {
  const _PolicyItem({
    required this.policy,
  });

  final Policy policy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Widget que permite agregar gestos a widgets que no lo tienen
      onTap: () {
        context.push('/policyDetail/${policy.id}');
      },
      child: Card(
        child: ListTile(
          leading: policy.imageURL != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(policy.imageURL!),
                )
              : const Icon(Icons.network_cell),
          title: Text(policy.name),
          subtitle: Text(policy.description),
          trailing: const Icon(Icons.arrow_forward),
          // onTap: () {
          //   context.push('/policyDetail/${policy.id}');
          // },
        ),
      ),
    );
  }
}
