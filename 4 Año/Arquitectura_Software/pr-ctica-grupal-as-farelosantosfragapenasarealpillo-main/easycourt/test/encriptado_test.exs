defmodule EncriptadoTest do
  @moduledoc """
  **EncriptadoTest** es un módulo que contiene casos de prueba para el módulo `Encriptado`,
  el cual es responsable de encriptar y desencriptar contraseñas.

  Las pruebas cubren varios casos para los procesos de encriptación y desencriptación,
  incluyendo contraseñas con diferentes longitudes, caracteres y combinaciones.

  ## Funciones de prueba

  - `password`: Prueba encriptar y desencriptar una contraseña regular.
  - `con 1 caracter`: Prueba encriptar y desencriptar una contraseña de un solo carácter.
  - `con varios caracteres`: Prueba encriptar y desencriptar una contraseña con varios caracteres.
  - `combinaciones`: Prueba encriptar y desencriptar una contraseña con caracteres especiales y números.

  ## Ejemplo

      # Ejecutar todas las pruebas
      mix test
  """
  use ExUnit.Case

  @doc """
  Prueba la encriptación y desencriptación de una contraseña regular.

  Encripta la contraseña `"password"` y verifica que desencriptarla devuelve la contraseña original.

  ## Datos de prueba:
    - Entrada: La contraseña `"password"`.
    - Salida esperada: La contraseña original `"password"` después de la desencriptación.
  """
  test "password" do
    pass_encriptada = Encriptado.encriptar("password")
    assert Encriptado.desencriptar(pass_encriptada) == "password"
  end

  @doc """
  Prueba la encriptación y desencriptación de una contraseña de un solo carácter.

  Encripta la contraseña `"e"` y verifica que desencriptarla devuelve la contraseña original.

  ## Datos de prueba:
    - Entrada: La contraseña `"e"`.
    - Salida esperada: La contraseña original `"e"` después de la desencriptación.
  """
  test "con 1 caracter" do
    pass_encriptada = Encriptado.encriptar("e")
    assert Encriptado.desencriptar(pass_encriptada) == "e"
  end

  @doc """
  Prueba la encriptación y desencriptación de una contraseña con varios caracteres.

  Encripta la contraseña `"holaholaholas"` y verifica que desencriptarla devuelve la contraseña original.

  ## Datos de prueba:
    - Entrada: La contraseña `"holaholaholas"`.
    - Salida esperada: La contraseña original `"holaholaholas"` después de la desencriptación.
  """
  test "con varios caracteres" do
    pass_encriptada = Encriptado.encriptar("holaholaholas")
    assert Encriptado.desencriptar(pass_encriptada) == "holaholaholas"
  end

  @doc """
  Prueba la encriptación y desencriptación de una contraseña con caracteres especiales y números.

  Encripta la contraseña `"as12*@3"` y verifica que desencriptarla devuelve la contraseña original.

  ## Datos de prueba:
    - Entrada: La contraseña `"as12*@3"`.
    - Salida esperada: La contraseña original `"as12*@3"` después de la desencriptación.
  """
  test "combinaciones" do
    pass_encriptada = Encriptado.encriptar("as12*@3")
    assert Encriptado.desencriptar(pass_encriptada) == "as12*@3"
  end
end
