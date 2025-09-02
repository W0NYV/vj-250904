using System;
using RosettaUI;
using Unity.Cinemachine;
using UnityEngine;

namespace W0NYV.vj250904
{
    public class CameraController : MonoBehaviour, IElementCreator
    {
        public enum CameraId
        {
            C001, C002, C003, C004,
            C005
        }
        
        [SerializeField] private CinemachineCamera[] _cameras;

        private CameraId _cameraId;
        private CameraId _currentCameraId;

        public Element CreateElement(LabelElement _)
        {
            return UI.Field("Current Camera", () => _cameraId)
                .RegisterValueChangeCallback(() => SwitchCamera(_cameraId));
        }

        public void SwitchToC001(float v)
        {
            if (v == 0f) return;
            _cameraId = CameraId.C001;
            SwitchCamera(_cameraId);
        }

        public void SwitchToC002(float v)
        {
            if (v == 0f) return;
            _cameraId = CameraId.C002;
            SwitchCamera(_cameraId);
        }
        
        public void SwitchToC003(float v)
        {
            if (v == 0f) return;
            _cameraId = CameraId.C003;
            SwitchCamera(_cameraId);
        }
        
        public void SwitchToC004(float v)
        {
            if (v == 0f) return;
            _cameraId = CameraId.C004;
            SwitchCamera(_cameraId);
        }
        
        public void SwitchToC005(float v)
        {
            if (v == 0f) return;
            _cameraId = CameraId.C005;
            SwitchCamera(_cameraId);
        }
        
        private void SwitchCamera(CameraId newCameraId)
        {
            var current = _cameras[(int)_currentCameraId];
            current.Priority = 0;
            
            var newCamera = _cameras[(int)newCameraId];
            newCamera.Priority = 1;
            
            _currentCameraId = newCameraId;
        }

        private void Start()
        {
            SwitchCamera(CameraId.C001);
        }
    }
}