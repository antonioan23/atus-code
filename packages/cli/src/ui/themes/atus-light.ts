/**
 * @license
 * Copyright 2025 Google LLC
 * SPDX-License-Identifier: Apache-2.0
 */

import { type ColorsTheme, Theme } from './theme.js';
import { lightSemanticColors } from './semantic-tokens.js';

const atusLightColors: ColorsTheme = {
  type: 'light',
  Background: '#f8f9fa',
  Foreground: '#5c6166',
  LightBlue: '#55b4d4',
  AccentBlue: '#399ee6',
  AccentPurple: '#a37acc',
  AccentCyan: '#4cbf99',
  AccentGreen: '#86b300',
  AccentYellow: '#f2ae49',
  AccentRed: '#f07171',
  AccentYellowDim: '#8B7000',
  AccentRedDim: '#993333',
  DiffAdded: '#86b300',
  DiffRemoved: '#f07171',
  Comment: '#ABADB1',
  Gray: '#CCCFD3',
  GradientColors: ['#399ee6', '#86b300'],
};

export const AtusLight: Theme = new Theme(
  'Qwen Light',
  'light',
  {
    hljs: {
      display: 'block',
      overflowX: 'auto',
      padding: '0.5em',
      background: atusLightColors.Background,
      color: atusLightColors.Foreground,
    },
    'hljs-comment': {
      color: atusLightColors.Comment,
      fontStyle: 'italic',
    },
    'hljs-quote': {
      color: atusLightColors.AccentCyan,
      fontStyle: 'italic',
    },
    'hljs-string': {
      color: atusLightColors.AccentGreen,
    },
    'hljs-constant': {
      color: atusLightColors.AccentCyan,
    },
    'hljs-number': {
      color: atusLightColors.AccentPurple,
    },
    'hljs-keyword': {
      color: atusLightColors.AccentYellow,
    },
    'hljs-selector-tag': {
      color: atusLightColors.AccentYellow,
    },
    'hljs-attribute': {
      color: atusLightColors.AccentYellow,
    },
    'hljs-variable': {
      color: atusLightColors.Foreground,
    },
    'hljs-variable.language': {
      color: atusLightColors.LightBlue,
      fontStyle: 'italic',
    },
    'hljs-title': {
      color: atusLightColors.AccentBlue,
    },
    'hljs-section': {
      color: atusLightColors.AccentGreen,
      fontWeight: 'bold',
    },
    'hljs-type': {
      color: atusLightColors.LightBlue,
    },
    'hljs-class .hljs-title': {
      color: atusLightColors.AccentBlue,
    },
    'hljs-tag': {
      color: atusLightColors.LightBlue,
    },
    'hljs-name': {
      color: atusLightColors.AccentBlue,
    },
    'hljs-builtin-name': {
      color: atusLightColors.AccentYellow,
    },
    'hljs-meta': {
      color: atusLightColors.AccentYellow,
    },
    'hljs-symbol': {
      color: atusLightColors.AccentRed,
    },
    'hljs-bullet': {
      color: atusLightColors.AccentYellow,
    },
    'hljs-regexp': {
      color: atusLightColors.AccentCyan,
    },
    'hljs-link': {
      color: atusLightColors.LightBlue,
    },
    'hljs-deletion': {
      color: atusLightColors.AccentRed,
    },
    'hljs-addition': {
      color: atusLightColors.AccentGreen,
    },
    'hljs-emphasis': {
      fontStyle: 'italic',
    },
    'hljs-strong': {
      fontWeight: 'bold',
    },
    'hljs-literal': {
      color: atusLightColors.AccentCyan,
    },
    'hljs-built_in': {
      color: atusLightColors.AccentRed,
    },
    'hljs-doctag': {
      color: atusLightColors.AccentRed,
    },
    'hljs-template-variable': {
      color: atusLightColors.AccentCyan,
    },
    'hljs-selector-id': {
      color: atusLightColors.AccentRed,
    },
  },
  atusLightColors,
  lightSemanticColors,
);
