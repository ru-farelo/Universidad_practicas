defmodule Encriptado do
  @moduledoc """
  Este módulo proporciona funciones para encriptar y desencriptar texto plano,
  utilizado principalmente en el cliente para asegurar el almacenamiento de contraseñas.

  Utiliza el algoritmo AES de 128 bits en modo CBC. La clave pública y el IV (vector de inicialización)
  son constantes globales en este módulo, lo que simplifica la implementación pero también
  implica que ambos deben ser gestionados cuidadosamente.

  ## Constantes
  - `@key`: La clave de encriptación en formato hexadecimal.
  - `@iv`: El vector de inicialización (IV) en formato hexadecimal.
  - `@size`: El tamaño de bloque utilizado por el algoritmo AES.
  - `@cypher`: El algoritmo de encriptación AES-128-CBC.
  """

  @key "A5CC34E866FA820440A46A83FD013365"
  @iv "1A6DD3809BA50122EA61B0DE722F4C87"
  @size 16
  @cypher :aes_128_cbc

  @doc """
  Encripta el texto que se le pasa como parámetro.

  ## Parámetros:
    - `text`: El texto que queremos encriptar.

  ## Retorna:
    - El texto encriptado, codificado en Base64.

  ## Ejemplo

      iex> Encriptado.encriptar("miContraseñaSecreta")
      "2D9fD4...dWwzD5k="
  """
  def encriptar(text) do
    # Decodificamos la IV desde su forma hexadecimal
    iv_dc = Base.decode16!(@iv)
    # Decodificamos la clave desde su forma hexadecimal
    key_dc = Base.decode16!(@key)
    # Añadimos padding al texto para que sea múltiplo de @size
    text = add_padding(text)
    encrypted_text = :crypto.crypto_one_time(@cypher, key_dc, iv_dc, text, true)
    # Concatenamos IV + texto encriptado
    encrypted_text = iv_dc <> encrypted_text
    # Codificamos en Base64 antes de devolver
    Base.encode64(encrypted_text)
  end

  defp add_padding(text) do
    # Calculamos el padding necesario para que el texto tenga un tamaño múltiplo de @size
    to_add = @size - rem(byte_size(text), @size)
    text <> :binary.copy(<<to_add>>, to_add)
  end

  @doc """
  Desencripta el texto que se le pasa como parámetro.

  ## Parámetros:
    - `ciphertext`: El texto cifrado que queremos desencriptar, codificado en Base64.

  ## Retorna:
    - El texto desencriptado.

  ## Ejemplo

      iex> Encriptado.desencriptar("2D9fD4...dWwzD5k=")
      "miContraseñaSecreta"
  """
  def desencriptar(ciphertext) do
    # Decodificamos la clave
    key_dc = Base.decode16!(@key)
    # Decodificamos la IV
    iv_dc = Base.decode16!(@iv)
    # Decodificamos de Base64 a binario
    ciphertext = Base.decode64!(ciphertext)

    <<iv_from_cipher::binary-16, encrypted_text::binary>> = ciphertext

    if iv_from_cipher != iv_dc do
      # Verificamos que el IV coincida
      raise "IV no coincide con el IV original"
    end

    decrypted_text = :crypto.crypto_one_time(@cypher, key_dc, iv_dc, encrypted_text, false)
    # Quitamos el padding que añadimos durante la encriptación
    remove_padding(decrypted_text)
  end

  defp remove_padding(decrypted_text) do
    # Calculamos el padding que añadimos y lo removemos
    to_remove = :binary.last(decrypted_text)
    :binary.part(decrypted_text, 0, byte_size(decrypted_text) - to_remove)
  end
end
