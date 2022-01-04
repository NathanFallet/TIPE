(*
* Projet TIPE sur la cryptographie
* et le chiffrement
*
* Partie : Ciphers
*
* Auteur : FALLET Nathan <contact@nathanfallet.me>
*)

(*
* Import des fichiers annexes
*)

open Aes

(*
* Structure commune des ciphers
*)

class virtual cipher cle =
    object (self)
        val cle = cle

        method virtual encrypt: int array -> int array
        method virtual decrypt: int array -> int array
    end

(*
* ECB
*
* On passe juste les données par l'algorithme
*)

class ecb cle =
    object (self)
        inherit cipher cle

        method encrypt entree = chiffrer entree cle
        method decrypt entree = dechiffrer entree cle
    end

(*
* CBC
*
* On ajout un vecteur d'initialisation à l'entrée
* avant de chiffrer avec l'algorithme
*)

class cbc cle vi =
    object (self)
        inherit cipher cle
        val vi = vi

        method encrypt entree =
            let xored = Array.map2 (lxor) entree vi in
            chiffrer xored cle

        method decrypt entree =
            let decrypted = dechiffrer entree cle in
            Array.map2 (lxor) decrypted vi
    end

(*
* OFB
*
* On chiffre un vecteur d'initialisation à l'entrée
* avant de l'ajouter à l'entrée
*)

class ofb cle vi =
    object (self)
        inherit cipher cle
        val vi = vi

        method encrypt entree =
            let s = chiffrer vi cle in
            Array.map2 (lxor) entree s

        method decrypt entree = self#encrypt entree
    end

(*
* CFB
*
* On ajoute un vecteur d'initialisation
* On chiffre le vecteur d'initialisation et on
* applique un ou exclusif sur l'entrée
*
* Le chiffrement et déchiffrement se fait avec la même fonction
*)

class cfb cle vi =
    object (self)
        inherit cipher cle
        val vi = vi

        method encrypt entree =
            let s = chiffrer vi cle in
            Array.map2 (lxor) entree s

        method decrypt entree = self#encrypt entree
    end
