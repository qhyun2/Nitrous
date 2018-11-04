//collideLineLine(start1.x, start1.y, end1.x, end1.y, start2.x, start2.y, end2.x, end2.y)
boolean collideLineLine(PVector start1, PVector end1, PVector start2, PVector end2) {
  /* Shamelessly stolen from p5.collide2d.js */
  /* Albeit, I did tweak it to work with processing, plus simplify it slightly */

  // calculate the distance to intersection point
  float uA = ((end2.x-start2.x)*(start1.y-start2.y) - (end2.y-start2.y)*(start1.x-start2.x)) / ((end2.y-start2.y)*(end1.x-start1.x) - (end2.x-start2.x)*(end1.y-start1.y));
  float uB = ((end1.x-start1.x)*(start1.y-start2.y) - (end1.y-start1.y)*(start1.x-start2.x)) / ((end2.y-start2.y)*(end1.x-start1.x) - (end2.x-start2.x)*(end1.y-start1.y));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
    return true;
  } else return false;
}

boolean collidePolyPoly(PVector[] p, PVector[] e) {
  for (int i = 0; i < p.length; i++) {
    for (int j = 0; j < e.length; j++) {
      int i2 = (i + 1 >= p.length) ? 0 : i + 1;
      //If the next index after i is past p's length, then set it to zero (last links to first)
      int j2 = (j + 1 >= e.length) ? 0 : j + 1;
      //Same goes for j and e.
      if (collideLineLine(p[i], p[i2], e[j], e[j2])) return true;
    }
  }
  return false;
}
