;
;
; Le programme "TP3 - Morse personnalisé".
;
; @author Nicolas Trote
; @version 2016-10-25
;
;          Le programme "TP3 - Morse personnalisé" permet d'encoder et de
;          traduire du code morse au travers d'un arbre binaire. L'arbre
;          binaire contiendra les caractères point et tiret.
; *
; * Lancement du programme et initialisation
; *
main:    LDA     0,i         
         CALL    iniRacin    ; création de la racine
         CALL    initE       ; création du noeud (".", 'E')
         CALL    initVidE    ; création du noeud ("..", '0')
         CALL    initS       ; création du noeud ("...", 'S')
         CALL    initT       ; création du noeud ("-", 'T')
         CALL    initVidT    ; création du noeud ("--", '0')
         CALL    initO       ; création du noeud ("---", 'O')
         BR      menu        
; *
; * Menu du programme
; *
menu:    LDX     racine,d    ; initialisation de X
         LDA     0,i         ; initialisation de A
         CHARI   choix,d     ; lecture du choix = {q,t,c, ,\n}
         LDBYTEA choix,d     
;
         CPA     '\n',i      ; cas choix = '\n'
         BREQ    menu        ; =>  main
;
         CPA     ' ',i       ; cas choix = ' '
         BREQ    menu        ; =>  main
;
         CPA     0,i         ; cas choix = null
         BREQ    menu        ; =>  main
;
         CPA     'q',i       ; cas choix = 'q'
         BREQ    fin         ; =>  fin
;
         CPA     'd',i       ; cas choix = 'd'
         BREQ    decoded     ; =>  décodage d'une lettre
;
         CPA     't',i       ; cas choix = 't'
         BREQ    traduc      ; =>  traduction d'une séquence morse complète en texte.
;
         CPA     'a',i       ; cas choix = 'a'
         BREQ    entreeA     ; =>  Ajoute un code Morse
;
         CPA     'l',i       ; cas choix = 'l'
         BREQ    decoded     ; =>  Liste les caractères de l'arbre
;
         BR      erreur      ; sinon => erreur
;
choix:   .BLOCK  1           ; #1c ; Choix du programme
;
;
iniRacin:LDA     mLength,i   ; taille d'un maillon = 4
         CALL    new         ; X = new Maillon(); #mVal #mNextP #mNextT
         LDA     0,i         
         LDBYTEA "0",i       ; A = '0'
         STBYTEA mVal,x      ; X.val = 0;
         LDA     carNull,d   
         STA     mNextP,x    ; X.NextP = 0;
         STA     mNextT,x    ; X.NextT = 0;
         STX     racine,d    ; racine = X;
         RET0                
;
initE:   LDX     racine,d    ; Ajoute(".", 'E')
         LDA     0,i         
         LDBYTEA "E",i       
         STBYTEA unChar,d    ; unChar = valeur du code morse
         CALL    newNodeP    
         STX     nodeE,d     ; nodeE = adresse du noeud (".", 'E')
         RET0                
;
initVidE:LDX     nodeE,d     ; Ajoute("..", '0')
         LDA     0,i         
         LDBYTEA "0",i       
         STBYTEA unChar,d    ; unChar = valeur du code morse
         CALL    newNodeP    
         STX     nodeVidE,d  ; nodeVidE = adresse du noeud ("..", '0')
         RET0                
;
initS:   LDX     nodeVidE,d  ; Ajoute("...", 'S');
         LDA     0,i         
         LDBYTEA "S",i       
         STBYTEA unChar,d    ; unChar = valeur du code morse
         CALL    newNodeP    
         RET0                
;
initT:   LDX     racine,d    ; Ajoute("-", 'T');
         LDA     0,i         
         LDBYTEA "T",i       
         STBYTEA unChar,d    ; unChar = valeur du code morse
         CALL    newNodeT    
         STX     nodeT,d     ; nodeT = adresse du noeud ("-", 'T')
         RET0                
