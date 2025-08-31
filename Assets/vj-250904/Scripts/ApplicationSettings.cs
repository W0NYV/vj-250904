using PrefsGUI;
using PrefsGUI.RosettaUI;
using RosettaUI;
using UnityEngine;

namespace W0NYV.vj250904
{
    public class ApplicationSettings : MonoBehaviour, IElementCreator
    {
        [SerializeField] private PrefsInt _targetFrameRate;
        [SerializeField] private PrefsInt _vSyncCount;
        
        public Element CreateElement(LabelElement _)
        {
            return UI.Page(
                _targetFrameRate.CreateElement("Target FrameRate").RegisterValueChangeCallback(() => Application.targetFrameRate = _targetFrameRate),
                _vSyncCount.CreateElement("VSync Count").RegisterValueChangeCallback(() => QualitySettings.vSyncCount = _vSyncCount)
            );
        }
    }
}