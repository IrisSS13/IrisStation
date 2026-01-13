import { CheckboxInput, type FeatureToggle } from '../../base';

export const use_tgui_player_panel: FeatureToggle = {
  name: 'Use modern player panel',
  category: 'ADMIN',
  description: 'Whether to use the new TGUI player panel or the old HTML one.',
  component: CheckboxInput,
};

export const auto_browser_inspect: FeatureToggle = {
  name: 'Auto browser inspect',
  category: 'ADMIN',
  description:
    'Automatically gives you the ability to inspect element, instead of having to use the verb to enable it.',
  component: CheckboxInput,
};
