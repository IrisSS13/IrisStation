// IRIS FILE, can't make it modular

import { Antagonist, Category } from '../base';

const Agent: Antagonist = {
  key: 'agent',
  name: 'Agent',
  description: [
    `
      Spy that can activate at any point in the middle
      of the shift.
    `,

    `
      Complete Spy Bounties to earn rewards from your employer.
      Use these rewards to sow chaos and mischief!
    `,
  ],
  category: Category.Midround,
};

export default Agent;
