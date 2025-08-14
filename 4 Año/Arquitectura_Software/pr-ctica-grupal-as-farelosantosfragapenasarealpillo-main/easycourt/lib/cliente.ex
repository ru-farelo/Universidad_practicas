defmodule Cliente do
  @moduledoc """
  Módulo `Cliente` que implementa la lógica del cliente de un sistema de reservas.
  Este módulo utiliza `GenServer` para manejar el estado del cliente e interactuar con servidores.

  Ofrece funcionalidades como autenticación de usuarios, gestión de contraseñas y reservas.
  """

  use GenServer

  # Inicia un proceso GenServer para el cliente.
  @doc """
  Inicia un proceso GenServer vinculado al módulo `Cliente`.

  ## Parámetros
    - `_`: Un valor ignorado, pero necesario por la firma de la función.

  ## Retorno
    - `{:ok, pid}`: Devuelve el PID del proceso iniciado.

  ## Ejemplo
      iex> Cliente.start_link(nil)
      {:ok, #PID<0.123.0>}
  """
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Inicializa el estado del GenServer.
  @doc """
  Inicializa el estado del cliente. En este caso, se utiliza un mapa vacío como estado inicial.

  ## Parámetros
    - `_init_arg`: Un argumento inicial ignorado.

  ## Retorno
    - `{:ok, %{}}`: Indica que el estado inicial es un mapa vacío.
  """

  def init(_init_arg) do
    {:ok, %{}}
  end

  # Entrada principal del cliente.
  @doc """
  Punto de entrada principal del cliente. Se asegura de que haya servidores disponibles y, de ser así,
  delega la operación al menú de autenticación.

  ## Parámetros
    - `servers`: Lista de PIDs de los servidores disponibles.

  ## Comportamiento
    - Si no hay servidores disponibles, muestra un mensaje y no hace nada más.
    - Si hay servidores, verifica que el primer servidor esté activo y delega al menú de autenticación.

  ## Ejemplo
      iex> Cliente.main([])
      "No hay servidores disponibles"
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

  # Muestra el menú de autenticación.
  @doc """
  Presenta el menú de autenticación al usuario, permitiéndole registrarse, iniciar sesión o salir del sistema.

  ## Parámetros
    - `servers`: Lista de servidores disponibles.

  ## Opciones
    - `"1"`: Permite registrar un usuario nuevo.
    - `"2"`: Permite iniciar sesión.
    - `"q"`: Finaliza la ejecución del programa.

  ## Ejemplo
      iex> Cliente.auth_menu([pid])
      :ok
  """

  def auth_menu([pid | list]) do
    f = IO.gets("\n  Seleccione una operación:\n
    1 - Registrarse
    2 - Iniciar sesión

    Para salir, pulse q\n\n
    > ")

    f = String.trim(f)

    case f do
      "1" ->
        case signUpUser(pid) do
          {:ok, username} -> post_auth_menu([pid | list], username)
          :error -> auth_menu([pid | list])
        end

      "2" ->
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

  # Muestra el menú post-autenticación.
  @doc """
  Presenta un menú con opciones adicionales después de que el usuario haya iniciado sesión.

  ## Parámetros
    - `servers`: Lista de servidores disponibles.
    - `current_user`: Nombre del usuario autenticado.

  ## Opciones
    - `"1"`: Cambiar la contraseña del usuario.
    - `"2"`: Eliminar la cuenta del usuario.
    - `"3"`: Mostrar las reservas del usuario.
    - `"4"`: Realizar una nueva reserva de pista.
    - `"5"`: Liberar una pista reservada.
    - `"r"`: Volver al menú de autenticación.

  ## Ejemplo
      iex> Cliente.post_auth_menu([pid], "usuario1")
      :ok
  """

  def post_auth_menu([pid | list], current_user) do
    if Process.alive?(pid) do
      f = IO.gets("\n  Seleccione una operación:\n
      1 - Actualizar contraseña
      2 - Eliminar usuario
      3 - Ver tus reservas
      4 - Reservar pista
      5 - Liberar pista
      r - Volver al menú de autentificación

      Para salir, pulse q\n\n
      > ")

      f = String.trim(f)

      case f do
        "1" ->
          updatePassword(pid, current_user)
          post_auth_menu([pid | list], current_user)

        "2" ->
          deleteUser(pid, current_user)
          auth_menu([pid | list])

        "3" ->
          ver_reservas_usuario(pid, current_user)
          post_auth_menu([pid | list], current_user)

        "4" ->
          reservar_pista(pid, current_user)
          post_auth_menu([pid | list], current_user)

        "5" ->
          liberar_pista(pid, current_user)
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

  # Registrar un nuevo usuario.
  @doc """
  Permite registrar un usuario nuevo.

  ## Parámetros
    - `pid`: PID del servidor al que se envía la solicitud de registro.

  ## Flujo
    - Solicita al usuario un nombre y contraseñas para el registro.
    - Valida las entradas del usuario.
    - Encripta la contraseña y envía los datos al servidor.

  ## Retorno
    - `{:ok, username}`: Registro exitoso.
    - `:error`: Registro fallido.

  ## Ejemplo
      iex> Cliente.signUpUser(pid)
      {:ok, "usuario1"}
  """

  def signUpUser(pid) do
    username = IO.gets("\n  Introduzca un nombre de usuario (q para cancelar) > ")
    username = String.trim(username)

    if username in ["Q", "q"] do
      IO.write("\u001b[31m\n ------------\n  Operación cancelada\n ------------\n\u001b[0m")
      :error
    else
      pass1 = IO.gets("\n  Introduzca una contraseña > ")
      pass1 = String.trim(pass1)

      if pass1 == "" or String.length(pass1) > 16 do
        IO.write(
          "\u001b[31m\n ------------\n  Contraseña no válida: tiene que tener entre 1 y 16 caracteres\n ------------\n\u001b[0m"
        )

        :error
      else
        pass2 = IO.gets("\n  Repita su contraseña > ")
        pass2 = String.trim(pass2)

        if pass2 != pass1 do
          IO.write(
            "\u001b[31m\n ------------\n  Las contraseñas no coinciden\n ------------\n\u001b[0m"
          )

          :error
        else
          encrypted_pass = Encriptado.encriptar(pass1)
          response = Directorio.signUp(pid, username, encrypted_pass)

          case response do
            {:user_exists} ->
              IO.write(
                "\u001b[31m\n ------------\n  El nombre de usuario ya está en uso\n ------------\n\u001b[0m"
              )

              :error

            {:ok, username} ->
              IO.puts(
                "\u001b[32m\n ------------\n  Usuario '#{username}' creado\n ------------\n\u001b[0m"
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
    end
  end

  # Iniciar sesión.
  @doc """
  Permite iniciar sesión con un usuario existente.

  ## Parámetros
    - `pid`: PID del servidor al que se envía la solicitud de inicio de sesión.

  ## Flujo
    - Solicita al usuario un nombre de usuario y contraseña.
    - Encripta la contraseña para enviarla al servidor.
    - Verifica las credenciales con el servidor.

  ## Retorno
    - `{:ok, username}`: Inicio de sesión exitoso.
    - `:error`: Inicio de sesión fallido.

  ## Ejemplo
      iex> Cliente.signInUser(pid)
      {:ok, "usuario1"}
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

  # Actualizar la contraseña de un usuario.
  @doc """
  Permite al usuario cambiar su contraseña.

  ## Parámetros
    - `pid`: PID del servidor al que se envía la solicitud.
    - `username`: Nombre del usuario autenticado que quiere cambiar la contraseña.

  ## Flujo
    - Solicita al usuario su contraseña actual y las nuevas contraseñas.
    - Valida que las nuevas contraseñas coincidan.
    - Encripta la nueva contraseña y envía la solicitud al servidor.

  ## Ejemplo
      iex> Cliente.updatePassword(pid, "usuario1")
      :ok
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

  # Eliminar un usuario.
  @doc """
  Permite al usuario autenticado eliminar su cuenta.

  ## Parámetros
    - `pid`: PID del servidor al que se envía la solicitud.
    - `username`: Nombre del usuario autenticado que quiere eliminar su cuenta.

  ## Flujo
    - Solicita confirmación antes de eliminar la cuenta.
    - Si se confirma, envía la solicitud de eliminación al servidor.

  ## Ejemplo
      iex> Cliente.deleteUser(pid, "usuario1")
      :ok
  """

  def deleteUser(pid, current_user) do
    response = Directorio.deleteUser(pid, current_user)

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

  # Ver las reservas del usuario.
  @doc """
  Muestra al usuario una lista de las reservas que tiene actualmente.

  ## Parámetros
    - `pid`: PID del servidor al que se envía la solicitud.
    - `username`: Nombre del usuario autenticado.

  ## Flujo
    - Solicita al servidor las reservas del usuario.
    - Muestra las reservas en formato legible al usuario.

  ## Ejemplo
      iex> Cliente.ver_reservas_usuario(pid, "usuario1")
      :ok
  """

  def ver_reservas_usuario(pid, current_user) do
    response = Directorio.ver_reservas_usuario(pid, current_user)

    case response do
      [] ->
        IO.puts(
          "\u001b[32m\n ------------\n  No tienes ninguna reserva\n ------------\n\u001b[0m"
        )

      pistas_reservadas when is_list(pistas_reservadas) ->
        # Formatear cada reserva en una cadena legible
        reservas_formateadas =
          pistas_reservadas
          |> Enum.map(fn %{numero: numero, reservada_por: _reservada_por} ->
            "\tPista #{numero}"
          end)
          |> Enum.join("\n")

        IO.puts(
          "\u001b[32m\n ------------\n  Tus reservas son:\n#{reservas_formateadas}\n ------------\n\u001b[0m"
        )

      _ ->
        IO.puts(
          "\u001b[31m\n ------------\n  Sucedió un error inesperado\n ------------\n\u001b[0m"
        )

        IO.inspect(response, label: "Devolvió: ")
    end
  end

  # Reservar una pista.
  @doc """
  Permite al usuario realizar una reserva de pista.

  ## Parámetros
    - `pid`: PID del servidor al que se envía la solicitud.
    - `username`: Nombre del usuario autenticado.

  ## Flujo
    - Solicita información sobre la pista y horario que se desea reservar.
    - Envía la solicitud de reserva al servidor.
    - Muestra un mensaje de éxito o error según la respuesta del servidor.

  ## Ejemplo
      iex> Cliente.reservar_pista(pid, "usuario1")
      :ok
  """

  def reservar_pista(pid, current_user) do
    number = IO.gets("\n  Introduzca el número de la pista a reservar (1-20) > ")
    number = String.trim(number)

    case Integer.parse(number) do
      {int_number, ""} ->
        response = Directorio.reservar_pista(pid, current_user, int_number)

        case response do
          {:error, :pista_no_existente} ->
            IO.puts(
              "\u001b[31m\n ------------\n  La pista introducida no existe\n ------------\n\u001b[0m"
            )

          {:error, :pista_ya_reservada} ->
            IO.puts(
              "\u001b[31m\n ------------\n  La pista introducida ya se encuentra reservada\n ------------\n\u001b[0m"
            )

          {:ok, _user} ->
            IO.puts(
              "\u001b[32m\n ------------\n  La pista #{int_number} ha sido reservada correctamente\n ------------\n\u001b[0m"
            )
        end

      _ ->
        IO.puts(
          "\u001b[31m\n ------------\n  Entrada inválida: por favor, introduzca un número válido\n ------------\n\u001b[0m"
        )
    end
  end

  # Liberar una pista reservada.
  @doc """
  Permite al usuario liberar una pista que tiene reservada.

  ## Parámetros
    - `pid`: PID del servidor al que se envía la solicitud.
    - `username`: Nombre del usuario autenticado.

  ## Flujo
    - Solicita información sobre la pista y horario que se desea liberar.
    - Envía la solicitud al servidor para liberar la reserva.
    - Muestra un mensaje de éxito o error según la respuesta del servidor.

  ## Ejemplo
      iex> Cliente.liberar_pista(pid, "usuario1")
      :ok
  """

  def liberar_pista(pid, current_user) do
    number = IO.gets("\n  Introduzca el número de la pista a liberar > ")
    number = String.trim(number)

    case Integer.parse(number) do
      {int_number, ""} ->
        response = Directorio.liberar_pista(pid, current_user, int_number)

        case response do
          {:error, :pista_no_existente} ->
            IO.puts(
              "\u001b[31m\n ------------\n  La pista introducida no existe\n ------------\n\u001b[0m"
            )

          {:error, :pista_no_reservada} ->
            IO.puts(
              "\u001b[31m\n ------------\n  La pista introducida no se encuentra reservada\n ------------\n\u001b[0m"
            )

          {:error, :no_autorizado} ->
            IO.puts(
              "\u001b[31m\n ------------\n  La pista introducida se encuentra reservada por otro usuario\n ------------\n\u001b[0m"
            )

          {:ok, _user} ->
            IO.puts(
              "\u001b[32m\n ------------\n  La pista #{int_number} ha sido liberada correctamente\n ------------\n\u001b[0m"
            )
        end

      _ ->
        IO.puts(
          "\u001b[31m\n ------------\n  Entrada inválida: por favor, introduzca un número válido\n ------------\n\u001b[0m"
        )
    end
  end
end
