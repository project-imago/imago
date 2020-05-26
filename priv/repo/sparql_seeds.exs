require Logger
query =
"""
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>

PREFIX img: <http://imago.pm/group/>
PREFIX imgt: <http://imago.pm/property/>

INSERT DATA {
  img:imago.pm imgt:type "instance".
  img:imago.pm imgt:allowed_properties imgt:theme.
  img:imago.pm imgt:allowed_properties imgt:location.

  imgt:location imgt:wd wdt:P276.
  imgt:location imgt:wdt wd:Q15642541.
}
"""
# query = "DROP ALL;"

query = %SPARQL.Query{query_string: query, form: :insert}

case SPARQL.Client.query(query,
                         "http://wdqs.imago.local:9999/bigdata/namespace/wdq/sparql/wdq/sparql",
                         request_method: :post,
                         protocol_version: "1.0",
                         operation: "update",
                         headers: %{"User-Agent" => "Imago/0.0.1 Dev (https://imago.pm/; contact@imago.pm) ImagoLib/0.0.1"}
) do
  {:ok, %{results: results}} ->
    IO.inspect(results)
  {:error, %{body: body}} ->
    IO.inspect(body)
end
