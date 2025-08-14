defmodule DbTest do
  @moduledoc """
  **DbTest** es un módulo que contiene casos de prueba para varias funciones del módulo `Db`,
  el cual realiza operaciones sobre listas de datos de usuarios.

  Las pruebas incluyen operaciones para eliminar elementos, buscar elementos y actualizar elementos en la lista.

  ## Funciones de prueba

  - `delete element deletes head`: Prueba que el elemento en la cabeza de la lista se elimina correctamente.
  - `delete element not found`: Prueba que intentar eliminar un elemento no existente no modifica la lista.
  - `delete element in the middle`: Prueba que un elemento en el medio de la lista se elimina correctamente.
  - `delete element returns empty list`: Prueba que eliminar el único elemento de una lista resulta en una lista vacía.
  - `find_element 1`: Prueba buscar un elemento en una lista con un solo elemento.
  - `find_element 2`: Prueba buscar un elemento en una lista con varios elementos.
  - `find_element not found`: Prueba que buscar un elemento no existente retorna `{:not_found}`.
  - `update element 1`: Prueba actualizar un elemento en una lista con un solo elemento.
  - `update element 2`: Prueba actualizar un elemento en el medio de una lista con varios elementos.
  - `update element empty`: Prueba que actualizar una lista vacía retorna una lista vacía.
  - `update element not found`: Prueba que intentar actualizar un elemento no existente no modifica la lista.

  ## Ejemplo

      # Ejecutar todas las pruebas
      mix test
  """
  use ExUnit.Case
  alias Db

  @doc """
  Prueba que eliminar el elemento en la cabeza de la lista funciona correctamente.

  Elimina el primer elemento con la clave `"key"` y verifica que la
  lista restante es correcta.

  ## Datos de prueba:
    - Entrada: Una lista con dos elementos, el primero con la clave `"key"`.
    - Salida esperada: La lista después de eliminar el elemento con la clave `"key"`.
  """
  test "delete element deletes head" do
    list = %{usuarios: [{"key2", "element", "element2"}, {"key", "element", "element2"}]}
    return_list = %{usuarios: [{"key2", "element", "element2"}]}
    assert Db.del_element("key", list) == return_list
  end

  @doc """
  Prueba que eliminar un elemento que no existe no modifica la lista.

  Intenta eliminar un elemento con la clave `"key2"`, que no está presente en
  la lista, y verifica que la lista permanece sin cambios.

  ## Datos de prueba:
    - Entrada: Una lista con un solo elemento con la clave `"key"`.
    - Salida esperada: La lista original ya que `"key2"` no se encuentra.
  """
  test "delete element not found" do
    list = %{usuarios: [{"key", "element", "element2"}]}
    assert Db.del_element("key2", list) == list
  end

  @doc """
  Prueba que eliminar un elemento en el medio de la lista funciona correctamente.

  Elimina el elemento con la clave `"k3"` de una lista de 4 elementos y verifica
  que la lista restante es correcta.

  ## Datos de prueba:
    - Entrada: Una lista con 4 elementos.
    - Salida esperada: La lista después de eliminar el elemento con la clave `"k3"`.
  """
  test "delete element in the middle" do
    list = %{
      usuarios: [
        {"k4", "elem", "element2"},
        {"k3", "elem", "element2"},
        {"k2", "elem", "element2"},
        {"k", "elem", "element2"}
      ]
    }

    return_list = %{
      usuarios: [
        {"k4", "elem", "element2"},
        {"k2", "elem", "element2"},
        {"k", "elem", "element2"}
      ]
    }

    assert Db.del_element("k3", list) == return_list
  end

  @doc """
  Prueba que eliminar el último elemento de la lista resulta en una lista vacía.

  Elimina el único elemento de la lista y verifica que la lista se vuelve vacía.

  ## Datos de prueba:
    - Entrada: Una lista con un solo elemento.
    - Salida esperada: Una lista vacía después de eliminar el único elemento.
  """
  test "delete element returns empty list" do
    list = %{usuarios: [{"key", "element", "element2"}]}
    assert Db.del_element("key", list) == %{usuarios: []}
  end

  @doc """
  Prueba buscar un elemento en una lista con un solo elemento.

  Busca el elemento con la clave `"key"` y espera que sea encontrado.

  ## Datos de prueba:
    - Entrada: Una lista con un solo elemento con la clave `"key"`.
    - Salida esperada: El elemento encontrado `{"key", "element", "element2"}`.
  """
  test "find_element 1" do
    list = [{"key", "element", "element2"}]
    assert Db.find_element("key", list) == {"key", "element", "element2"}
  end

  @doc """
  Prueba buscar un elemento en una lista con varios elementos.

  Busca el elemento con la clave `"key3"` y espera que sea encontrado.

  ## Datos de prueba:
    - Entrada: Una lista con varios elementos.
    - Salida esperada: El elemento encontrado `{"key3", "element", "element2"}`.
  """
  test "find_element 2" do
    list = [{"key1", "element", "element2"}, {"key3", "element", "element2"}]
    assert Db.find_element("key3", list) == {"key3", "element", "element2"}
  end

  @doc """
  Prueba buscar un elemento que no está en la lista.

  Busca un elemento no existente con la clave `"key3"` y espera `{:not_found}`.

  ## Datos de prueba:
    - Entrada: Una lista con un solo elemento.
    - Salida esperada: `{:not_found}` ya que `"key3"` no existe.
  """
  test "find_element not found" do
    list = [{"key1", "element", "element2"}]
    assert Db.find_element("key3", list) == {:not_found}
  end

  @doc """
  Prueba actualizar un elemento en una lista con un solo elemento.

  Actualiza el elemento con la clave `"key"` a un nuevo valor y verifica que la lista
  se actualiza correctamente.

  ## Datos de prueba:
    - Entrada: Una lista con un solo elemento.
    - Salida esperada: La lista con el elemento actualizado.
  """
  test "update element 1" do
    list = [{"key", "element", "element2"}]

    assert Db.update(list, "key", "new_element", "new_element2") == [
             {"key", "new_element", "new_element2"}
           ]
  end

  @doc """
  Prueba actualizar un elemento en el medio de una lista con varios elementos.

  Actualiza el elemento con la clave `"k3"` y verifica la lista actualizada.

  ## Datos de prueba:
    - Entrada: Una lista con varios elementos.
    - Salida esperada: La lista con el elemento `"k3"` actualizado.
  """
  test "update element 2" do
    list = [
      {"k4", "elem", "element2"},
      {"k3", "elem", "element2"},
      {"k2", "elem", "element2"},
      {"k1", "elem", "element2"}
    ]

    return_list = [
      {"k4", "elem", "element2"},
      {"k3", "new_elem", "new_element2"},
      {"k2", "elem", "element2"},
      {"k1", "elem", "element2"}
    ]

    assert Db.update(list, "k3", "new_elem", "new_element2") == return_list
  end

  @doc """
  Prueba actualizar una lista vacía.

  Verifica que actualizar una lista vacía retorna una lista vacía.

  ## Datos de prueba:
    - Entrada: Una lista vacía.
    - Salida esperada: Una lista vacía.
  """
  test "update element empty" do
    list = []
    assert Db.update(list, "key", "new_element", "new_element2") == []
  end

  @doc """
  Prueba actualizar un elemento que no existe en la lista.

  Intenta actualizar un elemento con la clave `"key"` que no está en la lista,
  y verifica que la lista permanece sin cambios.

  ## Datos de prueba:
    - Entrada: Una lista sin el elemento con la clave `"key"`.
    - Salida esperada: La lista original ya que el elemento no se encuentra.
  """
  test "update element not found" do
    list = [{"k3", "elem", "element2"}, {"k2", "elem", "element2"}, {"k1", "elem", "element2"}]

    return_list = [
      {"k3", "elem", "element2"},
      {"k2", "elem", "element2"},
      {"k1", "elem", "element2"}
    ]

    assert Db.update(list, "key", "new_element", "new_element2") == return_list
  end
end
