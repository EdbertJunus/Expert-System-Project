;TEMPLATE
(deftemplate physicalChampion
	(slot name)
    (slot difficulty)
    (slot role)
    (slot price)
    (slot playRate)    
)

(deftemplate magicChampion
	(slot name)
    (slot difficulty)
    (slot role)
    (slot price)
    (slot magicPower)
    (slot playRate)    
)


;FUNCTION
(deffunction showMenu()
	(printout t "=====================" crlf)
	(printout t "| league Of legendS |" crlf)
	(printout t "=====================" crlf)
	
	(printout t "1. View champions" crlf)
	(printout t "2. Add a new champion" crlf)
	(printout t "3. Update champion" crlf)
	(printout t "4. Delete champion" crlf)
	(printout t "5. Find suitable champion" crlf)
	(printout t "6. Exit" crlf)
    (printout t ">> ")
)

(deffunction chooseChampionType()
    (printout t "Choose champion type to view" crlf)
	(printout t "----------------------------" crlf)
	(printout t "1. Physical Damage Champion" crlf)
	(printout t "2. Magic Damage Champion" crlf)
    (printout t ">> Choose [1..2 | 0 back to main menu]: ")
)


;MENU-FUNCTION

(deffunction viewChampion()
    
    (bind ?input -1)
	(while (neq ?input 0)
		(chooseChampionType)
	    (bind ?input (read))
	    ;Check Numeric
	    (if (eq (numberp ?input) FALSE) then
	    	(bind ?input -1) 
	    )
	    (if (eq ?input 1) then
	        (facts);View Champions
            (printout t "Press ENTER to continue" crlf)
    		(readline)
	     elif (eq ?input 2) then
	        (facts);Add Champions
            (printout t "Press ENTER to continue" crlf)
    		(readline)
	    )
	)
    
    
)

(deffunction addChampion()
    (bind ?input -1)
	(while (or (< ?input 0) (> ?input 2))
        (chooseChampionType)
	    (bind ?input (read))
	    ;Check Numeric
	    (if (eq (numberp ?input) FALSE) then
	    	(bind ?input -1) 
	    )
	)
    (bind ?roleType "")
    (bind ?priceMinimum 0)
    (bind ?priceMaximum 0)
    (if (eq ?input 1) then
        (bind ?roleType "Marksman")
        (bind ?priceMinimum 1000)
        (bind ?priceMaximum 5500)
     elif (eq ?input 2) then
        (bind ?roleType "Mage")
        (bind ?priceMinimum 1500)
        (bind ?priceMaximum 5000)
    )
	(bind ?championName "")
    (while (or (< (str-length ?championName) 5) (> (str-length ?championName) 30))
        (printout t "Insert Champion Name [5 - 30 Character]: ")
    	(bind ?championName (readline))
    )
    (bind ?championDifficulty "")
    (while (and (neq ?championDifficulty "Easy")  (neq ?championDifficulty "Medium") (neq ?championDifficulty "Hard"))
        (printout t "Insert Champion Difficulty [Easy|Medium|Hard]: ")
        (bind ?championDifficulty (readline))
    )
    (bind ?championRole "")
    (while (and (neq ?championRole ?roleType)  (neq ?championRole "Fighter") (neq ?championRole "Tank") (neq ?championRole "Support") (neq ?championRole "Assassin"))
        (format t "Insert Champion Role [%s|Fighter|Tank|Support|Assassin]: " ?roleType)
        (bind ?championRole (readline))
    )
	(bind ?championPrice 0)
	;Champion Price get from the minimun in fact-list
    (while (or (< ?championPrice ?priceMinimum) (> ?championPrice ?priceMaximum))
		(format t "Insert Champion price [%d-%d]: " ?priceMinimum ?priceMaximum)
    	(bind ?championPrice (read))
    )
    (if (eq ?input 2) then
        (bind ?championMagic 0)
	    (while (or (< ?championMagic 50) (> ?championMagic 200))
	        (printout t "Insert Champion magic power [50-200]: ")
	    	(bind ?championMagic (read))
	    )
    )
    (bind ?championPlayRate 0)
    (while (or (< ?championPlayRate 1) (> ?championPlayRate 100) (neq (mod ?championPlayRate 5) 0))
        (printout t "Insert Champion play rate [1-100]: ")
    	(bind ?championPlayRate (read))
    )
            
	(printout t "" crlf)
	(printout t "Champion successfully added..." crlf)
    (printout t "Press ENTER to continue ..." crlf)        
    
	(if (eq ?input 1) then
	    (assert (physicalChampion (name ?championName) (difficulty ?championDifficulty) (role ?championRole) (price ?championPrice) (playRate ?championPlayRate) ) )
     elif (eq ?input 2) then
        (assert (magicChampion (name ?championName) (difficulty ?championDifficulty) (role ?championRole) (price ?championPrice) (magicPower ?championMagic) (playRate ?championPlayRate) ) )
    )
    (readline)       
    
)

;FACTS

(deffacts faktaPhysicalChampion
	(physicalChampion (name "Alistar") (difficulty "Easy") (role "Tank") (price 1500) (playRate 40) )
    (physicalChampion (name "Master Yi") (difficulty "Easy") (role "Fighter") (price 1200) (playRate 70) )  
    (physicalChampion (name "Ezreal") (difficulty "Medium") (role "Marksman") (price 4800) (playRate 90) )  
    (physicalChampion (name "Fiora") (difficulty "Hard") (role "Assassin") (price 3000) (playRate 40) )  
    (physicalChampion (name "Zed") (difficulty "Hard") (role "Assassin") (price 4800) (playRate 60) )  
    (physicalChampion (name "Garen") (difficulty "Easy") (role "Tank") (price 1000) (playRate 70) )  
    (physicalChampion (name "Olaf") (difficulty "Medium") (role "Fighter") (price 3000) (playRate 50) )  
    (physicalChampion (name "Jhin") (difficulty "Medium") (role "Marksman") (price 3000) (playRate 50) )  
    (physicalChampion (name "Pyke") (difficulty "Medium") (role "Support") (price 3000) (playRate 50) )  
    (physicalChampion (name "Senna") (difficulty "Medium") (role "Support") (price 3000) (playRate 50) )  
)

(deffacts faktaMagicChampion
	(magicChampion (name "Ahri") (difficulty "Medium") (role "Assassin") (price 1500) (magicPower 100) (playRate 65))    
)
(reset)
;(facts)



;(find-all-facts ((?f physicalChampion)) (> ?f:playRate 0))
;(list-deftemplates)

(bind ?menuInput 0)
(while (neq ?menuInput 6)
	(showMenu)
    (bind ?menuInput (read))
    ;Check Numeric
    (if (eq (numberp ?menuInput) FALSE) then
    	(bind ?menuInput 0) 
    )
    (if (eq ?menuInput 1) then
        (viewChampion)
     elif (eq ?menuInput 2) then
        (addChampion);Add Champions
     elif (eq ?menuInput 3) then
        ;Update Champions
     elif (eq ?menuInput 4) then
        ;Update Champions
     elif (eq ?menuInput 5) then
        ;Update Champions
    )
)
