import { type Feature, FeatureColorInput } from '../../base';

export const holo_color: Feature<string> = {
  name: 'Holosynth Color',
  description: 'Color used for holosynth holograms.',
  component: FeatureColorInput,
};
