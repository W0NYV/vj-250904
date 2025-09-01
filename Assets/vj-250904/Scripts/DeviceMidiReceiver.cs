using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;

namespace W0NYV.vj250904
{
    public class DeviceMidiReceiver : MonoBehaviour
    {
        public static UnityEvent<(int id, float value)> OnMidiControlChangeReceived { get; } = new();
        public static UnityEvent<(int id, float value)> OnMidiNoteReceived { get; } = new();

        [SerializeField] private bool _isDebug;
        
        private void OnEnable()
        {
            InputSystem.onDeviceChange += (device, change) =>
            {
                if (change != InputDeviceChange.Added) return;

                var midiDevice = device as Minis.MidiDevice;
                if (midiDevice == null) return;

                midiDevice.onWillControlChange += (control, velocity) =>
                {
                    OnMidiControlChangeReceived.Invoke((control.controlNumber, velocity));
                    
                    if (!_isDebug) return;

                    Debug.Log("CC :" + control.controlNumber + " :" + velocity);
                };
                
                midiDevice.onWillNoteOn += (note, velocity) => {
                    
                    OnMidiNoteReceived.Invoke((note.noteNumber, 1f));
                    
                    if (!_isDebug) return;
                    
                    // Note that you can't use note.velocity because the state
                    // hasn't been updated yet (as this is "will" event). The note
                    // object is only useful to specify the target note (note
                    // number, channel number, device name, etc.) Use the velocity
                    // argument as an input note velocity.
                    Debug.Log(string.Format(
                        "Note On #{0} ({1}) vel:{2:0.00} ch:{3} dev:'{4}'",
                        note.noteNumber,
                        note.shortDisplayName,
                        velocity,
                        (note.device as Minis.MidiDevice)?.channel,
                        note.device.description.product
                    ));
                };

                midiDevice.onWillNoteOff += (note) => {

                    OnMidiNoteReceived.Invoke((note.noteNumber, 0f));
                    
                    if (!_isDebug) return;
                    
                    Debug.Log(string.Format(
                        "Note Off #{0} ({1}) ch:{2} dev:'{3}'",
                        note.noteNumber,
                        note.shortDisplayName,
                        (note.device as Minis.MidiDevice)?.channel,
                        note.device.description.product
                    ));
                };
            };
        }
    }
}