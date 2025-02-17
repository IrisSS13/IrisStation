// IRIS STATION FILE - MISCREANTS_ANTAG

import { Antagonist, Category } from '../base';

export const MISCREANT_MECHANICAL_DESCRIPTION = `
      A non-conversion team antag with RP-centric objectives. Expect highly variable amounts of conflict, from minimal to extreme, as it will depend on your team's objectives and your approach.
   `;

const Miscreant: Antagonist = {
  key: 'miscreant',
  name: 'Miscreant',
  description: [
    `
      Become a miscreant and work with your fellow miscreants to accomplish your goal!
    `,
    MISCREANT_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Miscreant;
