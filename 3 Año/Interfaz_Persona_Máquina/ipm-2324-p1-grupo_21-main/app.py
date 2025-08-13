from view import View
from model import Model
from presenter import Presenter

from pathlib import Path
import locale
import gettext

if __name__ == "__main__":
    locale.setlocale(locale.LC_ALL, '')
    LOCALE_DIR = Path(__file__).parent / "locale"
    print(LOCALE_DIR)
#    locale.bindtextdomain('CocktailBd', LOCALE_DIR)
    gettext.bindtextdomain('CocktailBd', LOCALE_DIR)
    gettext.textdomain('CocktailBd')
    presenter = Presenter(view=View(), model=Model())
    presenter.run(application_id="es.udc.fic.ipm.CocktailBd")
