// THIS IS A NOVA SECTOR UI FILE
import { Feature, FeatureShortTextInput } from '../../base';

const description =
  'Requires a link ending with .png, .jpeg, or .jpg, starting with \
  https://, and hosted on Gyazo, Imgbox or Catbox.moe. Renders the image underneath \
  your character preview in the examine more window. \
  Image larger than 250x250 will be resized to 250x250. \
A im for 250x250 whenever possible. You cannot \
  use headshots until you have played for 5 hours.';

export const headshot: Feature<string> = {
  name: 'Headshot',
  description: description,
  component: FeatureShortTextInput,
};

export const silicon_headshot: Feature<string> = {
  name: 'Headshot (Silicon)',
  description: description,
  component: FeatureShortTextInput,
};
