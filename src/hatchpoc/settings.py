""" settings """
from __future__ import annotations

import enum

from pydantic import BaseSettings


class LogLevel(str, enum.Enum):  # noqa: WPS600
    """Possible log levels."""

    NOTSET = "NOTSET"
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARNING = "WARNING"
    ERROR = "ERROR"
    FATAL = "FATAL"


class AioSettings(BaseSettings):
    """
    Application settings.

    These parameters can be configured
    with environment variables.
    """

    timezone: str = "america/new_york"

    log_level: LogLevel = LogLevel.DEBUG

    class Config:  # sourcery skip: docstrings-for-classes
        env_file = ".env"
        env_prefix = "HATCH_POC_CONFIG_"
        env_file_encoding = "utf-8"


aiosettings = (
    AioSettings()
)  # sourcery skip: docstrings-for-classes, avoid-global-variables

#
#
#
