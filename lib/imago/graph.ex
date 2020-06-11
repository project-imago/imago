defmodule Imago.Graph do
  require Logger

  def endpoint() do
    Application.fetch_env!(:imago, Imago.Graph)[:endpoint]
  end

  def create(data) do
    """ 
    INSERT DATA {
      #{RDF.NTriples.write_string(data)}
    }
    """
    |> query_update()
  end

  def wikidata_query(wd_id) do
    """
    PREFIX wd: <http://www.wikidata.org/entity/>
    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX wikibase: <http://wikiba.se/ontology#>
    PREFIX mwapi: <https://www.mediawiki.org/ontology#API/>
    PREFIX schema: <http://schema.org/>

    SELECT ?itemLabel ?itemDescription ?p ?propLabel ?obj ?objLabel
    WHERE {
      SERVICE <https://query.wikidata.org/sparql> {
        hint:Query hint:optimizer "None".
        ?item ?p ?obj .
        ?prop wikibase:directClaim ?p .
        FILTER ( ?p in ( wdt:P30, wdt:P279, wdt:P131, wdt:P150, wdt:P361, wdt:P527) )
        SERVICE wikibase:label { bd:serviceParam wikibase:language "fr,en".
          ?item rdfs:label ?itemLabel.
          ?item schema:description ?itemDescription.
          ?prop rdfs:label ?propLabel.
          ?obj rdfs:label ?objLabel.
        }
      }
      BIND (wd:#{wd_id} AS ?item)
    }
    """
    |> query()
  end

  def get_remote_from_wikidata(wd_id) do
    case wikidata_query(wd_id) do
      {:error, _} ->
        :error
      {:ok, %SPARQL.Query.Result{results: []}} ->
        :error
      {:ok, %SPARQL.Query.Result{results: results}} ->
        Logger.info(inspect(results))
        label = RDF.Literal.lexical(Enum.at(results, 0)["itemLabel"])
        description = RDF.Literal.lexical(Enum.at(results, 0)["itemDescription"])
        statements = Enum.map(results, fn result ->
          %{property: %{iri: RDF.IRI.to_string(result["p"]), label: RDF.Literal.lexical(result["propLabel"])},
            object: %{iri: RDF.IRI.to_string(result["obj"]), label: RDF.Literal.lexical(result["objLabel"])} }
        end)
        %{label: label, description: description, statements: statements}
    end
  end

  def query(query_string) do
    SPARQL.Client.query(
      query_string,
      endpoint(),
      request_method: :get,
      protocol_version: "1.1",
      headers: %{
        "User-Agent" => "Imago/0.0.1 Dev (https://imago.pm/; contact@imago.pm) ImagoLib/0.0.1"
      }
    )
  end

  def query_update(query_string) do
    query = %SPARQL.Query{query_string: query_string, form: :insert}

    SPARQL.Client.query(
      query,
      endpoint(),
      request_method: :post,
      protocol_version: "1.0",
      operation: "update",
      headers: %{
        "User-Agent" => "Imago/0.0.1 Dev (https://imago.pm/; contact@imago.pm) ImagoLib/0.0.1"
      }
    )
  end
end
