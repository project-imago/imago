defmodule Imago.Matrix do
  def client(user_id \\ nil, storage \\ nil) do
    MatrixAppService.Client.client(user_id, storage)
  end
end
