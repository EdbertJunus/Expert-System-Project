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
    (printout t ">>" crlf)
)

(deffunction chooseChampionType()
    (printout t "Choose champion type to view" crlf)
	(printout t "----------------------------" crlf)
	(printout t "1. Physical Damage Champion" crlf)
	(printout t "2. Magic Damage Champion" crlf)
    (printout t ">> Choose [1..2 | 0 back to main menu]:" crlf)
)

(deffunction viewChampion()
    (chooseChampionType)
    (bind ?input -1)
	(while (neq ?input 0)
		
	    (bind ?input (read))
	    ;Check Numeric
	    (if (eq (numberp ?input) FALSE) then
	    	(bind ?input -1) 
	    )
	    (if (eq ?input 1) then
	        ;View Champions
	     elif (eq ?input 2) then
	        ;Add Champions
	    )
	)
)

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
(facts)

(find-all-facts ((?f physicalChampion)))


(bind ?input 0)
(while (neq ?input 6)
	(showMenu)
    (bind ?input (read))
    ;Check Numeric
    (if (eq (numberp ?input) FALSE) then
    	(bind ?input 0) 
    )
    (if (eq ?input 1) then
        (viewChampion)
     elif (eq ?input 2) then
        ;Add Champions
     elif (eq ?input 3) then
        ;Update Champions
     elif (eq ?input 4) then
        ;Update Champions
     elif (eq ?input 5) then
        ;Update Champions
    )
)
