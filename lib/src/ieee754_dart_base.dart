import 'dart:typed_data';
import 'dart:math' as math;

class Ieee754 {
  static read(Uint8List buffer, int offset, bool isLE, int mLen, int nBytes) {
    int e;
    int m;
    var eLen = (nBytes * 8) - mLen - 1;
    var eMax = (1 << eLen) - 1;
    var eBias = eMax >> 1;
    var nBits = -7;
    var i = isLE ? (nBytes - 1) : 0;
    var d = isLE ? -1 : 1;
    var s = buffer[offset + i];

    i += d;

    e = s & ((1 << (-nBits)) - 1);
    s >>= (-nBits);
    nBits += eLen;
    for (; nBits > 0; e = (e * 256) + buffer[offset + i], i += d, nBits -= 8) {}

    m = e & ((1 << (-nBits)) - 1);
    e >>= (-nBits);
    nBits += mLen;
    for (; nBits > 0; m = (m * 256) + buffer[offset + i], i += d, nBits -= 8) {}

    if (e == 0) {
      e = 1 - eBias;
    } else if (e == eMax) {
      return m == 0 ? double.nan : ((s == 0 ? -1 : 1) * double.infinity);
    } else {
      m = m + math.pow(2, mLen) as int;
      e = e - eBias;
    }
    return (s == 0 ? -1 : 1) * m * math.pow(2, e - mLen);
  }

  static write(Uint8List buffer, double value, int offset, bool isLE, int mLen,
      int nBytes) {
    int e;
    int m;
    int c;
    var eLen = (nBytes * 8) - mLen - 1;
    var eMax = (1 << eLen) - 1;
    var eBias = eMax >> 1;
    var rt = (mLen == 23 ? math.pow(2, -24) - math.pow(2, -77) : 0);
    var i = isLE ? 0 : (nBytes - 1);
    var d = isLE ? 1 : -1;
    var s = value < 0 || (value == 0 && 1 / value < 0) ? 1 : 0;

    value = (value).abs();

    if (value == double.nan || value == double.infinity) {
      m = value == double.nan ? 1 : 0;
      e = eMax;
    } else {
      e = (math.log(value) / math.ln2).floor();
      if (value * (c = math.pow(2, -e) as int) < 1) {
        e--;
        c *= 2;
      }
      if (e + eBias >= 1) {
        value += rt ~/ c;
      } else {
        value += rt * math.pow(2, 1 - eBias) as int;
      }
      if (value * c >= 2) {
        e++;
        c ~/= 2;
      }

      if (e + eBias >= eMax) {
        m = 0;
        e = eMax;
      } else if (e + eBias >= 1) {
        m = ((value * c) - 1) * math.pow(2, mLen) as int;
        e = e + eBias;
      } else {
        m = value * math.pow(2, eBias - 1) * math.pow(2, mLen) as int;
        e = 0;
      }
    }

    for (;
        mLen >= 8;
        buffer[offset + i] = m & 0xff, i += d, m ~/= 256, mLen -= 8) {}

    e = (e << mLen) | m;
    eLen += mLen;
    for (;
        eLen > 0;
        buffer[offset + i] = e & 0xff, i += d, e ~/= 256, eLen -= 8) {}

    buffer[offset + i - d] |= s * 128;
  }
}
