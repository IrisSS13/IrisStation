import * as React from 'react';
import {
  Button,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  starlight_color: string;
  affected_lights_count: number;
  fog_count: number;
  rusted_areas_count: number;
  current_light_color: string;
  current_light_brightness: number;
};

export function BloodMoonControls(props) {
  const { act, data } = useBackend<Data>();
  const {
    starlight_color,
    affected_lights_count,
    fog_count,
    rusted_areas_count,
    current_light_color,
    current_light_brightness,
  } = data;

  const [fogDensity, setFogDensity] = React.useState(150);

  const spawnFog = (type: 'room' | 'hallway', amount: number) => {
    act(`spawn_${type}_fog`, { amount, fog_density: fogDensity });
  };

  return (
    <Window
      title="Blood Moon Event Controls"
      width={550}
      height={700}
      theme="admin"
    >
      <Window.Content scrollable>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Space Environment (Starlight)">
              <Stack vertical>
                <Stack.Item>
                  <LabeledList>
                    <LabeledList.Item label="Current Starlight">
                      <div
                        style={{
                          display: 'inline-block',
                          width: '20px',
                          height: '20px',
                          backgroundColor: starlight_color,
                          border: '1px solid white',
                          marginRight: '5px',
                        }}
                      />
                      {starlight_color}
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="palette"
                        onClick={() => act('change_starlight')}
                      >
                        Change Starlight Color
                      </Button>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="undo"
                        onClick={() => act('reset_starlight')}
                      >
                        Reset Starlight
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Station Light Controls">
              <Stack vertical>
                <Stack.Item>
                  <LabeledList>
                    <LabeledList.Item label="Current Light Color">
                      <div
                        style={{
                          display: 'inline-block',
                          width: '20px',
                          height: '20px',
                          backgroundColor: current_light_color,
                          border: '1px solid white',
                          marginRight: '5px',
                        }}
                      />
                      {current_light_color}
                    </LabeledList.Item>
                    <LabeledList.Item label="Current Brightness">
                      {Math.round(current_light_brightness * 100)}%
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    icon="palette"
                    onClick={() => act('change_light_color')}
                  >
                    Change Light Color
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <LabeledList>
                    <LabeledList.Item label="Brightness">
                      <Slider
                        value={current_light_brightness * 100}
                        minValue={0}
                        maxValue={100}
                        step={5}
                        stepPixelSize={3}
                        onChange={(e, value) =>
                          act('change_light_brightness', {
                            brightness: value / 100,
                          })
                        }
                      />
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="bolt"
                        color="yellow"
                        onClick={() => act('flicker_all_lights')}
                      >
                        Flicker All Lights
                      </Button>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="lightbulb"
                        color="yellow"
                        onClick={() => act('flicker_room_lights')}
                      >
                        Flicker Room
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    icon="adjust"
                    color="red"
                    onClick={() => act('dim_all_lights')}
                  >
                    Apply Light Settings to All Lights
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    icon="lightbulb"
                    disabled={affected_lights_count === 0}
                    onClick={() => act('restore_all_lights')}
                  >
                    Restore All Lights ({affected_lights_count} affected)
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Fog Effects">
              <Stack vertical>
                <Stack.Item>
                  <LabeledList>
                    <LabeledList.Item label="Fog Density">
                      <Slider
                        value={fogDensity}
                        minValue={0}
                        maxValue={150}
                        step={5}
                        stepPixelSize={3}
                        onChange={(e, value) => {
                          setFogDensity(value);
                          act('update_fog_density', { density: value });
                        }}
                      />
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="cloud"
                        color="red"
                        onClick={() => spawnFog('hallway', 250)}
                        tooltip="Spawn 250 fog clouds in hallways and maintenance"
                      >
                        Hallways & Maint: 250
                      </Button>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="cloud"
                        color="red"
                        onClick={() => spawnFog('hallway', 500)}
                        tooltip="Spawn 500 fog clouds in hallways and maintenance"
                      >
                        Hallways & Maint: 500
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="door-open"
                        color="orange"
                        onClick={() => spawnFog('room', 10)}
                        tooltip="Spawn 10 fog clouds in current room"
                      >
                        Room: 10
                      </Button>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="door-open"
                        color="orange"
                        onClick={() => spawnFog('room', 20)}
                        tooltip="Spawn 20 fog clouds in current room"
                      >
                        Room: 20
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="wind"
                        color="blue"
                        disabled={fog_count === 0}
                        onClick={() => act('clear_room_fog')}
                        tooltip="Remove fog from your current area only"
                      >
                        Clear Room Fog
                      </Button>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="wind"
                        color="red"
                        disabled={fog_count === 0}
                        onClick={() => act('clear_fog')}
                        tooltip="Remove all fog effects from the entire station"
                      >
                        Clear All Fog ({fog_count} active)
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Environmental Decay">
              <Stack vertical>
                <Stack.Item>
                  <Button
                    fluid
                    icon="biohazard"
                    color="orange"
                    onClick={() => act('rust_random_areas')}
                  >
                    Rust Current Area
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    icon="radiation"
                    color="orange"
                    onClick={() => act('rust_around_user')}
                    tooltip="Rust spreads outward from your current location"
                  >
                    Spread Rust from Here
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    icon="broom"
                    disabled={rusted_areas_count === 0}
                    onClick={() => act('clear_rust')}
                  >
                    Clear All Rust ({rusted_areas_count} items)
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Announcements">
              <Stack vertical>
                <Stack.Item>
                  <Button
                    fluid
                    icon="bullhorn"
                    color="good"
                    onClick={() => act('announce_act_1')}
                  >
                    Announce Act I
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    icon="bullhorn"
                    color="orange"
                    onClick={() => act('announce_act_2')}
                  >
                    Announce Act II
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    icon="bullhorn"
                    color="red"
                    onClick={() => act('announce_act_3')}
                  >
                    Announce Act III
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Tips">
              <ul style={{ margin: '5px', paddingLeft: '20px' }}>
                <li>Start with an announcement to set the mood</li>
                <li>
                  Change starlight to dark red (#8B0000 recommended) - this also
                  colors the parallax background
                </li>
                <li>
                  Adjust light color and brightness slider, then apply to all
                  lights
                </li>
                <li>Fog fades in gradually over 3 seconds</li>
                <li>Lights flicker dramatically when changing settings</li>
                <li>
                  Rust button targets YOUR current area - walk around to rust
                  different rooms
                </li>
                <li>Use restore buttons to undo effects when done!</li>
              </ul>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
