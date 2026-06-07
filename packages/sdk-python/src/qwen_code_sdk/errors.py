"""Error types for atus_code_sdk."""

from __future__ import annotations


class AtusSDKError(Exception):
    """Base error for all SDK failures."""


class ValidationError(AtusSDKError):
    """Raised when query options are invalid."""


class AbortError(AtusSDKError):
    """Raised when an operation is aborted by caller or transport."""


class ProcessExitError(AtusSDKError):
    """Raised when atus CLI exits with non-zero status or signal."""

    def __init__(self, message: str, exit_code: int | None = None) -> None:
        super().__init__(message)
        self.exit_code = exit_code


class ControlRequestTimeoutError(AtusSDKError):
    """Raised when a control request times out waiting for response."""
