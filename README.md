# helm-charts
Repository for storing and publishing helm charts

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

helm repo add tianping526 https://tianping526.github.io/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
tianping526` to see the charts.

To install the eventbridge chart:

    helm install my-eventbridge tianping526/eventbridge

To uninstall the chart:

    helm uninstall my-eventbridge
