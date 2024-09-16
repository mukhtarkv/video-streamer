defmodule Video.FileStorage.Behaviour do
  @callback stream_file(String.t()) :: {:ok, Enumerable.t()} | {:error, reason :: atom}
end
