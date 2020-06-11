defmodule Imago.Matrix.Room do
  require Logger

  def query_alias("#_stm_" <> rest) do
    query_alias_stm(rest)
  end

  def query_alias_stm(alias_rest) do
    case Regex.run(~r/(\w+)_(\w+):.+/, alias_rest, capture: :all_but_first) do
      [iri_prefix, iri_rest] ->
        Imago.Group.create_from_iri(iri_prefix, iri_rest)
      _ ->
        :error
    end
  end

  def query_alias(room_alias) do
    Logger.debug("Received ask for alias #{room_alias}")
  end
end
