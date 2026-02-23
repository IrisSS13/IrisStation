import { useMemo, useState } from 'react';

import { Button, Input, Section, Stack, Tabs } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

interface PhoneData {
  availability: number;
  last_caller: string | null;
  available_transmitters: Record<string, boolean>;
  transmitters: PhoneInfo[];
  calling_phone_id: string | null;
  being_called: boolean;
  active_call: boolean;
  // New fields for enhanced functionality
  current_phone_id: string;
  current_phone_category: string;
  call_log: string[];
  phone_statuses: Record<string, string>; // "available", "busy", "ringing", "offline"
  call_state: number;
}

interface PhoneInfo {
  phone_id: string;
  phone_category: string;
  phone_icon: string;
}

export const PhoneMenu = () => {
  return (
    <Window width={500} height={600}>
      <Window.Content scrollable>
        <PhonePanel />
      </Window.Content>
    </Window>
  );
};

const PhonePanel = () => {
  const { act, data } = useBackend<PhoneData>();
  const [currentSearch, setSearch] = useState('');
  const [currentCategory, setCategory] = useState<string | null>(null);

  const availablePhones = useMemo(() => {
    if (!data.available_transmitters || !data.transmitters) {
      return [];
    }
    const available = Object.keys(data.available_transmitters);
    return data.transmitters.filter((phone) =>
      available.includes(phone.phone_id),
    );
  }, [data.transmitters, data.available_transmitters]);

  const categories = useMemo(() => {
    if (!availablePhones.length) {
      return ['Station']; // Default category to prevent empty tabs
    }
    const cats = new Set(availablePhones.map((p) => p.phone_category));
    return Array.from(cats);
  }, [availablePhones]);

  const selectedCategory = currentCategory || categories[0];

  const filteredPhones = useMemo(() => {
    const searchLower = currentSearch.toLowerCase();
    return availablePhones.filter(
      (phone) =>
        phone.phone_category === selectedCategory &&
        phone.phone_id.toLowerCase().includes(searchLower),
    );
  }, [availablePhones, selectedCategory, currentSearch]);

  const getPhoneStatus = (phoneId: string) => {
    const status = data.phone_statuses?.[phoneId] || 'available';
    switch (status) {
      case 'busy':
        return { color: 'red', icon: 'phone', tooltip: 'Busy' };
      case 'ringing':
        return { color: 'yellow', icon: 'phone', tooltip: 'Ringing' };
      case 'dnd':
        return {
          color: 'orange',
          icon: 'volume-xmark',
          tooltip: 'Do Not Disturb',
        };
      case 'offline':
        return { color: 'grey', icon: 'phone-slash', tooltip: 'Offline' };
      default:
        return { color: 'green', icon: 'phone', tooltip: 'Available' };
    }
  };

  const getCallStateText = () => {
    switch (data.call_state) {
      case 1:
        return 'Dialing...';
      case 2:
        return 'Ringing';
      case 3:
        return 'Connected';
      default:
        return 'Idle';
    }
  };

  const getDNDInfo = () => {
    if (data.availability === 1) {
      return {
        tooltip: 'Do Not Disturb is ENABLED',
        icon: 'volume-xmark',
        disabled: false,
      };
    }
    if (data.availability >= 2) {
      return {
        tooltip: 'Do Not Disturb is ENABLED (LOCKED)',
        icon: 'volume-xmark',
        disabled: true,
      };
    }
    if (data.availability < 0) {
      return {
        tooltip: 'Do Not Disturb is DISABLED and LOCKED',
        icon: 'volume-high',
        disabled: true,
      };
    }
    return {
      tooltip: 'Do Not Disturb is DISABLED',
      icon: 'volume-high',
      disabled: false,
    };
  };

  const dndInfo = getDNDInfo();

  const handlePhoneClick = (phoneId: string) => {
    // Single-click to call
    act('call_phone', { phone_id: phoneId });
  };

  return (
    <Stack vertical fill>
      {/* Current Phone Status */}
      <Stack.Item>
        <Section
          title="Current Phone"
          fill
          style={{
            backgroundColor: data.call_state ? '#2a4d3a' : undefined,
            border: data.call_state ? '1px solid #4CAF50' : undefined,
          }}
        >
          <Stack>
            <Stack.Item grow>
              <strong>{data.current_phone_id || 'Unknown Phone'}</strong>
              <br />
              <span style={{ opacity: 0.7 }}>
                {data.current_phone_category} • {getCallStateText()}
              </span>
            </Stack.Item>
            {Boolean(data.call_state) && (
              <Stack.Item>
                <Button
                  color="red"
                  icon="phone-slash"
                  onClick={() => act('hang_up')}
                >
                  Hang Up
                </Button>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Stack.Item>

      {/* Categories and Search */}
      {Boolean(categories.length) && (
        <Stack.Item>
          <Tabs>
            {categories.map((cat) => (
              <Tabs.Tab
                key={cat}
                selected={selectedCategory === cat}
                onClick={() => setCategory(cat)}
              >
                {cat}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
      )}

      <Stack.Item>
        <Input
          fluid
          value={currentSearch}
          placeholder="Search phones..."
          onChange={(value) => setSearch(value)}
        />
      </Stack.Item>

      {/* Phone List */}
      <Stack.Item grow>
        <Section fill scrollable title="Available Phones">
          {filteredPhones.length > 0 ? (
            <Stack vertical fill>
              {filteredPhones.map((phone) => {
                const status = getPhoneStatus(phone.phone_id);
                const isDisabled =
                  Boolean(data.call_state) ||
                  status.color === 'grey' ||
                  status.color === 'red' ||
                  status.color === 'yellow';

                return (
                  <Stack.Item key={phone.phone_id}>
                    <Button
                      fluid
                      onClick={() => handlePhoneClick(phone.phone_id)}
                      icon={phone.phone_icon || status.icon}
                      disabled={isDisabled}
                      color={isDisabled ? 'grey' : 'default'}
                      tooltip={status.tooltip}
                    >
                      {phone.phone_id}
                      <span
                        style={{
                          color:
                            status.color === 'green'
                              ? '#4CAF50'
                              : status.color === 'yellow'
                                ? '#FFC107'
                                : status.color === 'red'
                                  ? '#F44336'
                                  : status.color === 'orange'
                                    ? '#FF9800'
                                    : '#757575',
                          fontSize: '11px',
                          marginLeft: '8px',
                        }}
                      >
                        ● {status.tooltip}
                      </span>
                    </Button>
                  </Stack.Item>
                );
              })}
            </Stack>
          ) : (
            <Section>No phones found</Section>
          )}
        </Section>
      </Stack.Item>

      {/* Call Log */}
      {data.call_log && Boolean(data.call_log.length) && (
        <Stack.Item>
          <Section title="Call Log">
            <Stack vertical>
              {data.call_log.slice(0, 5).map((logEntry, index) => (
                <Stack.Item key={index}>
                  <div
                    style={{
                      fontSize: '11px',
                      color: '#aaa',
                      padding: '2px 4px',
                      backgroundColor: '#1a1a1a',
                      borderRadius: '3px',
                      marginBottom: '1px',
                    }}
                  >
                    {logEntry}
                  </div>
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        </Stack.Item>
      )}

      {/* DND Control */}
      <Stack.Item>
        <Button
          color={
            data.availability === 0 || data.availability < 0 ? 'good' : 'bad'
          }
          fluid
          icon={dndInfo.icon}
          tooltip={dndInfo.tooltip}
          disabled={dndInfo.disabled}
          onClick={() => act('toggle_dnd')}
        >
          {data.availability === 0 || data.availability < 0
            ? 'Do Not Disturb: OFF'
            : 'Do Not Disturb: ON'}
        </Button>
      </Stack.Item>
    </Stack>
  );
};
