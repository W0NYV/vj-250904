using PrefsGUI;
using RosettaUI;
using UnityEngine;
using UnityEngine.InputSystem;

namespace W0NYV.vj250904
{
    [RequireComponent(typeof(RosettaUIRoot))]
    public class UIBuilder : MonoBehaviour
    {
        [SerializeField] private ApplicationSettings _applicationSettings;
        [SerializeField] private TimeSystemUI _timeSystemUI;
        [SerializeField] private PanelGfxManager _panelGfxManager;
        [SerializeField] private CameraController _cameraController;
        
        private RosettaUIRoot _rosettaUIRoot;

        private Element CreateElement()
        {
            return UI.Window("VJ 250904 v0.0.0",
                UI.Column(
                    UI.WindowLauncher(
                        "Application Settings",
                        UI.Window(
                            _applicationSettings.CreateElement(""),
                            UI.Button("Save", Prefs.Save)
                        )
                    ),
                    _timeSystemUI.CreateElement(""),
                    _panelGfxManager.CreateElement(""),
                    _cameraController.CreateElement("")
                )
            ).SetClosable(false);
        }

        private void Start()
        {
            TryGetComponent(out _rosettaUIRoot);
            
            _rosettaUIRoot.Build(CreateElement());
        }

        private void Update()
        {
            if (Keyboard.current[Key.D].wasPressedThisFrame)
            {
                _rosettaUIRoot.enabled = !_rosettaUIRoot.enabled;
            }
        }
    }   
}
