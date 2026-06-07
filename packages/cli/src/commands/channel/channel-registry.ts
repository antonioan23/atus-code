import type { ChannelPlugin } from '@atus-code/channel-base';

const registry = new Map<string, ChannelPlugin>();
let builtinsPromise: Promise<void> | null = null;

function ensureBuiltins(): Promise<void> {
  if (!builtinsPromise) {
    builtinsPromise = (async () => {
      const [telegram, weixin, dingtalk, feishu] = await Promise.all([
        import('@atus-code/channel-telegram'),
        import('@atus-code/channel-weixin'),
        import('@atus-code/channel-dingtalk'),
        import('@atus-code/channel-feishu'),
      ]);

      for (const mod of [telegram, weixin, dingtalk, feishu]) {
        registry.set(mod.plugin.channelType, mod.plugin);
      }
    })();
  }
  return builtinsPromise;
}

export function registerPlugin(plugin: ChannelPlugin): void {
  if (registry.has(plugin.channelType)) {
    throw new Error(
      `Channel type "${plugin.channelType}" is already registered.`,
    );
  }
  registry.set(plugin.channelType, plugin);
}

export async function getPlugin(
  channelType: string,
): Promise<ChannelPlugin | undefined> {
  await ensureBuiltins();
  return registry.get(channelType);
}

export async function supportedTypes(): Promise<string[]> {
  await ensureBuiltins();
  return [...registry.keys()];
}
