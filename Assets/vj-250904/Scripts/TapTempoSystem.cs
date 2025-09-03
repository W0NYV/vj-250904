using UnityEngine;
using UnityEngine.Events;

namespace W0NYV.vj250904
{
    public class TapTempoSystem : MonoBehaviour
    {
        [SerializeField] private UnityEvent<float> _onBpmChanged;
        [SerializeField] private int _bpmAccuracy = 15;

        private float _timeCount = 0f;
        private float _timeDuration = 0f;
        private bool _isActiveTapTempo = false;
        private float[] _bpmArray;
        private float _totalBpm = 0f;
        private int _bpmCount = 0;
        private bool _firstTap = true;

        public void CalculateTempo(float v)
        {
            if (v == 0f) return;
            CalculateTempo();
        }
        
        private void CalculateTempo()
        {
            if (_firstTap)
            {
                _isActiveTapTempo = true;

                _timeDuration = _timeCount;

                _bpmArray = new float[_bpmAccuracy];

                _firstTap = false;
            }
            else
            {
                _timeDuration = _timeCount - _timeDuration;
                _bpmArray[_bpmCount] = 1 / _timeDuration * 60f;

                foreach (var b in _bpmArray)
                {
                    _totalBpm += b;
                }

                var bpm = _bpmArray[^1] != 0 ? Mathf.RoundToInt(_totalBpm / _bpmArray.Length) : Mathf.RoundToInt(_totalBpm / (_bpmCount + 1));
                _onBpmChanged.Invoke(bpm);

                _timeDuration = _timeCount;

                if (_bpmCount < _bpmArray.Length)
                {
                    _bpmCount++;
                }

                if (_bpmCount == _bpmArray.Length)
                {
                    _bpmCount = 0;
                }

                _totalBpm = 0f;
            }
        }
        
        private void ClearTempo()
        {
            _bpmArray = new float[_bpmAccuracy];
            _isActiveTapTempo = false;
            _firstTap = true;
            _bpmCount = 0;
            _totalBpm = 0f;
            _timeDuration = 0f;
            _timeCount = 0f;
        }

        private void Update() 
        {
            if (_timeCount - _timeDuration > 2f)
            {
                ClearTempo();
            }

            if (_isActiveTapTempo)
            {
                _timeCount += Time.deltaTime;
            }
        }
    }
}