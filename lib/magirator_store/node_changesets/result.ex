defmodule MagiratorStore.Result do
  
    use Ecto.Schema
    import Ecto.Changeset

    schema "result" do
        field :place, :integer
        field :comment, :string
        field :created, :integer
    end

    def changeset( result, params \\%{} ) do
        result
        |> cast(params, [:id, :place, :comment, :created])
        |> validate_required([:place])
    end
end