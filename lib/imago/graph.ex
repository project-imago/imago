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

  def wikidata_query_relations(wd_id) do
    IO.puts("rel")
    """
    PREFIX wd: <http://www.wikidata.org/entity/>
    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX wikibase: <http://wikiba.se/ontology#>
    PREFIX mwapi: <https://www.mediawiki.org/ontology#API/>
    PREFIX schema: <http://schema.org/>

    SELECT ?prop ?obj
    WHERE {
      SERVICE <https://query.wikidata.org/sparql> {
        ?item ?p ?obj .
        ?prop wikibase:directClaim ?p .
        FILTER ( ?p in ( wdt:P30, wdt:P279, wdt:P131, wdt:P150, wdt:P361, wdt:P527) )
      }
      BIND (wd:#{wd_id} AS ?item)
    }
    """
    |> query()
  end

  def wikidata_query_labels_and_descriptions(wd_iri) do
    IO.puts("ldesc")
    """
    PREFIX wd: <http://www.wikidata.org/entity/>
    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX wikibase: <http://wikiba.se/ontology#>
    PREFIX mwapi: <https://www.mediawiki.org/ontology#API/>
    PREFIX schema: <http://schema.org/>

    SELECT (lang(?label) AS ?lang) ?label ?description
    WHERE {
      SERVICE <https://query.wikidata.org/sparql> {
        ?item rdfs:label ?label;
              schema:description ?description.
        FILTER(LANG(?label) = LANG(?description)).
      }
      BIND (<#{wd_iri}> AS ?item)
    }
    """
    |> query()
  end

  def get_remote_from_wikidata_old(wd_id) do
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

  def get_remote_from_wikidata(wd_id) do
    Logger.info("getting thing")
    wd_iri = "http://www.wikidata.org/entity/#{wd_id}"
    with {:ok, %SPARQL.Query.Result{results: subject_labels_and_descriptions}} <-
      wikidata_query_labels_and_descriptions(wd_iri),
         subject_event <-
           %{
             type: "pm.imago.object",
             state_key: "",
             content: %{
               label: Enum.map(subject_labels_and_descriptions, &({RDF.Literal.lexical(&1["lang"]), RDF.Literal.lexical(&1["label"])})) |> Enum.into(%{}),
               description: Enum.map(subject_labels_and_descriptions, &({RDF.Literal.lexical(&1["lang"]), RDF.Literal.lexical(&1["description"])})) |> Enum.into(%{})
             }
           },
         {:ok, %SPARQL.Query.Result{results: relations}} <-
           wikidata_query_relations(wd_id),
         relation_events <-
           Enum.map(relations, fn r ->
             %{
               type: "pm.imago.statements",
               state_key: RDF.IRI.to_string(r["obj"]),
               content: %{
                 property: RDF.IRI.to_string(r["prop"]),
                 value: RDF.IRI.to_string(r["obj"])
               }
             }
           end),
         objects = Enum.flat_map(relations, &Map.values/1) |> Enum.uniq,
         objects_events <-
           Enum.map(objects, fn o ->
             with {:ok, %SPARQL.Query.Result{results: obj_labels_and_descriptions}} <-
                 wikidata_query_labels_and_descriptions(RDF.IRI.to_string(o)) do
                    %{
                     type: "pm.imago.object",
                     state_key: RDF.IRI.to_string(o),
                     content: %{
                       label: Enum.map(obj_labels_and_descriptions, &({RDF.Literal.lexical(&1["lang"]), RDF.Literal.lexical(&1["label"])})) |> Enum.into(%{}),
                       description: Enum.map(obj_labels_and_descriptions, &({RDF.Literal.lexical(&1["lang"]), RDF.Literal.lexical(&1["description"])})) |> Enum.into(%{})
                       }
                    }
               end
           end)
    do
      %{name: subject_event.content.label["en"],
        topic: subject_event.content.description["en"],
        state: List.flatten([subject_event, objects_events, relation_events])
      }
    else
      error ->
        Logger.info(inspect(error))
        :error
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
