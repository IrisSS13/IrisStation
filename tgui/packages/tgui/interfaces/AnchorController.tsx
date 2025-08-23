import { Box, LabeledList, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  anchor: string;
  fuel: number;
  x_coord: number;
  y_coord: number;
  z_coord: number;
  message: string;
};

export const AnchorController = (props) => {
  const { act, data } = useBackend<Data>();
  return (
    <Window width={300} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section textAlign="center" title="Readout">
              <Stack fill>
                <Stack.Item>
                  <Box>
                    Anchor Name:
                    {data.anchor ? data.anchor : '-none connected-'}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Box>
                    Fuel Level:
                    {data.fuel ? data.fuel : '-unknown-'}
                    jumps remaining
                  </Box>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section textAlign="center" title="Controls">
              <LabeledList>
                <LabeledList.Item label="X Coordinate:" />
                <LabeledList.Item label="Y Coordinate:" />
                <LabeledList.Item label="Z Coordinate:" />
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
