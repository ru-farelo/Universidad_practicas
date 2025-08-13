# Diseño software

<!-- ## Notas para el desarrollo de este documento
En este fichero debeis documentar el diseño software de la práctica.

> :warning: El diseño en un elemento "vivo". No olvideis actualizarlo
> a medida que cambia durante la realización de la práctica.

> :warning: Recordad que el diseño debe separar _vista_ y
> _estado/modelo_.
	 

El lenguaje de modelado es UML y debeis usar Mermaid para incluir los
diagramas dentro de este documento. Por ejemplo:


```
-->
```mermaid
classDiagram

class Model {
    	+realizar_busqueda(busqueda)
	+realizar_busqueda_ingrediente(busqueda)
	+realizar_random()
	+buscar_imagen_ingrediente(ingredientes)
	}
class Presenter {
	+run(aplication_id)
	+al_hacer_click_en_buscar_nombre(busqueda)
	+al_hacer_click_en_buscar_ingrediente(busqueda)
	+al_hacer_click_en_coctel(coctel)
	+al_hacer_click_en_random()
	+establecer_coctel(dic_coctel)
	}
class View {
	+set_handler(handler)
	+on_activate(app)
	+traduce_url_a_imagen(datos imagen)
	+construir_caja_coctel(coctel: CoctelObjectos)
	+construir_caja_ingrediente(ingrediente)
	+construir_app_ventana(app)
	+construir_vista_inicial()
	+anadir_coctel(coctel)
	+borrar_flowbox(flowbox)
	+actualizar_busqueda(cocteles:list)
	+on_row_activated(list_box,list_box_row)
	+on_child_activated(flowbox,child)
	+error_conexion_random()
	+actualizar_ver_coctel(coctel)
	+start_count()
	}
class CoctelObjecto{
	+establecer_id_bebida(id)
	+establecer_bebida(nombre)
	+establecer_si_es_alcoholico(alc)
	+establecer_vaso(vaso)
	+establecer_instrucciones(ins)
	+establecer_ingredientes(ingredientes)
	+establecer_medidas(medidas)
 	+establecer_imagen(imagen)
	+establecer_lista_ingredientes_img(lista de imagenes)
	+anadir_lista()
	+obtener_bebida()
	+obtener_imagen()
	+obtener_ingredientes()
	+obtener_medidas()
	+obtener_instrucciones()
	+obtener_vaso()
	+obtener_ingredientes_img_lista()
	+obtener_datos_imagen()
	}
class ViewHandler{
	+al_hacer_click_en_buscar_nombre()
	+al_hacer_clcik_en_buscar_ingrediente()
	+al_hacer_clic_en_coctel()
	+al_hacer_click_en_random()
	}
View ..> Gtk : << uses >>
	class Gtk
	<<package>> Gtk

	Presenter --> View
	Presenter --> Model
	ViewHandler --> View
	ViewHandler <|-- Presenter
	CoctelObjecto --> View

	

```

```mermaid
sequenceDiagram
    participant View
    participant Presenter
    participant CoctelObjecto
    participant Model
    participant Thread1
    participant Thread2

    activate Presenter
    activate View

    Presenter->>View: run_app()
    Presenter->>View: on_activate()
    View->>View: construir_app_ventana()
    View->>View: construir_vista_inicial()

    alt busqueda_coctel
        View->>Presenter: al_hacer_click_en_buscar_nombre(Busqueda)
        Presenter->>View: start_count()
        Presenter->>Model: realizar_busqueda(Busqueda)
        Model->>Model: requests.get("url" + fine_search)
        Model-->>Presenter: lista_cocteles

        loop busqueda_elementos 
            Presenter->>Presenter: obtener_coctel(elemento)
            Thread1->>Presenter: request.get(url_imagen)
            Presenter-->>Thread1 : Coctel	
        end

        Presenter->>View: actualizar_busqueda(lista_cocteles)
    end

    alt busqueda_ingrediente
        View->>Presenter: al_hacer_click_en_buscar_ingrediente(Busqueda)
        Presenter->>View : start_count()
        Presenter->>Model: realizar_busqueda_ingrediente(Busqueda)
        Model->>Model: requests.get("url" + fine_search)

        loop busqueda_cocteles
            Model->>Model: realizar_busqueda(coctel)
        end

        Model-->>Presenter: lista_cocteles

        loop busqueda_elementos 
            Presenter->>Presenter: obtener_coctel(elemento)
            Thread2->>Presenter: request.get(url_imagen)
            Presenter-->>Thread2 : Coctel	
        end

        Presenter->>View: actualizar_busqueda(lista_cocteles)
    end

    alt cocktail_random
        View->>Presenter: al_hacer_click_en_random()
        Presenter->>Model: realizar_random()
        Model->>Model: requests.get("url")
        Model->>Presenter: coctel
        Presenter->>View: actualizar_ver_coctel(coctel)
    end
```
