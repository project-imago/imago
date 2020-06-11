defmodule Imago.Matrix.Transaction do
  @behaviour MatrixAppService.TransactionModule
  require Logger

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
end
