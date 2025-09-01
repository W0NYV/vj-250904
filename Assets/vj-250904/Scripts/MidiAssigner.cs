using UnityEngine;
using UnityEngine.Events;

namespace W0NYV.vj250904
{
    [System.Serializable]
    public class MidiAssignInfo
    {
        public int ID;
        public UnityEvent<float> OnReceived = new();
    }
    
    public class MidiAssigner : MonoBehaviour
    {
        [SerializeField] private MidiAssignInfo[] _noteAssigns;
        [SerializeField] private MidiAssignInfo[] _controlChangeAssigns;
        
        private void Awake()
        {
            DeviceMidiReceiver.OnMidiNoteReceived.AddListener(x =>
            {
                foreach (var assignInfo in _noteAssigns)
                {
                    if (assignInfo.ID == x.id)
                    {
                        assignInfo.OnReceived.Invoke(x.value);
                    }
                }
            });
            
            DeviceMidiReceiver.OnMidiControlChangeReceived.AddListener(x =>
            {
                foreach (var assignInfo in _controlChangeAssigns)
                {
                    if (assignInfo.ID == x.id)
                    {
                        assignInfo.OnReceived.Invoke(x.value);
                    }
                }
            });
        }
    }
}