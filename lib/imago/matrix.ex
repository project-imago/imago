defmodule Imago.Matrix do
  @behaviour MatrixAppService.TransactionModule
  require Logger

  def client(user_id \\ nil, storage \\ nil) do
    MatrixAppService.Client.client(user_id, storage)
  end

  @impl MatrixAppService.TransactionModule
  def new_event(%MatrixAppService.Event{
        type: "m.room.create",
        content: %{"creator" => creator_id}
      }) do
    Logger.error("Room creation by #{creator_id}")
  end

  def new_event(%MatrixAppService.Event{
        type: "m.room.name",
        content: %{"name" => name}
      }) do
    Logger.error("Attributing name #{name}")
  end

  def new_event(%MatrixAppService.Event{type: "pm.imago.type", content: %{"type" => "group"}}) do
    Logger.error("Group creation")
  end

  def new_event(%MatrixAppService.Event{
        type: "pm.imago.groups.statement",
        content: %{"objects" => objects}
      }) do
    Logger.error("Statement creation")
  end

  # def new_event(%MatrixAppService.Event{type: "pm.imago.group", content: %{"id" => room_id}}) do
  # end
  def new_event(%MatrixAppService.Event{type: type}) do
    Logger.debug("Received #{type} from Synapse")
  end

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
