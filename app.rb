require "hobby"
require "net/http"
require "uri"
require "json"

class App
  include Hobby
  TYPES = %w[
    plantuml c4plantuml ditaa blockdiag seqdiag actdiag nwdiag packetdiag rackdiag
    umlet graphviz dot erd svgbob nomnoml mermaid vega vegalite wavedrom bpmn bytefield
    excalidraw pikchr structurizr diagramsnet
  ]
  FORMATS = %w[svg png jpeg pdf base64]

  get "/" do
    "Usage: /block_id.format. Read more at https://github.com/watergenics/notion-kroki-bridge."
  end

  get "/:block_id(?:.:format)?" do
    response = fetch_block(my[:block_id])
    return unless response

    meta, code = find_code(response)
    type = find_type(meta, response)
    format = my[:format]
    format = "svg" unless FORMATS.include? format

    response = fetch_image(type, format, code)
    self.response.headers["Content-Type"] = response.header["Content-Type"]
    response.body
  end

  def fetch_block(block_id)
    json = Net::HTTP.get(URI("https://api.notion.com/v1/blocks/#{block_id}"), {
      "Notion-Version" => "2022-02-22", "Authorization" => "Bearer #{ENV["NOTION_API_TOKEN"]}"
    })

    response = JSON.parse(json)
    return unless response["type"] == "code"

    response
  end

  def find_code(response)
    meta = {}
    code = response.dig("code", "rich_text", 0, "plain_text")
    if code.lines.first.start_with?("#kroki")
      meta, *code = code.lines
      _, *tags = meta.split
      meta = tags.map {|tag| tag.split("=") }.to_h
      code = code.join("\n")
    end

    [meta, code]
  end

  def find_type(meta, response)
    type = response.dig("code", "language")
    return type if TYPES.include? type

    type = meta["type"]
    TYPES.include?(type) ? type : "plantuml"
  end

  def fetch_image(type, format, code)
    Net::HTTP.post(URI("https://kroki.io/#{type}/#{format}"), code, { "Content-Type": "text/plain" })
  end
end
