(*
 * Copyright (c) 2015 - present Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *)

(* This module adds more structure to some fields in AST *)
(* The implementation is replacement of default one from *)
(* facebook-clang-plugins repository *)


(* Type pointers *)

exception Not_Clang_Pointer

type t_ptr = [
  | `TPtr of string
  | `Prebuilt of string
  | `PointerOf of t_ptr
  | `ClassType of string
  | `StructType of string
  | `DeclPtr of string
  | `ErrorType]

module TypePointerOrd = struct
  type t = t_ptr
  let compare = Pervasives.compare
end

module TypePointerMap = Map.Make(TypePointerOrd)

let rec type_ptr_to_string type_ptr = match type_ptr with
  | `TPtr raw -> "clang_ptr_" ^ raw
  | `Prebuilt raw -> "prebuilt_" ^ raw
  | `PointerOf typ -> "pointer_of_" ^ type_ptr_to_string typ
  | `ClassType name -> "class_name_" ^ name
  | `StructType name -> "struct_name_" ^ name
  | `DeclPtr raw -> "decl_ptr_" ^ raw
  | `ErrorType -> "error_type"

let type_ptr_to_clang_pointer type_ptr = match type_ptr with
  | `TPtr raw -> raw
  | _ -> raise Not_Clang_Pointer

let pointer_to_type_ptr raw = `TPtr raw

let type_ptr_to_pointer type_ptr = match type_ptr with
  | `TPtr raw -> raw
  | _ -> "custom_type_" ^ (type_ptr_to_string type_ptr)
