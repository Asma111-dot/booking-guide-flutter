extension DoubleFormatting on double{
  // [INPUT EXAMPLE] 2.0 or 2.56
  // [OUTPUT EXAMPLE] 2 or 2.56

  String toStringAsAutoFixing(){
    try {
      int firstPort = int.parse(toString().split('.').first);

      // e.g 2.0 / 2
      if (this / firstPort == 1) return toStringAsFixed(0);
      return toStringAsFixed(2) == '0.00' ? '0' : toStringAsFixed(2);
    }catch (e) {
      return toString();
    }
  }

 String?  notZero() {
    if(this <= 0)return null;
    return toStringAsAutoFixing();
 }
}
