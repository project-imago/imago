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
end
