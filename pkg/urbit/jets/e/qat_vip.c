#include "all.h"

u3_noun
u3qe_qat_vip(u3_noun a, u3_noun k, u3_noun p, u3_noun v)
{
  if (u3_nul == a) {
    return u3nq(c3__tip, u3k(k), u3k(p), u3k(v));
  }

  u3_noun hoc = u3h(a);

  if (c3n == u3ud(hoc)) {
    return u3m_bail(c3__exit);
  }
  else switch ( hoc ) {
    default:
      return u3m_bail(c3__exit);

    case c3__tip: {
      u3_noun ka, pa, va;
      u3x_trel(u3t(a), &ka, &pa, &va);

      if (c3y == u3r_sing(k, ka)) {
        return u3nq(c3__tip, u3k(k), u3k(p), u3k(v));
      }
      else {
        u3_noun pre = u3nq(c3__tip, u3k(k), u3k(p), u3k(v));
        u3_noun pro = u3qe_qat_rule(ka, pa, va, pre, u3_nul);

        u3z(pre);

        return pro;
      }
    }

    case c3__bin: {
      u3_noun ka, pa, va;
      u3_noun ta, ma, la, ra;
      u3x_qual(u3t(a), &ka, &pa, &va, &ta);
      u3x_trel(ta, &ma, &la, &ra);

      if (c3y == u3qe_qat_feud(ma, k, ka)) {
        u3_noun tee = u3qe_qat_fuse(ma, la, ra);
        u3_noun rof = u3nq(c3__tip, u3k(k), u3k(p), u3k(v));
        u3_noun pro = u3qe_qat_rule(ka, pa, va, rof, tee);

        u3z(tee);
        u3z(rof);

        return pro;
      }
      else if (c3y == u3r_sing(k, ka)) {
        if (c3y == u3qe_qat_zero(ma, k)) {
          u3_noun pre = u3qe_qat_raw(la, k, p, v);
          u3_noun pro = u3qe_qat_fuse(ma, pre, ra);

          u3z(pre);

          return pro;
        }
        else {
          u3_noun pre = u3qe_qat_raw(ra, k, p, v);
          u3_noun pro = u3qe_qat_fuse(ma, la, pre);

          u3z(pre);

          return pro;
        }
      }
      else if (c3y == u3qe_qat_zero(ma, k)) {
        return u3nq(c3__bin, u3k(ka), u3k(pa),
                 u3nq(u3k(va), u3k(ma), u3qe_qat_vip(la, k, p, v),
                   u3k(ra)));
      }
      else {
        return u3nq(c3__bin, u3k(ka), u3k(pa),
                 u3nq(u3k(va), u3k(ma), u3k(la),
                   u3qe_qat_vip(ra, k, p, v)));
      }
    }
  }
}

u3_noun
u3we_qat_vip(u3_noun cor)
{
  u3_noun a, k, p, v;

  if ( (c3n == u3r_mean(cor, u3x_sam_2, &a, u3x_sam_6, &k, u3x_sam_14, &p,
                          u3x_sam_15, &v, 0)) ||
       (c3n == u3ud(p)) )
  {
    return u3m_bail(c3__exit);
  } else {
    return u3qe_qat_vip(a, k, p, v);
  }
}

