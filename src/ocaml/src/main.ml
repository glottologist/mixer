open cmdliner;;
open eio;;

let () =
  let args = parse_argv [] in
    if args.(0) = "-h" then
      print_help ()
    else
      let seed_phrase = args.(1) in
      let pin = args.(2) in
        if (length seed_phrase % length pin) <> 0 then
          print_endline "The length of the pin must be a factor of the length of the seed phrase"
        else
          let words_file = open_file "words.txt" in
            let words = read_words_file words_file in
              close_file words_file;
              let index_to_word = Map.of_list (List.zip (List.range 0 2048) words) in
                for i = 0 to (length seed_phrase - 1) do
                  print_endline (string_of_int i ^ ": " ^ index_to_word (seed_phrase.[i]));;

let read_words_file file =
  let reader = open_reader file in
    let words = ref [] in
      while true do
        let word = read_line reader in
          if word = "" then
            break
          else
            words := word :: !words;
    done;
    close_reader reader;
    List.rev !words;;
