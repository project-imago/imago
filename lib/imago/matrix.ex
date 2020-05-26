defmodule Imago.Matrix do
  @behaviour MatrixAppService.TransactionModule
  require Logger

  def polyjuice_client(user \\ nil) do
    MatrixAppService.Client.client()
  end

  @impl MatrixAppService.TransactionModule
  def new_event(%MatrixAppService.Event{type: "pm.imago.type", content: %{"type" => "group"}}) do
    Logger.error("Group creation")
  end
  def new_event(%MatrixAppService.Event{type: "pm.imago.groups.statement", content: %{"objects" => objects}}) do
    Logger.error("Statement creation")
  end
  # def new_event(%MatrixAppService.Event{type: "pm.imago.group", content: %{"id" => room_id}}) do
  # end
  def new_event(%MatrixAppService.Event{type: type}) do
    Logger.debug("Received #{type} from Synapse")
  end
end
