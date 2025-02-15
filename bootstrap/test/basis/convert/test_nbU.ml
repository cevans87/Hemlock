open! Basis.Rudiments
open! Basis
open Format

let test () =
  printf "@[<h>";
  List.iter U8.([kv 0L; kv 1L; kv 127L; kv 128L; kv 255L]) ~f:(fun u ->
    printf "extend_to_uns %a -> %a\n"
      U8.pp u
      Uns.pp (U8.extend_to_uns u)
  );
  printf "\n";
  List.iter [0L; 1L; 255L; 256L; 511L] ~f:(fun u ->
    printf "trunc_of_uns/narrow_of_uns_opt %a -> %a/%a\n"
      Uns.pp u
      U8.pp (U8.trunc_of_uns u)
      (Option.pp U8.pp) (U8.narrow_of_uns_opt u)
  );
  printf "\n";
  List.iter U8.([kv 0L; kv 1L; kv 127L; kv 128L; kv 255L]) ~f:(fun u ->
    printf "extend_to_sint %a -> %a\n"
      U8.pp u
      Sint.pp (U8.extend_to_sint u)
  );
  printf "\n";
  List.iter Sint.([kv (-1L); kv 0L; kv 1L; kv 255L; kv 256L; kv 511L]) ~f:(fun i ->
    printf "trunc_of_sint/narrow_of_sint_opt %a -> %a/%a\n"
      Sint.pp i
      U8.pp (U8.trunc_of_sint i)
      (Option.pp U8.pp) (U8.narrow_of_sint_opt i)
  );

  printf "@]"

let _ = test ()
