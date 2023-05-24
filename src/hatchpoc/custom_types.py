"""custom_types"""
# SOURCE: https://github.com/fredrikaverpil/fredrikaverpil.github.io/blob/d9418028a32cc55994cc3d2e830b6f9cc450c025/mkdocs/cheat-sheets/python.md

from __future__ import annotations

from types import TracebackType
from typing import TypeAlias, Union

ExcInfo: TypeAlias = tuple[type[BaseException], BaseException, TracebackType]
OptExcInfo: TypeAlias = Union[ExcInfo, tuple[None, None, None]]


JsonType: TypeAlias = (
    None | bool | int | float | str | list["JsonType"] | dict[str, "JsonType"]
)
JsonDict: TypeAlias = dict[str, "JsonType"]
