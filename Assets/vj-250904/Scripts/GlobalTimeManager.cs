using UnityEngine;

namespace W0NYV.vj250904
{
    public class GlobalTimeManager : MonoBehaviour
    {
        public float GlobalTime { get; private set; }
        public float BPM => _bpm;

        private float _bpm = 60f;

        public void Reset(float v)
        {
            if (v == 0f) return;
            GlobalTime = 0f;
        }

        public void SetBpm(float bpm)
        {
            _bpm = bpm;
        }

        private void Update()
        {
            GlobalTime += Time.deltaTime * _bpm / 60f;
        }
    }
}