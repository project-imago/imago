defmodule Imago.Group do
  require Logger

  def create(_params) do
    nil
  end

  def create_from_iri(iri_prefix, iri_rest) do
    with "wd" <- iri_prefix,
         :ok <- create_from_wikidata(:object, iri_rest)
    do
      :ok
    else
      error ->
        Logger.info(inspect(error))
        :error
    end
  end

  def create_from_wikidata(:object, wd_id) do
    with %{
        name: name,
        topic: topic,
        state: state
      } <-
    Imago.Graph.get_remote_from_wikidata(wd_id),
        state_events = [
          %{
            type: "pm.imago.type",
            state_key: "",
            content: %{type: :group}
          },
          %{
            type: "m.room.history_visibility",
            state_key: "",
            content: %{history_visibility: :world_readable}
          },
          %{
            type: "m.room.guest_access",
            state_key: "",
            content: %{guest_access: :can_join}
          }
          | state
        ],

        {:ok, %{"room_alias" => _room_alias, "room_id" => _room_id}} <-
          MatrixAppService.Client.create_room(
            visibility: :public,
            name: name,
            topic: topic,
            room_alias_name: "_stm_wd_" <> wd_id,
            initial_state: state_events
          )
        do
        :ok
        else
      error ->
        Logger.info(inspect(error))
        :error
    end
  end

  def get_by_room_id(_room_id) do
    nil
  end

  def delete() do
    nil
  end

  def search(property, term, lc) do
    query = search_query_for(property, term, lc)

    case Imago.Graph.query(query) do
      {:ok, %{results: results}} ->
        # Logger.debug(results)
        results =
          results
          |> Enum.map(fn %{"item" => item, "itemLabel" => label} = result ->
            %{
              item: RDF.IRI.to_string(item),
              label: RDF.Literal.lexical(label),
              description: Map.get(result, "itemDescription") && RDF.Literal.lexical(Map.get(result, "itemDescription")) || ""
            }
          end)
          {:ok, results}
      {:error, %{body: body}} ->
        {:error, body}
      {:error, error} ->
        {:error, error}
    end
  end

  def search_query_for("subgroup", term, lc), do: search_query_for("location", term, lc)
  def search_query_for("about", term, lc), do: search_query_for("location", term, lc)
  def search_query_for("location", term, lc) do
    """
    PREFIX wd: <http://www.wikidata.org/entity/>
    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX wikibase: <http://wikiba.se/ontology#>
    PREFIX mwapi: <https://www.mediawiki.org/ontology#API/>
    PREFIX schema: <http://schema.org/>

    SELECT DISTINCT ?item ?itemLabel ?num ?itemDescription WHERE { # ?type ?typeLabel
      SERVICE wikibase:mwapi {
          bd:serviceParam wikibase:api "EntitySearch" .
          bd:serviceParam wikibase:endpoint "www.wikidata.org" .
          bd:serviceParam mwapi:search "#{term}" .
          bd:serviceParam mwapi:language "en" .
          ?item wikibase:apiOutputItem mwapi:item .
          ?num wikibase:apiOrdinal true .
          #SERVICE wikibase:label { bd:serviceParam wikibase:language "fr". }
      }
      SERVICE <https://query.wikidata.org/sparql> {
        # ?item wdt:P31 ?type. #this creates doubles
        ?item wdt:P31 [wdt:P279* wd:Q15642541].
        #?item schema:description ?itemDescription. # some desc are in en
        #SERVICE wikibase:label { bd:serviceParam wikibase:language "fr". }
        SERVICE wikibase:label { bd:serviceParam wikibase:language "fr,en".
          ?item rdfs:label ?itemLabel.
          ?item schema:description ?itemDescription. # some desc are in en
        }
      }
      MINUS {?item wdt:P31 wd:Q4167410}
      #FILTER (lang(?itemDescription) = "fr") # some desc are in en
      #SERVICE wikibase:label { bd:serviceParam wikibase:language "fr".
      #  ?item rdfs:label ?itemLabel.
      #}
    }
    #GROUP BY ?item
    ORDER BY ASC(?num) LIMIT 20
    """
  end
end
