open! Basis.Rudiments
open! Basis
open! Hmc
open! ScanTest
open Format

let test () =
  printf "@[<h>";
  scan_str ", ,,";
  scan_str ". ..";
  scan_str "; ;; ;;;";
  scan_str "; : := :: :::"; (* Avoid line directive syntax. *)
  scan_str "< <= = <> >= >";
  scan_str "]|]|[|[";
  scan_str "}|}|{|{";
  scan_str "{}";
  scan_str {|\^&\&_&\|};
  scan_str {|!&!!\|};
  scan_str "- -> ->> ->";
  scan_str "~- ~-> ~->> -~->";
  scan_str "type 'a 'ty ^m >e";
  scan_str "^ ^t ^&t";
  scan_str "> >- >-> >->> >>-> >e-> >{e|mut}->";
  scan_str ">e~-> >{e|mut}~-> ~hlt-> ~{hlt|alloc}-> >e~hlt-> >{e|os}~{hlt|alloc}->";
  scan_str "~f ~- ~-+*/%@^$<=>|:.~?";
  scan_str "?x ?? ?-+*/%@^$<=>|:.~?";
  scan_str "0..n 0x3..n 1..=n i..n";
  printf "@]"

let _ = test ()