;
initVidT:LDX     nodeT,d     ; Ajoute("--", '0');
         LDA     0,i         
         LDBYTEA "0",i       
         STBYTEA unChar,d    ; unChar = valeur du code morse
         CALL    newNodeT    
         STX     nodeVidT,d  ; nodeT = adresse du noeud ("--", '0')
         RET0                
;
initO:   LDX     nodeVidT,d  ; Ajoute("---", 'O');
         LDA     0,i         
         LDBYTEA "O",i       
         STBYTEA unChar,d    ; unChar = valeur du code morse
         CALL    newNodeT    
         RET0                
;
newNodeP:STX     adOldNe,d   ; adOldNe = X;
         LDA     mLength,i   
         CALL    new         ; X = new Maillon(); #mVal #mNextP #mNextT
         LDA     0,i         
         LDBYTEA unChar,d    ; A = unChar
         STBYTEA mVal,x      ; X.val = unChar;
         LDA     carNull,d   ; A = "0"
         STA     mNextP,x    ; X.NextP = 0;
         STA     mNextT,x    ; X.NextT = 0;
         STX     adNewNe,d   ; adNewNe = X;
         LDX     adOldNe,d   ; x = adOldNe
         LDA     adNewNe,d   ; A = adNewNe
         STA     mNextP,x    ; adOldNe.mNextP  =  adNewNe
         LDX     adNewNe,d   ; x = adNewNe
         RET0                
;
newNodeT:STX     adOldNe,d   ; adOldNe = X;
         LDA     mLength,i   
         CALL    new         ; X = new Maillon(); #mVal #mNextP #mNextT
         LDA     0,i         
         LDBYTEA unChar,d    ; A = unChar
         STBYTEA mVal,x      ; X.val = unChar;
         LDA     carNull,d   ; A = "0"
         STA     mNextP,x    ; X.NextP = 0;
         STA     mNextT,x    ; X.NextT = 0;
         STX     adNewNe,d   ; adNewNe = X;
         LDX     adOldNe,d   ; x = adOldNe
         LDA     adNewNe,d   ; A = adNewNe
         STA     mNextT,x    ; adOldNe.mNextT  =  adNewNe
         LDX     adNewNe,d   ; x = adNewNe
         RET0                
;
entreeA: LDX     racine,d    ; initialisation de X à l'adresse de racine
         LDA     0,i         
         CHARI   choix,d     
         LDBYTEA choix,d     
         STBYTEA unChar,d    ; unChar = valeur du code morse
         CALL    loopEntr    
         LDA     0,i         
         LDBYTEA unChar,d    
         STBYTEA mVal,x      ; X.val = getInt();
         BR      menu        
;
loopEntr:LDA     0,i         
         CHARI   choix,d     
         LDBYTEA choix,d     
         STBYTEA morse,d     ; morse = phrase.charAt(i)
;
         CPA     '\n',i      ; if (morse == '\n')
         BREQ    finCall     ; => fin boucle
;
         CPA     carEspa,d   ; if (morse == ' ')
         BREQ    finCall     ; => fin boucle
;
         CPA     '.',i       ; if (morse == '.')
         BREQ    nodeNulP    ; => nodeNulP
;
         CPA     '-',i       ; if (morse == '-')
         BREQ    nodeNulT    ; => nodeNulT
;
         BR      loopEntr    
;
nodeNulP:LDA     mNextP,x    
         CPA     carNull,d   
         BREQ    brNodeP     ; if (courrant.point = null)
         LDX     mNextP,x    ; sinon courrant = courrant.point;
         BR      loopEntr    
