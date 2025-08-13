
import requests


class Model:

    def __init__(self):
        pass

    def realizar_busqueda(self, busqueda: str):
        try:
            busqueda_fina = busqueda.replace(" ", "+")
            respuesta = requests.get("https://www.thecocktaildb.com/api/json/v1/1/search.php?s=" + busqueda_fina)
            respuesta.raise_for_status()  # Lanza una excepción si la respuesta indica un error HTTP

            cocteles_json = respuesta.json()["drinks"]
            if cocteles_json is None:
                return []


            return cocteles_json

        except requests.exceptions.RequestException as e:
            # Captura la excepción en caso de problemas con la solicitud HTTP
            print("Error de conexión a Internet:", e)
            return None
    def realizar_busqueda_ingrediente(self, busqueda: str):
        cocteles=[]
        try:
            busqueda_fina = busqueda.replace(" ", "+")
            respuesta = requests.get("https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=" + busqueda_fina)
            respuesta.raise_for_status()  # Lanza una excepción si la respuesta indica un error HTTP
            if respuesta.text=="":
                return[]

            cocteles_json = respuesta.json()["drinks"]
            
            if cocteles_json is None:
                return []
            for i in range(0,10):
                coctel=self.realizar_busqueda(cocteles_json[i]["strDrink"])[0]
                cocteles.insert(i,coctel)


            return cocteles

        except requests.exceptions.RequestException as e:
            # Captura la excepción en caso de problemas con la solicitud HTTP
            print("Error de conexión a Internet:", e)
            return None
        except requests.exceptions.InvalidURL as e:
            print("Error de conexión a Internet:", e)
            return None
    def realizar_random(self):
        try:
            
            respuesta = requests.get("https://www.thecocktaildb.com/api/json/v1/1/random.php")
            respuesta.raise_for_status()  # Lanza una excepción si la respuesta indica un error HTTP

            cocteles_json = respuesta.json()["drinks"]
            

            return cocteles_json

        except requests.exceptions.RequestException as e:
            # Captura la excepción en caso de problemas con la solicitud HTTP
            print("Error de conexión a Internet:", e)
            return None

    def buscar_imagen_ingrediente(self, ingrediente: str) -> str:
        ingrediente_fino = ingrediente.replace(" ", "%20")

        respuesta = requests.get("https://www.thecocktaildb.com/images/ingredients/" + ingrediente_fino + ".png")
        datos_imagen = respuesta.content


        return datos_imagen
