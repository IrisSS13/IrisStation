import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';

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
    <Window width={600} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section textAlign="center" title="Readout">
              <LabeledList>
                <LabeledList.Item label="Anchor Name">
                  {data.anchor}
                </LabeledList.Item>
                <LabeledList.Item label="Fuel Level">
                  {data.fuel} jumps remaining
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section textAlign="center" title="Controls">
              <LabeledList>
                <LabeledList.Item label="X Coordinate" />
                <LabeledList.Item label="Y Coordinate" />
                <LabeledList.Item label="Z Coordinate" />
              </LabeledList>
              <Button
                textAlign="center"
                onClick={() => act('launch-to-coords')}
              >
                Launch to Coordinates
              </Button>
              <Button textAlign="center" onClick={() => act('send-home')}>
                Send Home
              </Button>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section textAlign="center" title="Response">
              <Box>{data.message}</Box>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
