import { CheckboxInput, FeatureToggle } from '../../base';

export const eorgpreference: FeatureToggle = {
  name: 'Allow combat at the end of the round (EORG)',
  category: 'GAMEPLAY',
  description:
    'If disabled you will become non-dense, invisible and pacifistic at the end of the round',
  component: CheckboxInput,
};
