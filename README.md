# Render [Notion.so](notion.so) code blocks via [kroki.io](kroki.io)

This is a little bridge service allowing to render a Notion.so code block via kroki.io. This means you can easily generate an embedable image from your PlantUML, Graphviz etc. code.

To use this obtain the `blockId` of your Notion code block, that is copy the link of a block and keep everything after the `#`.

The first line in the code block should contain `#kroki type=plantuml` where `plantuml` is any of the diagram types kroki.io supports.

Then construct an URL such as `https://<bridgeServiceEndpoint>/<blockId>.<format>`. `<format>` defaults to `svg` and can be any of `kroki.io`'s supported image formats.

With much inspiration from [notion-plantuml](https://github.com/rnovicky/notion-plantuml).

## Deploy using helm

Once Helm has been set up correctly, add the repo as follows:

  helm repo add notion-kroki-bridge https://watergenics.github.io/notion-kroki-bridge

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
notion-kroki-bridge` to see the charts.

To install the notion-kroki-bridge chart:

    helm install --set "notionApiToken=xxxx" my-notion-kroki-bridge notion-kroki-bridge/notion-kroki-bridge

To uninstall the chart:

    helm delete my-notion-kroki-bridge

## Release

1. Bump version in charts/notion-kroki-bridge/Chart.yaml
2. Commit and create a matching git tag, `git tag v0.1.0`
3. Push
