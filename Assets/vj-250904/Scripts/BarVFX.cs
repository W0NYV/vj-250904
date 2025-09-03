using RosettaUI;
using UnityEngine;
using UnityEngine.VFX;

namespace W0NYV.vj250904
{
    public class BarVFX : MonoBehaviour, IElementCreator
    {
        [SerializeField] private VisualEffect _visualEffect;
        
        private bool _isActive;

        public Element CreateElement(LabelElement _)
        {
            return UI.Page(
                UI.Field("Bar Active", () => _isActive).RegisterValueChangeCallback(() =>
                {
                    _visualEffect.SetFloat("Rate", _isActive ? 10 : 0);
                })
            );
        }

        public void SwitchActive(float v)
        {
            if (v == 0f) return;

            _visualEffect.SetFloat("Rate", _isActive ? 10 : 0);
        }
    }
}