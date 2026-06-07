/**
 * @license
 * Copyright 2025 Atus Code
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Config } from '@atus-code/atus-code-core';

export function hasBlockingBackgroundWork(config: Config): boolean {
  return (
    config.getBackgroundTaskRegistry().hasUnfinalizedTasks() ||
    config.getMonitorRegistry().getRunning().length > 0 ||
    config.getBackgroundShellRegistry().hasRunningEntries()
  );
}

export function resetBackgroundStateForSessionSwitch(config: Config): void {
  config.getBackgroundTaskRegistry().reset();
  config.getMonitorRegistry().reset();
  config.getBackgroundShellRegistry().reset();
}
