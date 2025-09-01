using RosettaUI;
using UnityEngine;

namespace W0NYV.vj250904
{
    public class TimeSystemUI : MonoBehaviour, IElementCreator
    {
        [SerializeField] private GlobalTimeManager _globalTimeManager;
        [SerializeField] private TapTempoSystem _tapTempoSystem;

        public Element CreateElement(LabelElement _)
        {
            return UI.Page(
                UI.FieldReadOnly("Time", () => _globalTimeManager.GlobalTime),
                UI.FieldReadOnly("BPM", () => _globalTimeManager.BPM),
                UI.Button("Tap Tempo", () => _tapTempoSystem.CalculateTempo(1f)),
                UI.Button("Reset Time", () => _globalTimeManager.Reset(1f))
            );
        }
    }
}