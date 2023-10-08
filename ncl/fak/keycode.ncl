let util = import "util_functions.ncl" in
let hid_codes = import "hid_codes.ncl" in

let mod_ = fun K t => let K = fun mod => K t { mods."%{mod}" = true } in {
  lctl = K "left_ctrl",
  lsft = K "left_shift",
  lalt = K "left_alt",
  lgui = K "left_gui",
  rctl = K "right_ctrl",
  rsft = K "right_shift",
  ralt = K "right_alt",
  rgui = K "right_gui",
} in

{
  tap = let 
    K = fun t d => { type = 'hold_tap, data.tap = { type = t, data = d } }
  in {
    none = K 'none {},
    reg = {
      kc = let _K = fun x => K 'regular { hid_code = x } in
        hid_codes
        |> util.array.enumerate
        |> std.array.flat_map (fun { index, value } =>
            value
            |> std.array.map (fun v => { "%{v}" = _K index })
          )
        |> std.array.reduce_left (&),
      mod = mod_ K 'regular,
      ks = {
        CIRC = kc.N6,
        DLR = kc.N4,
        TILD = kc.GRV,
        PIPE = kc.BSLS,
        PERC = kc.N5,
        AMPR = kc.N7,
        ASTR = kc.N8,
        HASH = kc.N3,
        AT = kc.N2,
        DQUO = kc.QUOT,
        LCBR = kc.LBRC,
        RCBR = kc.RBRC,
        LPRN = kc.N9,
        RPRN = kc.N0,
        LABK = kc.COMM,
        RABK = kc.DOT,
        QUES = kc.SLSH,
        UNDS = kc.MINS,
        PLUS = kc.EQL,
        COLN = kc.SCLN,
        EXLM = kc.N1,
      }
      |> std.record.map_values ((&) mod.lsft),
    },
    layer = let K = fun i op => K 'layer { layer = i, operation = op } in {
      DF = fun i => K i 'df,
      TG = fun i => K i 'tog,
      TO = fun i => K i 'to,
    },
    custom = let K = fun t c => K 'custom { type = t, code = c } in {
      fak = let K = fun code => K 'fak code in {
        RESET = K 0,
        BOOT = K 1,
      },
      media = let K = fun code => K 'consumer code in {
        PLAY = K 205,
        MUTE = K 226,
        VOLU = K 233,
        VOLD = K 234,
        NEXT = K 181,
        PREV = K 182,
      }
    },
    trans = K 'transparent {},
  },
  
  hold = let
    K = fun t d => { type = 'hold_tap, data.hold = { type = t, data = d } }
  in {
    none = K 'none {},
    reg = {
      behavior = fun b => K 'regular { behavior = b },
      layer = fun i => K 'regular { layer = i },
      mod = mod_ K 'regular
    },
    nop = fun b => K 'nop { behavior = b },
    trans = K 'transparent {}
  },
  
  td = {
    make = fun t b => {
      type = 'tap_dance,
      data = {
        tapping_term_ms = t,
        bindings = b
      }
    }
  },

  combo = {
    make = fun t k => {
      type = 'combo,
      data = {
        timeout_ms = t,
        key_indices = k,
      },
    }
  },
  
  MO = fun i => hold.reg.layer i,
  LT = fun b i tap => hold.reg.behavior b & hold.reg.layer i & tap,
  LM = fun b i mods tap => LT b i tap,
  DF = fun i => tap.layer.DF i,
  TG = fun i => tap.layer.TG i,
  TO = fun i => tap.layer.TO i,
  CTL_T = fun b tap => hold.reg.behavior b & hold.reg.mod.lctl & tap,
}