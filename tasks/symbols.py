# SOURCE: https://github.com/ManrajGrover/py-log-symbols

"""Provide log symbols for various log levels."""
import platform
from enum import Enum

from colorama import Fore, deinit, init

init(autoreset=True)

_MAIN = {"info": "ℹ", "success": "✔", "warning": "⚠", "error": "✖"}

_FALLBACKS = {"info": "¡", "success": "v", "warning": "!!", "error": "×"}


def is_supported():
    """Check whether operating system supports main symbols or not.
    Returns
    -------
    boolean
        Whether operating system supports main symbols or not
    """

    os_arch = platform.system()

    return os_arch != "Windows"


_SYMBOLS = _MAIN if is_supported() else _FALLBACKS


class LogSymbols(Enum):  # pylint: disable=too-few-public-methods
    """LogSymbol enum class.
    Attributes
    ----------
    ERROR : str
        Colored error symbol
    INFO : str
        Colored info symbol
    SUCCESS : str
        Colored success symbol
    WARNING : str
        Colored warning symbol
    """

    INFO = Fore.BLUE + _SYMBOLS["info"] + Fore.RESET
    SUCCESS = Fore.GREEN + _SYMBOLS["success"] + Fore.RESET
    WARNING = Fore.YELLOW + _SYMBOLS["warning"] + Fore.RESET
    ERROR = Fore.RED + _SYMBOLS["error"] + Fore.RESET


deinit()

#######################################################
# EG usage:
# from .symbols import LogSymbols #Enum
# print(LogSymbols.SUCCESS.value) # ✔
# print(LogSymbols.INFO.value) # ℹ
# print(LogSymbols.WARNING.value) # ⚠
# print(LogSymbols.ERROR.value) # ✖
#######################################################
