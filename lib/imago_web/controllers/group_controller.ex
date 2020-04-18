defmodule ImagoWeb.GroupController do
  use ImagoWeb, :controller
  require Logger

  def search(conn, %{"property" => property, "term" => term}) do
    query =
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

    case SPARQL.Client.query(query,
                             # "http://blazegraph.imago.local:8080/bigdata/namespace/kb/sparql/kb/sparql",
                             "http://wdqs.imago.local:9999/bigdata/namespace/wdq/sparql/wdq/sparql",
                             # "https://query.wikidata.org/sparql",
                             request_method: :get,
                             protocol_version: "1.1",
                             headers: %{"User-Agent" => "Imago/0.0.1 (https://imago.pm/; contact@imago.pm) ImagoLib/0.0.1"}
         ) do
      {:ok, %{results: results}} ->
        # Logger.debug(results)
        results =
          results
          |> Enum.map(fn %{"itemLabel" => label} ->
            RDF.Literal.lexical(label)
          end)
        json(conn, %{results: results})
      {:error, %{body: body}} ->
        json(conn, %{error: body})
    end
  end
end
