defmodule Imago.NS do
  use RDF.Vocabulary.Namespace

  # @root_iri Application.compile_env!(:imago, [:rdf, :root_iri])

  defvocab Group,
    base_iri: "http://imago.pm/group/",
    terms: [], 
    strict: false

  defvocab Chat,
    base_iri: "http://imago.pm/chat/",
    terms: [], 
    strict: false

  defvocab User,
    base_iri: "http://imago.pm/user/",
    terms: [], 
    strict: false

  defvocab Property,
    base_iri: "http://imago.pm/property/",
    terms: [], 
    strict: false

  defvocab Wd,
    base_iri: "http://www.wikidata.org/entity/",
    terms: [], 
    strict: false

  defvocab Wdt,
    base_iri: "http://www.wikidata.org/prop/direct/",
    terms: [], 
    strict: false
end
