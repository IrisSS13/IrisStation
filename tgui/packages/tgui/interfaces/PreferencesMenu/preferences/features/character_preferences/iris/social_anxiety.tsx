import type { Feature } from '../../base';
import { FeatureNumberInput } from '../../base';

export const social_anxiety: Feature<number> = {
  name: 'Block Speech Chance',
  component: FeatureNumberInput,
};
