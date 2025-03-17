import { FeatureChoiced } from '../../base';
import {
  FeatureDropdownInput,
  FeatureIconnedDropdownInput,
  FeatureWithIcons,
} from '../../dropdowns';

export const limp_cane: FeatureWithIcons<string> = {
  name: 'Limp Aid',
  component: FeatureIconnedDropdownInput,
};

export const limp_intensity: FeatureChoiced = {
  name: 'Limp Intensity',
  component: FeatureDropdownInput,
};

export const limp_side: FeatureChoiced = {
  name: 'Limp Side',
  component: FeatureDropdownInput,
};
