from __future__ import annotations

from typing import Callable, Protocol

import gi
import requests
import gettext

gi.require_version('Gtk', '4.0')

from gi.repository import Gtk, GdkPixbuf, GLib, Gdk

run_on_main_thread = GLib.idle_add
_ = gettext.gettext


def run_app(application_id: str, on_activate: Callable) -> None:
    app = Gtk.Application(application_id=application_id)
    app.connect('activate', on_activate)
    app.run()


class FlowBoxWithData(Gtk.FlowBox):
    def __init__(self, coctel):
        super().__init__()
        self.data = coctel
        self.append(View.construir_caja_coctel(self, coctel))


class ViewHandler(Protocol):

    def al_hacer_click_en_buscar_nombre(self: str) -> None: pass
    
    def al_hacer_click_en_buscar_ingrediente(self: str) -> None: pass

    def al_hacer_click_en_coctel(self) -> None: pass
    
    def al_hacer_click_en_random(self) ->None: pass


class CoctelObjetos:

    def __init__(self):
        self.__image = None
        self.__str_imagen_atributos = None
        self.__str_medidas = None
        self.__str_ingredientes = None
        self.__str_instruciones = None
        self.__str_vaso = None
        self.__str_alcoholico = None
        self.__str_bebida = None
        self.__id_bebida = None
        self.__ingredientes_imagen_lista = []
        self.__datos = None

    def establecer_id_bebida(self, id: str):
        self.__id_bebida = id

    def establecer_bebida(self, nombre: str):
        self.__str_bebida = nombre

    def establecer_si_es_alcoholico(self, alc: str):
        self.__str_alcoholico = alc

    def establecer_vaso(self, vaso: str):
        self.__str_vaso = vaso

    def establecer_instrucciones(self, ins: str):
        self.__str_instruciones = ins

    def establecer_ingredientes(self, ing1: str, ing2: str, ing3: str, ing4: str, ing5: str, ing6: str, ing7: str,
                                ing8: str,
                                ):
        self.__str_ingredientes = [ing1, ing2, ing3, ing4, ing5, ing6, ing7, ing8]

    def establecer_medidas(self, ms1: str, ms2: str, ms3: str, ms4: str, ms5: str, ms6: str, ms7: str, ms8: str):
        self.__str_medidas = [ms1, ms2, ms3, ms4, ms5, ms6, ms7, ms8]

    def establecer_imagen(self, image: Gtk.Image):
        self.__image = image

    def establecer_datos_imagen(self, datos):
        self.__datos = datos

    def establecer_lista_ingredientes_img(self, images_list: list[Gtk.Image]):
        self.__ingredientes_imagen_lista = images_list

    def anadir_lista(self, coctel):
        self.__ingredientes_imagen_lista.append(coctel)

    def obtener_bebida(self) -> str:
        return self.__str_bebida

    def obtener_imagen(self) -> Gtk.Image:
        return self.__image

    def obtener_ingredientes(self) -> list[str]:
        return self.__str_ingredientes

    def obtener_medidas(self) -> list[str]:
        return self.__str_medidas

    def obtener_instrucciones(self) -> str:
        return self.__str_instruciones

    def obtener_vaso(self) -> str:
        return self.__str_vaso

    def obtener_ingredientes_img_lista(self) -> list[Gtk.Image]:
        return self.__ingredientes_imagen_lista

    def obtener_datos_imagen(self):
        return self.__datos


