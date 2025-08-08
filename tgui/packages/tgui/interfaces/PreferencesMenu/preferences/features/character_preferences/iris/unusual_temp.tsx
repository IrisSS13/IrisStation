import { Feature, FeatureNumberInput } from '../../base';

export const unusual_bodytemp: Feature<number> = {
  name: 'Temperature Difference',
  component: FeatureNumberInput,
};
