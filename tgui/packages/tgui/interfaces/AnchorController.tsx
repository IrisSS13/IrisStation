import {
  Box,
  Button,
  Divider,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';

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
    <Window width={300} height={360}>
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
                <LabeledList.Item label="X Coordinate">
                  <NumberInput
                    value={data.x_coord}
                    step={1}
                    minValue={1}
                    maxValue={255}
                    onChange={(value) =>
                      act('adjust-x', {
                        new_x: value,
                      })
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Y Coordinate">
                  <NumberInput
                    value={data.y_coord}
                    step={1}
                    minValue={1}
                    maxValue={255}
                    onChange={(value) =>
                      act('adjust-y', {
                        new_y: value,
                      })
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Z Coordinate">
                  <NumberInput
                    value={data.z_coord}
                    step={1}
                    minValue={5}
                    maxValue={11}
                    onChange={(value) =>
                      act('adjust-z', {
                        new_z: value,
                      })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
              <Divider />
              <Button
                textAlign="center"
                width="100%"
                onClick={() => act('launch-to-coords')}
              >
                Launch to Coordinates
              </Button>
              <Button
                textAlign="center"
                width="100%"
                onClick={() => act('send-home')}
              >
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
