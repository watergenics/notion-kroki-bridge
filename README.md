# Render [Notion.so](notion.so) code blocks via [kroki.io](kroki.io)

This is a little bridge service allowing to render a Notion.so code block via kroki.io. This means you can easily generate an embedable image from your PlantUML, Graphviz etc. code.

To use this obtain the `blockId` of your Notion code block, that is copy the link of a block and keep everything after the `#`.

The first line in the code block should contain `#kroki type=plantuml` where `plantuml` is any of the diagram types kroki.io supports.

Then construct an URL such as `https://<bridgeServiceEndpoint>/<blockId>.<format>`. `<format>` defaults to `svg` and can be any of `kroki.io`'s supported image formats.

With much inspiration from [notion-plantuml](https://github.com/rnovicky/notion-plantuml).
