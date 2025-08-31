using PrefsGUI;
using RosettaUI;
using UnityEngine;
using UnityEngine.InputSystem;

namespace W0NYV.vj250904
{
    [RequireComponent(typeof(RosettaUIRoot))]
    public class UIBuilder : MonoBehaviour
    {
        private RosettaUIRoot _rosettaUIRoot;

        private Element CreateElement()
        {
            return UI.Window("VJ 250904 v0.0.0",
                UI.WindowLauncher<ApplicationSettings>(),
                UI.Button("Save", Prefs.Save)    
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
