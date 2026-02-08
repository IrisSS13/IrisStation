import { Box, Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';
import type { NTOSData } from '../layouts/NtosWindow';

interface PhoneMonitorData extends NTOSData {
  linked_phone_id: string | null;
  is_linked: boolean;
  phone_category?: string;
  phone_icon?: string;
  phone_call_state?: number;
  phone_do_not_disturb?: number;
  nearby_phones: PhoneInfo[];
}

interface PhoneInfo {
  phone_id: string;
  phone_category: string;
  phone_icon: string;
  ref: string;
}

export const PhoneMonitor = () => {
  return (
    <NtosWindow width={400} height={500}>
      <NtosWindow.Content scrollable>
        <PhoneMonitorPanel />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const PhoneMonitorPanel = () => {
  const { act, data } = useBackend<PhoneMonitorData>();

  return (
    <Stack vertical fill>
      <Section title="Phone Monitor">
        {data.is_linked ? <LinkedPhoneSection /> : <AvailablePhonesSection />}
      </Section>
    </Stack>
  );
};

const LinkedPhoneSection = () => {
  const { act, data } = useBackend<PhoneMonitorData>();

  const getPhoneStatus = () => {
    if (!data.phone_call_state) return 'Idle';
    switch (data.phone_call_state) {
      case 1:
        return 'Dialing...';
      case 2:
        return 'Ringing';
      case 3:
        return 'Connected';
      default:
        return 'Unknown';
    }
  };

  const getDndStatus = () => {
    if (data.phone_do_not_disturb === 1 || data.phone_do_not_disturb === 2) {
      return 'Do Not Disturb';
    }
    return 'Available';
  };

  return (
    <Stack vertical fill>
      <Box>
        <strong>Linked to: {data.linked_phone_id}</strong>
        <br />
        Category: {data.phone_category || 'Unknown'}
        <br />
        Status: {getPhoneStatus()}
        <br />
        Availability: {getDndStatus()}
      </Box>

      <Button fluid color="red" onClick={() => act('unlink_phone')}>
        Unlink Phone
      </Button>

      <Button fluid color="orange" onClick={() => act('clear_alert')}>
        Clear Alert
      </Button>

      <Box mt={1}>
        <strong>Link to Different Phone:</strong>
      </Box>

      {data.nearby_phones && data.nearby_phones.length > 0 ? (
        <Stack vertical>
          {data.nearby_phones.map((phone) => (
            <Button
              key={phone.ref}
              fluid
              onClick={() =>
                act('link_phone', {
                  phone_ref: phone.ref,
                })
              }
            >
              {phone.phone_id} ({phone.phone_category})
            </Button>
          ))}
        </Stack>
      ) : (
        <Box color="bad">No nearby phones detected within 3 meters.</Box>
      )}
    </Stack>
  );
};

const AvailablePhonesSection = () => {
  const { act, data } = useBackend<PhoneMonitorData>();

  return (
    <Stack vertical fill>
      <Box>
        <strong>No phone linked</strong>
        <br />
        Select a nearby phone to link this monitor.
      </Box>

      {data.nearby_phones && data.nearby_phones.length > 0 ? (
        <Stack vertical>
          {data.nearby_phones.map((phone) => (
            <Button
              key={phone.ref}
              fluid
              onClick={() =>
                act('link_phone', {
                  phone_ref: phone.ref,
                })
              }
            >
              {phone.phone_id} ({phone.phone_category})
            </Button>
          ))}
        </Stack>
      ) : (
        <Box color="bad">No nearby phones detected within 3 meters.</Box>
      )}
    </Stack>
  );
};