;
brNodeP: STX     adOldNe,d   ; adOldNe = X;
         LDA     mLength,i   
         CALL    new         ; X = new Maillon(); #mVal #mNextP #mNextT
         LDA     0,i         
         LDBYTEA "0",i       ; A = '0'
         STBYTEA mVal,x      ; X.val = 0;
         LDA     carNull,d   ; A = "0"
         STA     mNextP,x    ; X.NextP = 0;
         STA     mNextT,x    ; X.NextT = 0;
         STX     adNewNe,d   ; adNewNe = X;
         LDX     adOldNe,d   ; x = adOldNe
         LDA     adNewNe,d   ; A = adNewNe
         STA     mNextP,x    ; adOldNe.mNextP  =  adNewNe
         LDX     adNewNe,d   ; x = adNewNe
         BR      loopEntr    
;
nodeNulT:LDA     mNextT,x    
         CPA     carNull,d   
         BREQ    brNodeT     ; if (courrant.tiret = null)
         LDX     mNextT,x    ; sinon courrant = courrant.tiret;
         BR      loopEntr    
;
brNodeT: STX     adOldNe,d   ; adOldNe = X;
         LDA     mLength,i   
         CALL    new         ; X = new Maillon(); #mVal #mNextP #mNextT
         LDA     0,i         
         LDBYTEA "0",i       ; A = '0'
         STBYTEA mVal,x      ; X.val = 0;
         LDA     carNull,d   ; A = "0"
         STA     mNextP,x    ; X.NextP = 0;
         STA     mNextT,x    ; X.NextT = 0;
         STX     adNewNe,d   ; adNewNe = X;
         LDX     adOldNe,d   ; x = adOldNe
         LDA     adNewNe,d   ; A = adNewNe
         STA     mNextT,x    ; adOldNe.mNextT  =  adNewNe
         LDX     adNewNe,d   ; x = adNewNe
         BR      loopEntr    
; variables locales
adOldNe: .BLOCK  2           ; #2h adresse de l'ancien noeud
adNewNe: .BLOCK  2           ; #2h adresse du nouveau noeud
;
decoded: CALL    decodeFc   
         CHARO   "\n",i
         BR      menu   
;
decodeFc: LDX     racine,d    ; initialisation de X à l'adresse de racine
         LDA     0,i
         LDBYTEA "0",i
         STBYTEA unChar,d    ; initialisation de unChar = "0"
         CALL    loopDeco    ; => loopDeco  
         LDA     0,i
         LDBYTEA unChar,d 
         CPA     "0",i       ; if unChar = "0"
         BREQ    AffiNop     ; => AffNop        
         CHARO   unChar,d  
         RET0       
;
AffiNop: STRO    mNop,d 
         RET0
loopDeco:LDA     0,i         
         CHARI   choix,d     
         LDBYTEA choix,d     
;
         CPA     '\n',i      ; if (morse == '\n')
         BREQ    finCall     ; => fin boucle
;
         CPA     carEspa,d   ; if (morse == ' ')
         BREQ    finSpace    ; => finSpace
;
         LDA     0,i         ; init unChar car nouvelle boucle
         LDBYTEA "0",i
         STBYTEA unChar,d    ; initialisation de unChar = "0"
;
         LDA     0,i
         LDBYTEA choix,d
;
         CPA     '.',i       ; if (morse == '.')
         BREQ    nodeGoP     ; => nodeGoP
;
         CPA     '-',i       ; if (morse == '-')
         BREQ    nodeGoT     ; => nodeGoT
;
         BR      loopDeco    ; => loopDeco 
;
nodeGoP: LDA     mNextP,x    ; Verif si mNextP existe?
         CPA     "0",i       ; if mNextP = "0" 
         BREQ    finGo       ; => finGo
;
         LDX     mNextP,x    ; X = Next adresse "."
         LDA     0,i
         LDBYTEA mVal,x    
         STBYTEA unChar,d    ; unChar = mVal   
         BR      loopDeco    ; => loopDeco 
;
finGo:   LDA     0,i
         LDBYTEA unChar,d    ; unChar = '0'
         BR      loopDeco    ; => loopDeco  
;
finSpace:LDX     racine,d    ; initialisation de X à l'adresse de racine
         BR      finCall     ; => finCall   
