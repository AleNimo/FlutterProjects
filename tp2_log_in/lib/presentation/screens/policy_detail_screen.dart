import 'package:flutter/material.dart';
import 'package:tp2_log_in/domain/policy.dart';
import 'package:tp2_log_in/data/policies_repository.dart';

class PolicyDetailScreen extends StatelessWidget {
  const PolicyDetailScreen({super.key, required this.policyId});

  final String policyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Policy Detail'),
      ),
      body: _PolicyDetailView(
        policy: policyList.firstWhere((policy) => policy.id == policyId),
      ),
    );
  }
}

//Podría pasar solo el id o el objeto de la pelicula
//Pasar el id hace que haya una doble busqueda en la lista, pero si la peli cambia no me queda el objeto desactualizado
//Tambien se pasa el id si la información es sensible
class _PolicyDetailView extends StatelessWidget {
  const _PolicyDetailView({
    required this.policy,
  });

  final Policy policy;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (policy.imageURL != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                policy.imageURL!,
                height: 400,
              ),
            )
          else
            const Icon(Icons.policy),
          Text(policy.name,
              style: textStyle
                  .titleLarge), //Se usa el estilo de materialApp para mantener el paradigma
          Text(policy.description, style: textStyle.bodyMedium),
          Text(policy.trainedEpisodes.toString(), style: textStyle.bodySmall),
        ],
      ),
    );
  }
}
