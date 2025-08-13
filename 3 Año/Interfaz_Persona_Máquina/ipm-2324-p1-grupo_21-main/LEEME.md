Información para la correción actualmente:
Para cambiar de idioma y probar la Tarea 3 en el caso de el Admin lo hago con la sentencia LC_ALL=en_GB.utf8 python3 app.py , es recomendable ver que lenguajes tenemos instalados con locale -a

Implemente en el diagrama lo de los threads pero creo que esta mejor como estaba
por si acaso lo dejo por aqui para que le heches un vistazo -> 
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

    alt cocktail_more_info
        View->>Presenter: al_hacer_clic_en_coctel(coctel)
        Presenter->>CoctelObjecto: obtener_ingredientes()
        CoctelObjecto-->>Presenter: ingredientes

        loop busqueda_ingredientes
            Presenter->>Model: buscar_imagen_ingrediente(ingrediente)
            Model-->>Presenter: datos_ingrediente
            Presenter->>View: traduce_url_a_imagen(datos_ingrediente)
            View-->>Presenter: imagen
        end

        Presenter->>CoctelObjecto: coctel.establecer_lista_ingredientes_img(imagenes)
        Presenter->>View: actualizar_ver_coctel(coctel)
        View->>View: construir_caja_coctel()
        View->>View: construir_caja_ingrediente()
    end
