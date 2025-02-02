open Lib.Ast
open Lib.Eval
open Shared

let i = Abs (x, Var x)
let delta = Abs (x, App (Var x, Var x))
let s = Abs (x, Abs (y, Abs (z, App (App (Var x, Var z), App (Var y, Var z)))))
let k = Abs (x, Abs (y, Var x))

let one = Abs (f, Abs (e, App (Var f, Var e)))
let two = Abs (f, Abs (e, App (Var f, App (Var f, Var e))))
let three = Abs (f, Abs (e, App (Var f, App (Var f, App (Var f, Var e)))))
let four = Abs (f, Abs (e, App (Var f, App (Var f, App (Var f, App (Var f, Var e))))))

let add = Abs(n, Abs(m, Abs(f, Abs(e, App(App(Var m, Var f), App(App(Var n, Var f), Var e))))))
let mul = Abs(n, Abs(m, Abs(f, Abs(e, App(App(Var n, App(Var m, Var f)), Var e)))))

let test_II           = test_eval (App (i, i))                  i
let test_SII          = test_eval (App (App (s, i), i))         (Abs (y, App (Var y, Var y)))
let test_SKK          = test_eval (App (App (s, k), k))         i
let test_deltaII      = test_eval (App (delta, App (i, i)))     i
let test_plus_one_two = test_eval (App (App (add, one), two))   three
let test_plus_two_two = test_eval (App (App (add, two), two))   four
let test_mul_one_two  = test_eval (App (App (mul, one), two))   two
let test_mul_two_two  = test_eval (App (App (mul, two), two))   four

let () =
  let open Alcotest in
  run "2 - Eval" [
    "II", [ test_case (show_pterm (App (i, i))) `Quick test_II ];

    "add", [
      test_case (show_pterm (App (App (add, one), two))) `Quick test_plus_one_two;
      test_case (show_pterm (App (App (add, two), two))) `Quick test_plus_two_two 
    ];

    "mul", [
      test_case (show_pterm (App (App (mul, one), two))) `Quick test_mul_one_two;
      test_case (show_pterm (App (App (mul, two), two))) `Quick test_mul_two_two 
    ];

    "SKK", [ test_case (show_pterm (App (App (s, k), k))) `Quick test_SKK ];
    "SII", [ test_case (show_pterm (App (App (s, i), i))) `Quick test_SII ];
    "deltaII", [ test_case "Delta I I" `Quick test_deltaII ] 
  ]
;;
