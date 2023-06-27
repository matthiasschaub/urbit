::                                                    ::
::::                    ++la                          ::  (2v) vector/matrix ops
|%
++  la
  ^|
  !:
  |_  r=$?(%n %u %d %z)   :: round nearest, round up, round down, round to zero
  ::
  ::  Metadata
  ::
  +$  ray  ::     $ray:  n-dimensional array
    $:  =meta     ::  descriptor
        data=@ux  ::  data, row-major order
    ==
  ::
  +$  meta  ::          $meta:  metadata for a $ray
    $:  shape=(list @)  ::  list of dimension lengths
        =bloq           ::  logarithm of bitwidth
        aura=@tas       ::  name of data type
    ==
  ::
  +$  baum  ::   $baum:  n-dimensional array as a nested list
    $@  @        ::  single item
    (lest baum)  ::  nonempty list of children, in row-major order
  ::
  ::  Utilities
  ::
  ++  print
    |=  a=ray
    ~>  %slog.1^(to-tank a)
    ~
  ++  slog  |=(a=ray (^slog (to-tank a) ~))
  ++  to-tank  ::  TODO nest dimensions
    |=  a=ray
    ^-  tank
    :+  %rose  [" " "[" "]"]
    %+  turn  (ravel a)
    |=  i=@
    ^-  tank
    (sell [%atom aura.meta.a ~] i)
  ::
  ++  get-item  ::  extract item at index .dex
    |=  [=ray dex=(list @)]
    ^-  @ux
    (cut bloq.meta.ray [(get-bloq-offset -.ray dex) 1] data.ray)
  ::
  ++  set-item  ::  set item at index .dex to .val
    |=  [=ray dex=(list @) val=@]
    ^+  ray
    :-  -.ray
    (sew bloq.meta.ray [(get-bloq-offset -.ray dex) 1 val] data.ray)
  ::
  ++  get-bloq-offset  ::  get bloq offset of n-dimensional index
    |=  [=meta dex=(list @)]
    ^-  @
    +((get-item-number shape.meta dex))
  ::
  ++  get-item-number  ::  convert n-dimensional index to scalar index
    |=  [shape=(list @) dex=(list @)]
    ^-  @
    =.  dex  (flop dex)
    =/  sap  (flop shape)
    =/  cof  1
    =/  ret  0
    |-  ^+  ret
    ?~  sap  ret
    ?~  dex  !!
    ?>  (lth i.dex i.sap)
    %=  $
      sap  t.sap
      dex  t.dex
      cof  (mul cof i.sap)
      ret  (^add ret (mul i.dex cof))
    ==
  ::
  ++  get-item-index
    |=  [shape=(list @) num=@]
    ^-  @
    =/  len  (roll shape mul)  :: TODO will shadow
    =-  (roll - ^add)
    ^-  (list @)
    %+  turn  shape
    |=  wid=@
    (mod (div len wid) num)
  ::
  ++  ravel
    |=  a=ray
    ^-  (list @)
    +:(flop (rip bloq.meta.a data.a))
  ::
  ++  fill
    |=  [=meta x=@]  ^-  ray
    =/  len  (roll shape.meta mul)
    :-  meta
    (con +:(zeros meta) (fil bloq.meta len x))
  ::
  ++  spac
    |=  =ray
    ^-  ^ray
    :-  meta.ray
    (con data:(zeros meta.ray) data.ray)
  ::
  ::  Builders
  ::
  ::    Zeroes
  ++  zeros
    |=  =meta  ^-  ray
    ~_  leaf+"lagoon-fail"
    :-  meta
        (lsh [bloq.meta (roll shape.meta mul)] 1)
  ::    Ones
  ++  ones
    |=  =meta  ^-  ray
    ~_  leaf+"lagoon-fail"
    =/  one
      ?+    aura.meta  ~|(aura.meta !!)
          ?(%u %ub %ux %ud %uv %uw)  `@`1
          ?(%s %sb %sx %sd %sv %sw)  `@`--1
          %r
        ?+  bloq.meta  !!
          %7  .~~~1
          %6  .~1
          %5  .1
          %4  .~~1
        ==
      ==
    (fill meta one)
  ::
  ++  iota
    |=  [=meta n=@ud]
    ^-  ray
    =.  shape.meta  ~[n]
    %-  spac
    :-  meta 
    (rap bloq.meta (gulf 1 n))
  ::
  ::  Operators
  ::
  ++  add
    |=  [a=ray b=ray]
    ^-  ray
    ?>  =(meta.a meta.b)
    %-  spac
    :-  meta.a
    =/  ali  (ravel a)
    =/  bob  (ravel b)
    %+  rep  bloq.meta.a
    =|  res=(list @)
    %-  flop
    |-  ^+  res
    ?@  ali  res
    ?@  bob  res
    =/  sum  ((fun-scalar bloq.meta:a aura.meta:a %add) i.ali i.bob)
    $(ali t.ali, bob t.bob, res [sum res])
  ::
  ++  sub
    |=  [a=ray b=ray]
    ^-  ray
    ?>  =(meta.a meta.b)
    %-  spac
    :-  meta.a
    =/  ali  (ravel a)
    =/  bob  (ravel b)
    %+  rep  bloq.meta.a
    =|  res=(list @)
    %-  flop
    |-  ^+  res
    ?@  ali  res
    ?@  bob  res
    =/  sum  ((fun-scalar bloq.meta:a aura.meta:a %sub) i.ali i.bob)
    $(ali t.ali, bob t.bob, res [sum res])
  ::
  ++  fun-scalar
    |=  [=bloq aura=@tas fun=?(%add %sub %mul %div)]
    ^-  $-([@ @] @)
    ?+    aura  ~|(aura !!)
        ?(%u %ub %ux %ud %uv %uw)  
        ?+  fun  !!
          %add  ~(sum fe bloq)
          %sub  ~(dif fe bloq)
          ::%mul  ~(
          ::%div  ~(
        ==
        ::?(%s %sb %sx %sd %sv %sw)  sum:si
        %r
      ?+  bloq  !!
        %7
        ?-  fun
          %add  ~(add rq r)
          %sub  ~(sub rq r)
          %mul  ~(mul rq r)
          %div  ~(div rq r)
        ==
        %6
        ?-  fun
          %add  ~(add rd r)
          %sub  ~(sub rd r)
          %mul  ~(mul rd r)
          %div  ~(div rd r)
        ==
        %5
        ?-  fun
          %add  ~(add rs r)
          %sub  ~(sub rs r)
          %mul  ~(mul rs r)
          %div  ~(div rs r)
        ==
        %4
        ?-  fun
          %add  ~(add rh r)
          %sub  ~(sub rh r)
          %mul  ~(mul rh r)
          %div  ~(div rh r)
        ==
      ==
    ::
        ::  TODO signed integers -- add new 2's complement aura?
    ==
  --
--
