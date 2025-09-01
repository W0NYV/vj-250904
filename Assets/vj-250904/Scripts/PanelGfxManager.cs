using System.Collections.Generic;
using RosettaUI;
using UnityEngine;

namespace W0NYV.vj250904
{
    public class PanelGfxManager : MonoBehaviour, IElementCreator
    {
        public enum Keyword
        {
            G001,
            G002
        }
        
        [SerializeField] private Material _panelMaterial;

        private int _currentId = 0;
        private Keyword _currentKeyword = Keyword.G001;
        
        private static readonly Dictionary<int, string> _dictionary = new()
        {
            { 0, "_G001" },
            { 1, "_G002" },
        };

        public Element CreateElement(LabelElement label)
        {
            return UI.Field("Current Panel GFX", () => _currentKeyword).RegisterValueChangeCallback(() =>
            {
                var id = (int)_currentKeyword;
                SwitchKeyword(id);
            });
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