using System;
using RosettaUI;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

namespace W0NYV.vj250904
{
    public class GlobalVolumeController : MonoBehaviour, IElementCreator
    {
        [SerializeField] private Volume _volume;

        private DepthOfField _dof;
        private float _farFocusEnd = 14f;

        public Element CreateElement(LabelElement _)
        {
            return UI.Page(
                UI.Field("DoF Far Focus End", () => _farFocusEnd).RegisterValueChangeCallback(() =>
                {
                    _dof.farFocusEnd.value = _farFocusEnd;
                })
            );
        }

        public void SetDoFFarRangeEnd(float v)
        {
            _farFocusEnd = 14f + v * 25f;
            _dof.farFocusEnd.value = _farFocusEnd;
        }
        
        private void Start()
        {
            _volume.profile.TryGet<DepthOfField>(out _dof);
        }
    }
}