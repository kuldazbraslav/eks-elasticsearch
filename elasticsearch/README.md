
# Elasticsearch Helm Chart

This Helm chart deploys Elasticsearch on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- charts [elastic-operator](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-install-helm.html) and [cert-manager](https://cert-manager.io/docs/installation/helm/)

## Installing the Chart

To install the chart with the release name `my-release`:


helm install my-release .


## Configuration

The following table lists the configurable parameters of the Elasticsearch chart and their default values.

| Parameter | Description | Default Value |
|-----------|-------------|---------------|
| `storageClass.create` | Create a custom StorageClass | `true` |
| `storageClass.name` | Name of the StorageClass | `""` (empty string) |
| `storageClass.provisioner` | StorageClass provisioner | `ebs.csi.aws.com` |
| `storageClass.parameters` | StorageClass parameters | See values.yaml |
| `elasticsearch.version` | Elasticsearch version | `8.14.3` |
| `elasticsearch.nodeSets[*].name` | Name of the node set | `default` |
| `elasticsearch.nodeSets[*].count` | Number of nodes in the set | `3` |
| `elasticsearch.nodeSets[*].storage` | Storage size per node | `5Gi` |
| `elasticsearch.nodeSets[*].resources` | Resource of the pod | See values.yaml |
| `elasticsearch.nodeSets[*].affinity` | Node affinity rules | See values.yaml |
| `elasticsearch.nodeSets[*].tolerations` | Node tolerations | See values.yaml |

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:


helm delete my-release

## Security

This chart implements basic authentication and TLS encryption. For production use, please review and adjust the security settings according to your requirements.

## Support

For any issues or questions, please file an issue in the GitHub repository.
