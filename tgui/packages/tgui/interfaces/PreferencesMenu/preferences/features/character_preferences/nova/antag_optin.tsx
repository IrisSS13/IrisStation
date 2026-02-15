// THIS IS A NOVA SECTOR UI FILE
import type { FeatureChoiced } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const antag_opt_in_status_pref: FeatureChoiced = {
  name: 'Be Antagonist Target',
  description:
    'This is for objective targetting and OOC consent.\
    By picking Round Remove, it means that you are okay with potential round-removal by antagonists. \
    Enabling any non-ghost antags \
    (revenant, abductor contractor, etc.) will force your opt-in to be, \
    at minimum, "Temporarily Inconvenience".',
  component: FeatureDropdownInput,
};
