defmodule Admin do
  use GenServer

  @moduledoc """
  **Admin** es un módulo que implementa un servidor GenServer para la gestión de operaciones de autenticación y administración de usuarios. El servidor ofrece menús interactivos para el usuario, donde se pueden realizar diversas operaciones como inicio de sesión, actualización de contraseñas, eliminación de usuarios y visualización de reservas de pistas.

  ## Funciones principales
  - `main/1`: Punto de entrada que inicia el proceso de autenticación y administración de operaciones.
  - `auth_menu/1`: Muestra el menú de autenticación para el inicio de sesión del usuario.
  - `post_auth_menu/2`: Muestra un menú con las operaciones disponibles tras iniciar sesión.
  - `signInUser/1`: Realiza el inicio de sesión de un usuario, validando su contraseña.
  - `updatePassword/2`: Permite actualizar la contraseña de un usuario.
  - `deleteUser/1`: Permite eliminar un usuario de la base de datos.
  - `seeAllPistas/1`: Muestra todas las reservas de pistas.

  ## Flujo general
  El proceso comienza con la invocación de `main/1`, que inicia un menú interactivo para la autenticación. Tras el inicio de sesión, se ofrece un segundo menú para administrar las operaciones disponibles. Las funciones interactúan con un sistema de base de datos para verificar usuarios y gestionar la información.
  """

  # Inicia el GenServer
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Inicializa el estado vacío del GenServer
  def init(_init_arg) do
    {:ok, %{}}
  end

  @doc """
  Punto de entrada para las operaciones del administrador.

  Si hay un servidor disponible, llama a `auth_menu/1` para mostrar el menú de autenticación.
  Si no hay servidores disponibles, informa que no hay servidores activos.

  ## Parámetros
    - `[]`: Lista vacía (indica que no hay servidores disponibles).
    - `[pid | list]`: Lista con el identificador de un proceso (`pid`) y otros elementos.

  ## Ejemplo:
      main([pid])
  """
  def main([]) do
    IO.puts("No hay servidores disponibles")
  end

  def main([pid | list]) do
    if Process.alive?(pid) do
      auth_menu([pid | list])
    else
      main(list)
    end
  end

  @doc """
  Muestra el menú de autenticación y permite al usuario iniciar sesión.

  Esta función maneja la entrada del usuario para iniciar sesión, o bien salir del sistema.

  ## Parámetros
    - `[pid | list]`: Lista con el identificador del servidor (`pid`) y otros elementos.

  ## Ejemplo:
      auth_menu([pid])
  """
  def auth_menu([pid | list]) do
    f = IO.gets("\n  Seleccione una operación:\n
    1 - Iniciar sesión

    Para salir, pulse q\n\n
    > ")

    f = String.trim(f)

    case f do
      "1" ->
        case signInUser(pid) do
          {:ok, username} -> post_auth_menu([pid | list], username)
          :error -> auth_menu([pid | list])
        end

      "q" ->
        IO.write("\n  ¡Hasta luego!\n")

      "Q" ->
        IO.write("\n  ¡Hasta luego!\n")

      _ ->
        auth_menu([pid | list])
    end
  end

  @doc """
  Muestra el menú de operaciones disponibles después de haber iniciado sesión.

  El usuario puede elegir entre actualizar su contraseña, eliminar su cuenta o ver todas las reservas.

  ## Parámetros
    - `[pid | list]`: Lista con el identificador del servidor (`pid`) y otros elementos.
    - `current_user`: Nombre del usuario actualmente autenticado.

  ## Ejemplo:
      post_auth_menu([pid], "usuario1")
  """
  def post_auth_menu([pid | list], current_user) do
    if Process.alive?(pid) do
      f = IO.gets("\n  Seleccione una operación:\n
      1 - Actualizar contraseña
      2 - Eliminar usuario
      3 - Ver todas las reservas
      r - Volver al menú de autentificación

      Para salir, pulse q\n\n
      > ")

      f = String.trim(f)

      case f do
        "1" ->
          updatePassword(pid, current_user)
          post_auth_menu([pid | list], current_user)

        "2" ->
          deleteUser(pid)
          auth_menu([pid | list])

        "3" ->
          seeAllPistas(pid)
          post_auth_menu([pid | list], current_user)

        "r" ->
          auth_menu([pid | list])

        "R" ->
          auth_menu([pid | list])

        "q" ->
          IO.write("\n  ¡Hasta luego!\n")

        "Q" ->
          IO.write("\n  ¡Hasta luego!\n")

        _ ->
          post_auth_menu([pid | list], current_user)
      end
    else
      main(list)
    end
  end

  @doc """
  Realiza el inicio de sesión de un usuario, validando su nombre de usuario y contraseña.

  ## Parámetros
    - `pid`: Identificador del proceso donde se maneja la validación del inicio de sesión.

  ## Ejemplo:
      signInUser(pid)
  """
  def signInUser(pid) do
    username = IO.gets("\n  Introduzca su nombre de usuario (q para cancelar) > ")
    username = String.trim(username)

    if username in ["Q", "q"] do
      :error
    else
      pass = IO.gets("\n  Introduzca su contraseña > ")
      pass = String.trim(pass)
      encrypted_pass = Encriptado.encriptar(pass)
      response = Directorio.checkPassword(pid, username, encrypted_pass)

      case response do
        {:error, :user_not_found} ->
          IO.write(
            "\u001b[31m\n ------------\n  No existe una cuenta con ese nombre de usuario\n ------------\n\u001b[0m"
          )

          :error

        {:error, :invalid_password} ->
          IO.write(
            "\u001b[31m\n ------------\n  Contraseña incorrecta para '#{username}'\n ------------\n\u001b[0m"
          )

          :error

        {:ok, _} ->
          IO.puts(
            "\u001b[32m\n ------------\n  Iniciado sesión correctamente con '#{username}'\n ------------\n\u001b[0m"
          )

          {:ok, username}

        _ ->
          IO.write(
            "\u001b[31m\n ------------\n  Sucedió un error inesperado\n ------------\n\u001b[0m"
          )

          IO.inspect(response, label: "Devolvió: ")
          :error
      end
    end
  end

  @doc """
  Permite al usuario actualizar su contraseña.

  ## Parámetros
    - `pid`: Identificador del proceso donde se maneja la actualización de contraseña.
    - `current_user`: Nombre del usuario cuya contraseña se va a actualizar.

  ## Ejemplo:
      updatePassword(pid, "usuario1")
  """
  def updatePassword(pid, current_user) do
    pass = IO.gets("\n  Introduzca su nueva contraseña > ")
    pass = String.trim(pass)
    encrypted_pass = Encriptado.encriptar(pass)
    response = Directorio.updatePassword(pid, current_user, encrypted_pass)

    case response do
      {:updated} ->
        IO.puts(
          "\u001b[32m\n ------------\n  Contraseña actualizada correctamente para '#{current_user}'\n ------------\n\u001b[0m"
        )

      _ ->
        IO.write(
          "\u001b[31m\n ------------\n  Sucedió un error inesperado\n ------------\n\u001b[0m"
        )

        IO.inspect(response, label: "Devolvió: ")
    end
  end

  @doc """
  Elimina un usuario de la base de datos.

  ## Parámetros
    - `pid`: Identificador del proceso donde se maneja la eliminación del usuario.

  ## Ejemplo:
      deleteUser(pid)
  """
  def deleteUser(pid) do
    username = IO.gets("\n  Introduzca su nombre de usuario > ")
    username = String.trim(username)
    response = Directorio.deleteUser(pid, username)

    case response do
      {:deleted, current_user} ->
        IO.puts(
          "\u001b[32m\n ------------\n  Usuario '#{current_user}' eliminado\n ------------\n\u001b[0m"
        )

      _ ->
        IO.write(
          "\u001b[31m\n ------------\n  Sucedió un error inesperado\n ------------\n\u001b[0m"
        )

        IO.inspect(response, label: "Devolvió: ")
    end
  end

  @doc """
  Muestra todas las reservas de pistas.

  Esta función consulta al `Directorio` para obtener la lista de reservas y las muestra de manera formateada.

  ## Parámetros
    - `pid`: Identificador del proceso donde se gestionan las reservas de pistas.

  ## Ejemplo:
      seeAllPistas(pid)
  """
  def seeAllPistas(pid) do
    response = Directorio.seeAllPistas(pid)

    case response do
      [] ->
        IO.puts("\u001b[32m\n ------------\n  No hay ninguna reserva\n ------------\n\u001b[0m")

      pistas_reservadas when is_list(pistas_reservadas) ->
        reservas_formateadas =
          pistas_reservadas
          |> Enum.map(fn %{numero: numero, reservada_por: reservada_por} ->
            "\tPista #{numero} reservada por #{reservada_por}"
          end)
          |> Enum.join("\n")

        IO.puts(
          "\u001b[32m\n ------------\n  Reservas:\n#{reservas_formateadas}\n ------------\n\u001b[0m"
        )

      _ ->
        IO.puts(
          "\u001b[31m\n ------------\n  Sucedió un error inesperado\n ------------\n\u001b[0m"
        )

        IO.inspect(response, label: "Devolvió: ")
    end
  end
end
