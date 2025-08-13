import requests

from view import View, run_app, run_on_main_thread, CoctelObjetos
from model import Model

from threading import Thread
from datetime import datetime


class Presenter:

    def __init__(self, view: View, model: Model):
        self.view = view
        self.model = model
        self.__imagenes_descargadas = {}

    def run(self, application_id: str):
        self.view.set_handler(self)
        run_app(application_id, self.view.on_activate)

    def al_hacer_click_en_buscar_nombre(self, busqueda: str) -> None:
        def do_search(resuelto: list):
            try:
                if resuelto is None:
                    # Manejar el caso en el que la respuesta del servidor sea None
                    run_on_main_thread(self.view.actualizar_busqueda, None)
                else:
                    for elemento in resuelto:
                        coctel=self.establecer_coctel(elemento)
                        run_on_main_thread(self.view.anadir_coctel, coctel)
                run_on_main_thread(self.view.stop_count)
            except requests.exceptions.RequestException as e:
                # Manejar la excepción de conexión a Internet
                run_on_main_thread(self.view.actualizar_busqueda, "Error de conexión a Internet: " + str(e))

        if not self.view.busqueda:
            self.view.start_count()
            resuelto = self.model.realizar_busqueda(busqueda)
            self.view.actualizar_busqueda(resuelto)
            Thread(target=do_search, args=(resuelto,)).start()
    def al_hacer_click_en_buscar_ingrediente(self, busqueda: str) -> None:
        def do_search_ingrediente(resuelto: list):
            try:
                if resuelto is None:
                    # Manejar el caso en el que la respuesta del servidor sea None
                    run_on_main_thread(self.view.actualizar_busqueda, None)
                else:
                    for elemento in resuelto:
                        coctel=self.establecer_coctel(elemento)
                        run_on_main_thread(self.view.anadir_coctel, coctel)
                run_on_main_thread(self.view.stop_count)
            except requests.exceptions.RequestException as e:
                # Manejar la excepción de conexión a Internet
                run_on_main_thread(self.view.actualizar_busqueda, "Error de conexión a Internet: " + str(e))

        if not self.view.busqueda:
            self.view.start_count()
            resuelto = self.model.realizar_busqueda_ingrediente(busqueda)
            self.view.actualizar_busqueda(resuelto)
            Thread(target=do_search_ingrediente, args=(resuelto,)).start()

    def al_hacer_click_en_coctel(self, coctel) -> None:
        lista_imagenes = []
        threads=[]

        def descargar_imagen(ingrediente):
            try:
                datos_imagen = self.model.buscar_imagen_ingrediente(ingrediente)
                imagen = self.view.traduce_url_a_imagen(datos_imagen)
                self.__imagenes_descargadas[ingrediente] = imagen
                lista_imagenes.append(imagen)
            except requests.exceptions.RequestException as e:
                # Manejar la excepción de descarga de imagen
                print("Error al descargar la imagen:", str(e))

        for ingrediente in coctel.obtener_ingredientes():
            if ingrediente is None:
                break
            elif ingrediente in self.__imagenes_descargadas:
                imagen = self.__imagenes_descargadas[ingrediente]
                lista_imagenes.append(imagen)
            else:
                x = Thread(target=descargar_imagen, args=(ingrediente,))
                x.start()
                threads.append(x)
        for thread in threads:
            thread.join()

        coctel.establecer_lista_ingredientes_img(lista_imagenes)
        self.view.actualizar_ver_coctel(coctel)

    def al_hacer_click_en_random (self) ->None:
        coctel=self.model.realizar_random()
        if coctel is None:
            self.view.error_conexion_random()
        else:
            self.al_hacer_click_en_coctel(self.establecer_coctel(coctel[0]))

    def establecer_coctel(self, coctel_dic) -> CoctelObjetos:
        coctel = CoctelObjetos()

        coctel.establecer_id_bebida(coctel_dic["idDrink"])
        coctel.establecer_bebida(coctel_dic["strDrink"])
        coctel.establecer_si_es_alcoholico(coctel_dic["strAlcoholic"])
        coctel.establecer_vaso(coctel_dic["strGlass"])
        coctel.establecer_instrucciones(coctel_dic["strInstructions"])
        coctel.establecer_ingredientes(coctel_dic["strIngredient1"], coctel_dic["strIngredient2"],
                                       coctel_dic["strIngredient3"], coctel_dic["strIngredient4"],
                                       coctel_dic["strIngredient5"], coctel_dic["strIngredient6"],
                                       coctel_dic["strIngredient7"], coctel_dic["strIngredient8"],
                                       )
        coctel.establecer_medidas(coctel_dic["strMeasure1"], coctel_dic["strMeasure2"], coctel_dic["strMeasure3"],
                                  coctel_dic["strMeasure4"], coctel_dic["strMeasure5"], coctel_dic["strMeasure6"],
                                  coctel_dic["strMeasure7"], coctel_dic["strMeasure8"])
        respuesta = requests.get(coctel_dic["strDrinkThumb"])
        datos_imagen = respuesta.content
        coctel.establecer_datos_imagen(datos_imagen)
        coctel.establecer_imagen(self.view.traduce_url_a_imagen(datos_imagen))
        return coctel
#
