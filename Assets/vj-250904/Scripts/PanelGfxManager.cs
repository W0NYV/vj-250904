using System.Collections.Generic;
using RosettaUI;
using UnityEngine;

namespace W0NYV.vj250904
{
    public class PanelGfxManager : MonoBehaviour, IElementCreator
    {
        public enum Keyword
        {
            G001, G002, G003, G004,
            G005, 
        }
        
        [SerializeField] private Material _panelMaterial;

        private int _currentId = 0;
        private Keyword _currentKeyword = Keyword.G001;
        private Vector3 _hsvColor;
        private float _gradApplyValue;
        
        private static readonly Dictionary<int, string> _dictionary = new()
        {
            { 0, "_G001" }, { 1, "_G002" }, { 2, "_G003" }, { 3, "_G004" },
            { 4, "_G005" },
        };

        private static readonly int HSVColorID = Shader.PropertyToID("_HSVColor");
        private static readonly int GradApplyValueID = Shader.PropertyToID("_GradApplyValue");

        public Element CreateElement(LabelElement label)
        {
            return UI.Page(
                UI.Field("Current Panel GFX", () => _currentKeyword).RegisterValueChangeCallback(() =>
                {
                    var id = (int)_currentKeyword;
                    SwitchKeyword(id);
                }),
                UI.Field("HSV Color", () => _hsvColor).RegisterValueChangeCallback(() => _panelMaterial.SetVector(HSVColorID, _hsvColor)),
                UI.Field("Grad Apply Value", () => _gradApplyValue).RegisterValueChangeCallback(() => _panelMaterial.SetFloat(GradApplyValueID, _gradApplyValue))
            );
        }

        public void SetHue(float v)
        {
            var current = _hsvColor;
            _hsvColor = new Vector3(v, _hsvColor.y, _hsvColor.z);
            _panelMaterial.SetVector("_HSVColor", _hsvColor);
        }
        
        public void SetSaturation(float v)
        {
            var current = _hsvColor;
            _hsvColor = new Vector3(_hsvColor.x, v, _hsvColor.z);
            _panelMaterial.SetVector("_HSVColor", _hsvColor);
        }
        
        public void SetValue(float v)
        {
            var current = _hsvColor;
            _hsvColor = new Vector3(_hsvColor.x, _hsvColor.y, v);
            _panelMaterial.SetVector("_HSVColor", _hsvColor);
        }

        public void SetGradApplyValue(float v)
        {
            _gradApplyValue = v;
            _panelMaterial.SetFloat(GradApplyValueID, _gradApplyValue);
        }
        
        public void SwitchToG001(float v)
        {
            if (v == 0f) return;
            SwitchKeyword((int)Keyword.G001);
            _currentKeyword = Keyword.G001;
        }
        
        public void SwitchToG002(float v)
        {
            if (v == 0f) return;
            SwitchKeyword((int)Keyword.G002);
            _currentKeyword = Keyword.G002;
        }
        
        public void SwitchToG003(float v)
        {
            if (v == 0f) return;
            SwitchKeyword((int)Keyword.G003);
            _currentKeyword = Keyword.G003;
        }
        
        public void SwitchToG004(float v)
        {
            if (v == 0f) return;
            SwitchKeyword((int)Keyword.G004);
            _currentKeyword = Keyword.G004;
        }

        public void SwitchToG005(float v)
        {
            if (v == 0f) return;
            SwitchKeyword((int)Keyword.G005);
            _currentKeyword = Keyword.G005;
        }
        
        private void SwitchKeyword(int id)
        {
            _panelMaterial.DisableKeyword(_dictionary[_currentId]);
            
            _panelMaterial.EnableKeyword(_dictionary[id]);

            _currentId = id;
        }
        
        private void Start()
        {
            _panelMaterial.EnableKeyword(_dictionary[_currentId]);
        }
    }
}