;
nodeGoT: LDA     mNextT,x    ; Verif si mNextT existe?
         CPA     "0",i       ; if mNextT = "0" 
         BREQ    finGo       ; => finGo
;
         LDX     mNextT,x    ; X = Next adresse "-"
         LDA     0,i
         LDBYTEA mVal,x    
         STBYTEA unChar,d    ; unChar = mVal   
         BR      loopDeco    
;
traduc:  LDX     racine,d    ; initialisation de X à l'adresse de racine
         LDA     0,i
         LDBYTEA "0",i
         STBYTEA unChar,d    ; initialisation de unChar = "0"
;
         CALL    loopDeco    ; => loopDeco 
; 
         LDA     0,i
         LDBYTEA unChar,d    ; A = unChar 
         CPA     "0",i       ; if unChar = "0"
         BREQ    AffiInt     ; => AffiInt        
         CHARO   unChar,d    ; sinon print(unChar)
;
         LDA     0,i
         LDBYTEA choix,d     ; A = choix 
         CPA     "\n",i      ; if unChar = "\n"
         BREQ    finTrad     ; => finTrad
;
         BR traduc
;
AffiInt: STRO    mInt,d      ; CHARO   carInte,d
         LDA     0,i
         LDBYTEA choix,d     ; A = choix 
         CPA     "\n",i      ; if unChar = "\n"
         BREQ    finTrad     ; => finTrad
         BR      traduc      ; sinon => traduc
;
finTrad: CHARO   "\n",i      
         BR      menu        ; => menu
;
; ERREUR : message d'erreur
erreur:  STRO    mErreur,d   ;
         BR      fin         
;
; FINCALL: Fin d'un CALL
finCall: RET0                
;
; FIN : etiquette pour quitter le programme
fin:     STOP                
;
; VARIABLES GLOBALES
carNull: .WORD   "0"         
carEspa: .WORD   " "         
racine:  .BLOCK  2           ; #2h  adresse noeud racine del'arbre binaire
nodeE:   .BLOCK  2           ; #2h  adresse noeud pour initialiser l'arbre binaire
nodeVidE:.BLOCK  2           ; #2h  adresse noeud pour initialiser l'arbre binaire
nodeT:   .BLOCK  2           ; #2h  adresse noeud pour initialiser l'arbre binaire
nodeVidT:.BLOCK  2           ; #2h  adresse noeud pour initialiser l'arbre binaire
morse:   .BLOCK  1           ; #1c  codeMorse reçu char par char
unChar:  .BLOCK  1           ; #1c  valeur du code morse
; MESSAGES
mInt:    .ASCII  "?\x00"
mNop:    .ASCII  "nop\x00"
mErreur: .ASCII  "Erreur: commande inconnue\n\x00"
mTotal:  .ASCII  "total=\x00"
; STRUCTURE d'un noeud
; Un arbre binaire est constituée de branches et de noeuds.
; Chaque noeud contient une valeur et les adresses des prochain noeud "point" ou "tiret" suivant.
; La fin d'une branche est marquée arbitrairement par l'adresse 0
mVal:    .EQUATE 0           ; #1c valeur de l'élément dans le noeud
mNextP:  .EQUATE 1           ; #2h noeud "point" (null (aka 0) pour fin de liste)
mNextT:  .EQUATE 3           ; #2h noeud "tiret" (null (aka 0) pour fin de liste)
mLength: .EQUATE 5           ; taille d'un noeud en octets
;
;
;******* operator new
;        Precondition: A contains number of bytes
;        Postcondition: X contains pointer to bytes
new:     LDX     hpPtr,d     ;returned pointer
         ADDA    hpPtr,d     ;allocate from heap
         STA     hpPtr,d     ;update hpPtr
         RET0                
hpPtr:   .ADDRSS heap        ;address of next free byte
heap:    .BLOCK  1           ;first byte in the heap
         .END                  