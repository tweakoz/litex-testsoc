#pragma once

///////////////////////////////////////////////////////////////////////////////

template <size_t kcapacity, typename T>
struct static_queue {

  /////////////////////////////////////

  void initialize(){
      _dqidx = 0;
      _eqidx = -1;
      _count = 0;
  }

  /////////////////////////////////////

  bool try_dequeue(T& out) {
    if (0 == _count) {
      printf("uhoh, underflow\n");
      return false;
    } else {
      _count--;
      out = _storage[_dqidx];
      _dqidx = (_dqidx + 1) % kcapacity;
      return true;
    }
  }

  /////////////////////////////////////

  void enqueue(T item) {

    if (_count >= kcapacity) printf("uhoh, overflow _count<%zu>\n", _count);

    _count++;

    _eqidx = (_eqidx + 1) % kcapacity;
    _storage[_eqidx] = item;
  }

  /////////////////////////////////////

  T _storage[kcapacity];

  size_t _dqidx;
  size_t _eqidx;
  size_t _count;

};