class View:

    def __init__(self) -> None:
        self.busqueda = False
        self.__ventana_app = None
        self.__flowbox_busqueda = Gtk.FlowBox()
        self.__flowbox_ingredientes = Gtk.FlowBox()
        self.list_box_busqueda = Gtk.ListBox()
        self.__imagen = Gtk.FlowBox()
        self.__nombre = None
        self.__instrucciones = None
        self.__vaso = None
        self.__handler = None

    def traduce_url_a_imagen(self, datos_imagen: str) -> Gtk.Image:
        cargador_pixbuf = GdkPixbuf.PixbufLoader()
        cargador_pixbuf.write(datos_imagen)
        cargador_pixbuf.close()
        pixbuf = cargador_pixbuf.get_pixbuf()

        return pixbuf

    def set_handler(self, handler: ViewHandler) -> None:
        self.__handler = handler

    def on_activate(self, app: Gtk.Application) -> None:
        self.construir_app_ventana(app)

    def construir_caja_coctel(self, coctel: CoctelObjetos) -> Gtk.Widget:
        fila_coctel = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)

        label_coctel = Gtk.Label()
        label_coctel.set_text(coctel.obtener_bebida())
        label_coctel.set_valign(Gtk.Align.START)
        label_coctel.set_margin_top(15)
        label_coctel.set_margin_start(15)
        label_coctel.set_margin_end(15)

        imagen = Gtk.Image.new_from_pixbuf(coctel.obtener_imagen())
        imagen.set_pixel_size(150)

        fila_coctel.append(imagen)
        fila_coctel.append(label_coctel)
        fila_coctel.set_margin_top(15)
        fila_coctel.set_margin_start(15)
        fila_coctel.set_margin_end(15)

        return fila_coctel

    def construir_caja_ingrediente(self, ingrediente: str, medida: str, imagen_ingrediente: Gtk.Image) -> Gtk.Widget:
        caja_ingrediente = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)

        texto_etiqueta = ingrediente
        if medida:
            texto_etiqueta += " " + _(medida)

        etiqueta_ingrediente = Gtk.Label()
        etiqueta_ingrediente.set_text(texto_etiqueta)
        etiqueta_ingrediente.set_valign(Gtk.Align.START)
        etiqueta_ingrediente.set_margin_top(15)
        etiqueta_ingrediente.set_margin_start(15)
        etiqueta_ingrediente.set_margin_end(15)

        imagen_ingrediente.set_pixel_size(150)

        caja_ingrediente.append(imagen_ingrediente)
        caja_ingrediente.append(etiqueta_ingrediente)

        return caja_ingrediente

    def construir_app_ventana(self, app: Gtk.Applition) -> None:

        self.__ventana_app = Gtk.ApplicationWindow(title="CocktailBd")
        app.add_window(self.__ventana_app)

        self.__ventana_app.set_default_size(1000, 800)

        self.construir_vista_inicial()

        self.__ventana_app.present()

    def construir_vista_inicial(self) -> None:
        label_nombre=Gtk.Label()
        label_nombre.set_text("Nombre:")
        label_nombre.set_margin_top(15)

        # Crear la barra de búsqueda
        barra_busqueda_nombre = Gtk.SearchEntry()
        barra_busqueda_nombre.set_valign(Gtk.Align.START)
        barra_busqueda_nombre.set_hexpand(True)
        barra_busqueda_nombre.set_margin_top(15)

        # Conectar la señal "activate" para activar la búsqueda al presionar Enter
        barra_busqueda_nombre.connect('activate', lambda entry: self.__handler.al_hacer_click_en_buscar_nombre(entry.get_text()))
        label_ingrediente=Gtk.Label()
        label_ingrediente.set_text("Ingrediente:")
        label_ingrediente.set_margin_top(15)
        barra_busqueda_ingrediente = Gtk.SearchEntry()
        barra_busqueda_ingrediente.set_valign(Gtk.Align.START)
        barra_busqueda_ingrediente.set_hexpand(True)
        barra_busqueda_ingrediente.set_margin_top(15)

        # Conectar la señal "activate" para activar la búsqueda al presionar Enter
        barra_busqueda_ingrediente.connect('activate', 
            lambda entry: self.__handler.al_hacer_click_en_buscar_ingrediente(entry.get_text()))
        boton_random=Gtk.Button()
        boton_random.set_valign(Gtk.Align.START)
        boton_random.set_label("Random")
        boton_random.set_margin_top(15)
        boton_random.connect('clicked', lambda entry: self.__handler.al_hacer_click_en_random())
        # Crear el botón de Spinner y contenedor para los botones
        self.spinner = Gtk.Spinner()
        self.spinner.set_halign(Gtk.Align.CENTER)
        self.spinner.set_valign(Gtk.Align.CENTER)
        self.spinner.set_spinning(True)
        self.spinner.set_visible(False)  # Establecer visible a False inicialmente

        caja_botones = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=14)
        caja_botones.set_hexpand(True)
        caja_botones.set_valign(Gtk.Align.START)
        caja_botones.set_margin_top(15)

        # Añadir la barra de búsqueda y el botón de Spinner al contenedor
        caja_botones.append(label_nombre)
        caja_botones.append(barra_busqueda_nombre)
        caja_botones.append(label_ingrediente)
        caja_botones.append(barra_busqueda_ingrediente)
        caja_botones.append(self.spinner)
        caja_botones.append(boton_random)

        # Crear la ventana deslizante
        ventana_deslizante = Gtk.ScrolledWindow(has_frame=True)
        ventana_deslizante.set_hexpand(True)
        ventana_deslizante.set_vexpand(True)
        ventana_deslizante.set_halign(Gtk.Align.BASELINE)
        ventana_deslizante.set_placement(Gtk.CornerType.TOP_LEFT)

        ventana_deslizante.set_margin_bottom(15)

        # Configurar la flowbox y añadirla a la ventana desizante
        
        ventana_deslizante.set_child(self.__flowbox_busqueda)

        # Añadir la caja de búsqueda y la ventana deslizante al contenedor principal
        caja_ventana_izq = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        caja_ventana_izq.set_hexpand(False)
        caja_ventana_izq.set_margin_start(10)
        caja_ventana_izq.append(caja_botones)
        caja_ventana_izq.append(ventana_deslizante)

        caja_nombre_imagen = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)
        caja_nombre_imagen.set_margin_top(15)
        caja_nombre_imagen.set_margin_start(15)

        # Ventana derecha
        # Crear caja con imagen y nombre del coctel seleccionado

        self.__nombre = Gtk.Label()
        self.__nombre.set_halign(Gtk.Align.CENTER)
        self.__imagen.set_halign(Gtk.Align.CENTER)
        caja_nombre_imagen.append(self.__imagen)
        caja_nombre_imagen.append(self.__nombre)

        # Crear la caja de ingredientes

        titulo_ingredientes = Gtk.Label()
        titulo_ingredientes.set_text(_("INGREDIENTES"))

        # Crera la caja de instrucciones y vaso
        titulo_instrucciones = Gtk.Label()
        titulo_instrucciones.set_text(_("INSTRUCCIONES"))
        self.__instrucciones = Gtk.Label()
        self.__instrucciones.set_wrap(True)
        self.__vaso = Gtk.Label()
        self.__vaso.set_text(_("TIPO DE VASO: "))

        # Introducir las cajas de ingredientes, instrucciones y vaso en la caja contenedora
        caja_ingredientes_instrucciones = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)
        caja_ingredientes_instrucciones.set_margin_top(15)

        caja_ingredientes_instrucciones.append(titulo_ingredientes)
        caja_ingredientes_instrucciones.append(self.__flowbox_ingredientes)
        caja_ingredientes_instrucciones.append(titulo_instrucciones)
        caja_ingredientes_instrucciones.append(self.__instrucciones)
        caja_ingredientes_instrucciones.append(self.__vaso)

        # Creacion de la ventana deslizante para ingredientes, instrucciones y vaso
        ventana_deslizante_coctel = Gtk.ScrolledWindow(has_frame=True)
        ventana_deslizante_coctel.set_hexpand(True)
        ventana_deslizante_coctel.set_vexpand(True)
        ventana_deslizante_coctel.set_halign(Gtk.Align.BASELINE)
        ventana_deslizante_coctel.set_placement(Gtk.CornerType.TOP_LEFT)
        ventana_deslizante_coctel.set_margin_end(15)
        ventana_deslizante_coctel.set_margin_top(7)

        ventana_deslizante_coctel.set_child(caja_ingredientes_instrucciones)

        # Creacion ventana derecha
        caja_ventana_der = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)
        caja_ventana_der.set_margin_top(15)
        caja_ventana_der.set_margin_end(15)
        caja_ventana_der.set_margin_bottom(15)

        caja_ventana_der.append(caja_nombre_imagen)
        caja_ventana_der.append(ventana_deslizante_coctel)

        # Creacion ventana principal
        ventana = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=15)

        ventana.append(caja_ventana_izq)
        ventana.append(caja_ventana_der)
        self.__ventana_app.set_child(ventana)

    def anadir_coctel(self, coctel):
        list_box_row = Gtk.ListBoxRow()
        list_box_row.set_child(self.construir_caja_coctel(coctel))
        list_box_row.data = coctel  # Store the coctel object in the row
        listbox=Gtk.ListBox()
        listbox.append(list_box_row)
        listbox.connect("row-activated", self.on_row_activated)
        listbox.set_selection_mode(Gtk.SelectionMode.NONE)
        self.__flowbox_busqueda.insert(listbox, -1)


    def borrar_flowbox(self, flowbox):
        child = flowbox.get_child_at_index(0)
        while child != None:
            flowbox.remove(child)
            child = flowbox.get_child_at_index(0)

    def actualizar_busqueda(self, cocteles: list):
        flowbox_cocteles = self.__flowbox_busqueda
        self.borrar_flowbox(flowbox_cocteles)

        if cocteles is None:
            ventana_error = Gtk.Label()
            ventana_error.set_text(_("No hay conexión a internet. Por favor, verifica tu conexión."))
            ventana_error.set_wrap(True)
            self.spinner.set_visible(False)
            flowbox_cocteles.append(ventana_error)


        elif not cocteles:
            ventana_error = Gtk.Label()
            ventana_error.set_text(_("No existe el coctel/ingrediente que has buscado. Por favor, asegúrate de escribirlo bien."))
            ventana_error.set_wrap(True)
            flowbox_cocteles.append(ventana_error)
            # Ocultar el spinner cuando no se encuentran resultados
            self.spinner.set_visible(False)
        flowbox_cocteles.connect("child-activated", self.on_child_activated)

    def on_row_activated(self, list_box, list_box_row):
        index = list_box_row.get_index()
        coctel = list_box_row.data
        self.__handler.al_hacer_click_en_coctel(coctel)
    def on_child_activated(self, flowbox, child):
        self.__handler.al_hacer_click_en_coctel(child.get_child().get_row_at_index(0).data)

    def error_conexion_random(self):
        ventana_error = Gtk.Label()
        ventana_error.set_text(_("No hay conexión a internet. Por favor, verifica tu conexión."))
        ventana_error.set_wrap(True)
        child = self.__imagen.get_child_at_index(0)
        if child is not None:
            self.__imagen.remove(child)
        self.__imagen.append(ventana_error)

    def actualizar_ver_coctel(self, coctel):
        self.borrar_flowbox(self.__flowbox_ingredientes)
        datos_imagen = coctel.obtener_datos_imagen()
        imagen = Gtk.Image.new_from_pixbuf(self.traduce_url_a_imagen(datos_imagen))
        imagen.set_pixel_size(150)
        child = self.__imagen.get_child_at_index(0)
        if child is not None:
            self.__imagen.remove(child)
        self.__imagen.append(imagen)
        self.__nombre.set_text(coctel.obtener_bebida())

        ingredientes = coctel.obtener_ingredientes()
        medidas = coctel.obtener_medidas()
        imagenes_ingredientes = coctel.obtener_ingredientes_img_lista()
        flowbox_ingredientes = self.__flowbox_ingredientes

        if not imagenes_ingredientes:
            ventana_error = Gtk.Label()
            ventana_error.set_text(_("No se han podido descargar las imágenes,revise su conexión a internet"))
            ventana_error.set_wrap(True)
            flowbox_ingredientes.append(ventana_error)

        for ingrediente, medida, imagen in zip(ingredientes, medidas, imagenes_ingredientes):
            if ingrediente is None:
                break
            if medida is None:
                caja_ingrediente = self.construir_caja_ingrediente(ingrediente, "",
                                                                   Gtk.Image.new_from_pixbuf(imagen))
            else:
                caja_ingrediente = self.construir_caja_ingrediente(ingrediente, medida,
                                                                   Gtk.Image.new_from_pixbuf(imagen))
            flowbox_ingredientes.append(caja_ingrediente)

        self.__instrucciones.set_text(coctel.obtener_instrucciones())

        self.__vaso.set_text(_("TIPO DE VASO: ") + coctel.obtener_vaso())

    def start_count(self) -> None:
        self.spinner.set_visible(True)
        self.busqueda = True

    def stop_count(self) -> None:
        self.spinner.set_visible(False)
        self.busqueda = False