using RosettaUI;
using UnityEngine;

namespace W0NYV.vj250904
{
    public class PostEffector : MonoBehaviour, IElementCreator
    {
        [SerializeField] private RenderTexture _source;
        [SerializeField] private RenderTexture _out;
        [SerializeField] private Material _xInvertmaterial;
        [SerializeField] private Material _sobelMaterial;

        private RenderTexture _tmp;

        private RenderTexture _sobelTmp;

        private bool _isXInvertActive;
        private float _sobelApplyValue;

        public Element CreateElement(LabelElement _)
        {
            return UI.Page(
                UI.Field("X Invert", () => _isXInvertActive).RegisterValueChangeCallback(() =>
                {
                    if (_isXInvertActive)
                    {
                        _xInvertmaterial.EnableKeyword("_Active");
                    }
                    else
                    {
                        _xInvertmaterial.DisableKeyword("_Active");
                    }
                }),
                UI.Field("Sobel", () => _sobelApplyValue).RegisterValueChangeCallback(() =>
                {
                    _sobelMaterial.SetFloat("_ApplyValue", _sobelApplyValue);
                })

            );
        }

        public void SwitchXInvert(float v)
        {
            if (v == 0f) return;
            _isXInvertActive = !_isXInvertActive;

            if (_isXInvertActive)
            {
                _xInvertmaterial.EnableKeyword("_Active");
            }
            else
            {
                _xInvertmaterial.DisableKeyword("_Active");
            }
        }

        public void SetSobelApplyValue(float v)
        {
            _sobelApplyValue = v;
            _sobelMaterial.SetFloat("_ApplyValue", _sobelApplyValue);
        }
        
        private void Start()
        {
            _tmp = new RenderTexture(_source.width, _source.height, 0, RenderTextureFormat.ARGB32);
            _sobelTmp = new RenderTexture(_source.width / 4, _source.height / 4, 0, RenderTextureFormat.ARGB32);
        }

        private void Update()
        {
            Graphics.Blit(_source, _tmp, _xInvertmaterial);
            
            Graphics.Blit(_tmp, _sobelTmp, _sobelMaterial, 0);
            _sobelMaterial.SetTexture("_SobelTex", _sobelTmp);
            Graphics.Blit(_tmp, _out, _sobelMaterial, 1);
        }

        private void OnDestroy()
        {
            _tmp.Release();
            _tmp.Release();
            _sobelTmp.Release();
        }
    }
}