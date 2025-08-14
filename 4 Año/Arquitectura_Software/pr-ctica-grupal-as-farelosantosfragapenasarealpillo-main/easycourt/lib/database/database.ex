defmodule Db do
  @moduledoc """
  Este módulo proporciona funciones para manejar una base de datos en memoria simulada
  utilizando listas de tuplas. La estructura básica es una lista de tuplas de tres elementos:

    - key: la clave que identifica un elemento.
    - element: el primer valor asociado a la clave.
    - element2: el segundo valor asociado a la clave.

  Las funciones soportan operaciones básicas como crear una lista vacía, agregar elementos,
  eliminar elementos, buscar elementos y actualizarlos.
  """

  # Crear una nueva lista vacía
  @doc """
  Crea una nueva lista vacía que puede ser utilizada para almacenar elementos.

  ## Ejemplo

      iex> Db.new_list()
      []
  """
  def new_list, do: []

  # Agregar elementos a la lista
  @doc """
  Agrega un elemento a la lista utilizando una clave y dos valores.
  En este caso, la tupla tiene tres elementos: key, element, element2.

  ## Ejemplo

      iex> Db.add_element(:clave, 1, 2, [])
      [{:clave, 1, 2}]
  """
  def add_element(key, element, element2, db), do: [{key, element, element2} | db]

  @doc """
  Agrega un elemento a la lista utilizando una clave y un solo valor.
  En este caso, la tupla tiene solo dos elementos: key, element.

  ## Ejemplo

      iex> Db.add_element(:clave, 1, [])
      [{:clave, 1}]
  """
  def add_element(key, element, db), do: [{key, element} | db]

  # Eliminar un elemento dado su clave
  @doc """
  Elimina un elemento de la lista, dado su clave.

  Si no se encuentra el elemento, la lista no cambia.

  ## Ejemplo

      iex> Db.del_element(:clave, %{usuarios: [{:clave, 1, 2}, {:otra, 3, 4}]})
      %{usuarios: [{:otra, 3, 4}]}
  """
  def del_element(_, %{usuarios: []}), do: %{usuarios: []}

  def del_element(key, %{usuarios: [{head_key, _, _} | db]}) when head_key == key do
    %{usuarios: db}
  end

  def del_element(key, %{usuarios: [{head_key, head_elem, head_elem2} | db]}) do
    updated_db = del_element(key, %{usuarios: db})
    %{usuarios: [{head_key, head_elem, head_elem2} | updated_db[:usuarios]]}
  end

  # Encontrar un elemento dado su clave en una lista
  @doc """
  Busca un elemento en la lista de usuarios, dado su clave.

  Si el elemento no se encuentra, retorna `:not_found`.

  ## Ejemplo

      iex> Db.find_element(:clave, %{usuarios: [{:clave, 1, 2}, {:otra, 3, 4}]})
      {:clave, 1, 2}
  """
  def find_element(_, %{usuarios: []}), do: :not_found

  def find_element(key, %{usuarios: usuarios}) do
    Enum.find_value(usuarios, :not_found, fn
      {head_key, head_elem, head_elem2} when key == head_key -> {head_key, head_elem, head_elem2}
      _ -> nil
    end)
  end

  def find_element(_, []), do: {:not_found}

  def find_element(key, [{head_key, head_elem, head_elem2} | _]) when key == head_key do
    {head_key, head_elem, head_elem2}
  end

  def find_element(key, [_ | db]), do: find_element(key, db)

  # Todas las cláusulas de update/4 agrupadas
  @doc """
  Actualiza el elemento en la base de datos, dado su `key`. Si el elemento es encontrado,
  se actualiza con los nuevos valores `new_element` y `new_element2`.

  Si la lista está vacía, se retorna una lista vacía.

  ## Ejemplo

      iex> Db.update([{:clave, 1, 2}], :clave, 3, 4)
      [{:clave, 3, 4}]
  """
  def update([], _key, _new_element, _new_element2), do: []

  def update([{key_db, _, _} | db_ref], key, new_element, new_element2) when key == key_db do
    [{key_db, new_element, new_element2} | db_ref]
  end

  def update([{key_db, element, element2} | db_ref], key, new_element, new_element2) do
    [{key_db, element, element2} | update(db_ref, key, new_element, new_element2)]
  end

  def update(%{usuarios: usuarios} = db, key, new_element, new_element2) do
    updated_users = update(usuarios, key, new_element, new_element2)
    %{db | usuarios: updated_users}
  end

  def update(db_ref, key, new_element) do
    update(db_ref, key, new_element, nil)
  end
end
