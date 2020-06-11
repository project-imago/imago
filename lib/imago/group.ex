defmodule Imago.Group do
  def create(_params) do
    nil
  end

  def create_from_iri(iri_prefix, iri_rest) do
    case iri_prefix do
      "wd" ->
        create_from_wikidata(:object, iri_rest)
        :ok
      _ ->
        :error
    end
  end

  def create_from_wikidata(:object, wd_id) do
    case Imago.Graph.get_remote_from_wikidata(wd_id) do
    %{
      label: label,
      description: description,
      statements: statements
    } ->
      state_events =
        [
          %{
            type: "pm.imago.type",
            state_key: "",
            content: %{ type: :group }
          },
          %{
            type: "pm.imago.group.statements",
            state_key: "",
            content: %{ statements: statements }
          },
          %{
            type: "m.room.history_visibility",
            state_key: "",
            content: %{history_visibility: :world_readable}
          }
        ]

        {:ok, %{"room_alias" => _room_alias, "room_id" => _room_id}} =
        MatrixAppService.Client.create_room(
        visibility: :public,
        name: label,
        topic: description,
        room_alias_name: "_stm_wd_" <> wd_id,
        initial_state: state_events
      )
      :ok
    _ -> :error
    end
  end

  def get_by_room_id(_room_id) do
    nil
  end

  

  def delete() do
    nil
  end
end
