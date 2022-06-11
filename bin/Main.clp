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

(deftemplate info
    (slot skill)
    (slot playStyle)
    (slot manaRelient)
    (slot budget)
)

(deftemplate answerOutput
	(slot key)
    (multislot answer)    
)

(deftemplate champion
	(slot name)
    (slot type)
    (slot difficulty)
    (slot role)
    (slot price)
    (slot magicPower)
    (slot playRate)      
)

(defquery infoQuery
	(info (skill ?skill) (playStyle ?playStyle) (manaRelient ?manaRelient) (budget ?budget))
)

(defquery championQuery
    (champion (name ?name) (type ?Type) (difficulty ?difficulty) (role ?role) (price ?price)  (magicPower ?magicPower) (playRate ?playRate))
)

(defglobal
    ?*index* = 0
	?*physicalNum* = (create$ 1 2 3 4 5 6 7 8 9 10)
	?*magicNum* = (create$ 11 12 13 14 15 16 17 18 19 20)
    ;?*chosenPhysical* = (create$ )
    ;?*chosenMagic* = (create$ )
    ?*totalChamp* = 20
    ?*chosenChampAssert* = 0
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

(deffunction enter()
    (for (bind ?i 0) (< ?i 5) (bind ?i (+ ?i 1))
		(printout t "" crlf)    
	)
)

(deffunction printChampionList(?type)
    (if (eq ?type "Physical")then
     	(printout t "Physical Champion List" crlf)
        (printout t "================================================================================" crlf)
        (printout t "|No.|Name                          |Role      |Difficulty |Price     |Play Rate|" crlf)
        (printout t "================================================================================" crlf)
        (assert (physicalChampList))
		(run)
		(retract-string "(physicalChampList)")
        (bind ?*totalChamp* (+ ?*totalChamp* 1))
        (bind ?*index* 0)
        (printout t "================================================================================" crlf)
     elif(eq ?type "Magic")then
   	  	(printout t "Magic Champion List" crlf)
        (printout t "============================================================================================" crlf)
        (printout t "|No.|Name                          |Role      |Difficulty |Price     |Magic Power|Play Rate|" crlf)
        (printout t "============================================================================================" crlf)
        (assert (magicChampList))
        (run)
		(retract-string "(magicChampList)")
        (bind ?*totalChamp* (+ ?*totalChamp* 1))
        (bind ?*index* 0)
        (printout t "============================================================================================" crlf)
	)
)


;RULE
(defrule showPhysicalChampion
	(physicalChampList)
    ?i <- (physicalChampion (name ?championName) (difficulty ?championDifficulty) (role ?championRole) (price ?championPrice) (playRate ?championPlayRate) ) 
    =>
    (bind ?*index* (+ ?*index* 1))
    (printout t ?i)
    (format t "|%2.1d.|% -30s|% -10s|% -11s|%-10d|%-9d|% n" ?*index* ?championName ?championRole ?championDifficulty ?championPrice ?championPlayRate)
)

(defrule showMagicChampion
	(magicChampList)
    (magicChampion (name ?championName) (difficulty ?championDifficulty) (role ?championRole) (price ?championPrice) (magicPower ?championMagic) (playRate ?championPlayRate) ) 
    =>
    (bind ?*index* (+ ?*index* 1))
    (format t "|%2.1d.|% -30s|% -10s|% -11s|%-10d|%-11d|%-9d|% n" ?*index* ?championName ?championRole ?championDifficulty ?championPrice ?championMagic ?championPlayRate)
)

(defrule createChampion
	(createChamp  ?name ?type ?difficulty ?role ?price ?magicPower ?playRate )
    =>
    (assert (champion (name ?name) (type ?type) (difficulty ?difficulty) (role ?role) (price ?price) (magicPower ?magicPower) (playRate ?playRate )))
    (bind ?*chosenChampAssert* (+ ?*chosenChampAssert* 1))
)

(defrule answer-playStyle
    (answerOutput (key "playStyle") (answer ?playStyle))
    =>
    (bind ?role "")
    (if (eq ?playStyle "Carrying the game")then
        (bind ?role "Marksman Fighter Assassin Mage")
     elif(eq ?playStyle "Setup Teamfight")then
        (bind ?role "Tank Support Assassin Mage")
     elif(eq ?playStyle "Roaming and Objective focused")then
        (bind ?role "Tank Support Marksman Fighter")
	)
    (assert (answerOutput (key "role") (answer ?role )))
    (bind ?*totalChamp* (+ ?*totalChamp* 1))
)

(defrule y-physicalChampion-y
    (and
        (answerOutput (key "difficulty") (answer "yes"))
        (answerOutput (key "budget") (answer ?budget))
        (or
        	(answerOutput (key "mana") (answer "no"))
            (answerOutput (key "mana") (answer "no preference"))    
		)
        (answerOutput (key "popular") (answer "yes"))
        (answerOutput (key "role") (answer ?role))
	)
    ?index <- (physicalChampion (name ?championName) (difficulty ?championDifficulty &: (eq ?championDifficulty "Hard")) (role ?championRole &: (neq (str-index ?championRole ?role) FALSE)) (price ?championPrice &: (>= ?budget ?championPrice )) (playRate ?championPlayRate &: (>= ?championPlayRate 60)))
	=>
    (assert (createChamp ?championName "physical" ?championDifficulty ?championRole ?championPrice 0 ?championPlayRate ))
    (bind ?*chosenChampAssert* (+ ?*chosenChampAssert* 1))
    (printout t "physic y-y" crlf)
    (printout t "Name: " ?championName crlf)
    (printout t "Difficulty: " ?championDifficulty crlf)
    (printout t "Role: " ?championRole crlf)
    (printout t "Price: " ?championPrice crlf)
    (printout t "Play Rate: " ?championPlayRate crlf)
    ;(retract ?index)
)

(defrule y-physicalChampion-n
    (and
        (answerOutput (key "difficulty") (answer "yes"))
        (answerOutput (key "budget") (answer ?budget))
        (or
        	(answerOutput (key "mana") (answer "no"))
            (answerOutput (key "mana") (answer "no preference"))    
		)
        (answerOutput (key "popular") (answer "no"))
        (answerOutput (key "role") (answer ?role))
	)
    
    ?index <- (physicalChampion (name ?championName) (difficulty ?championDifficulty &: (eq ?championDifficulty "Hard")) (role ?championRole &: (neq (str-index ?championRole ?role) FALSE)) (price ?championPrice &: (>= ?budget ?championPrice )) (playRate ?championPlayRate &: (< ?championPlayRate 60)))
	=>
    (assert (createChamp ?championName "physical" ?championDifficulty ?championRole ?championPrice 0 ?championPlayRate ))
    (bind ?*chosenChampAssert* (+ ?*chosenChampAssert* 1))
    (printout t "physic y-n" crlf)
    (printout t "Name: " ?championName crlf)
    (printout t "Difficulty: " ?championDifficulty crlf)
    (printout t "Role: " ?championRole crlf)
    (printout t "Price: " ?championPrice crlf)
    (printout t "Play Rate: " ?championPlayRate crlf)
    (retract ?index)
)

(defrule n-physicalChampion-y
    (and
        (answerOutput (key "difficulty") (answer "no"))
        (answerOutput (key "budget") (answer ?budget))
        (or
        	(answerOutput (key "mana") (answer "no"))
            (answerOutput (key "mana") (answer "no preference"))    
		)
        (answerOutput (key "popular") (answer "yes"))
        (answerOutput (key "role") (answer ?role))
	)
    
    ?index <- (physicalChampion (name ?championName) (difficulty ?championDifficulty &: (neq (str-index ?championDifficulty "Easy Medium" ) FALSE)) (role ?championRole &: (neq (str-index ?championRole ?role) FALSE)) (price ?championPrice &: (>= ?budget ?championPrice )) (playRate ?championPlayRate &: (>= ?championPlayRate 60)))
	=>
    (assert (createChamp ?championName "physical" ?championDifficulty ?championRole ?championPrice 0 ?championPlayRate ))
    (bind ?*chosenChampAssert* (+ ?*chosenChampAssert* 1))
    (printout t "physic n-y" crlf)
    (printout t "Name: " ?championName crlf)
    (printout t "Difficulty: " ?championDifficulty crlf)
    (printout t "Role: " ?championRole crlf)
    (printout t "Price: " ?championPrice crlf)
    (printout t "Play Rate: " ?championPlayRate crlf)
    ;(retract ?index)
)

(defrule n-physicalChampion-n
    (and
        (answerOutput (key "difficulty") (answer "no"))
        (answerOutput (key "budget") (answer ?budget))
        (or
        	(answerOutput (key "mana") (answer "no"))
            (answerOutput (key "mana") (answer "no preference"))    
		)
        (answerOutput (key "popular") (answer "no"))
        (answerOutput (key "role") (answer ?role))
	)
    
    ?index <- (physicalChampion (name ?championName) (difficulty ?championDifficulty &: (neq (str-index ?championDifficulty "Easy Medium" ) FALSE)) (role ?championRole &: (neq (str-index ?championRole ?role) FALSE)) (price ?championPrice &: (>= ?budget ?championPrice )) (playRate ?championPlayRate &: (< ?championPlayRate 60)))
	=>
    (assert (createChamp ?championName "physical" ?championDifficulty ?championRole ?championPrice 0 ?championPlayRate ))
    (bind ?*chosenChampAssert* (+ ?*chosenChampAssert* 1))
    (printout t "physic n-n" crlf)
    (printout t "Name: " ?championName crlf)
    (printout t "Difficulty: " ?championDifficulty crlf)
    (printout t "Role: " ?championRole crlf)
    (printout t "Price: " ?championPrice crlf)
    (printout t "Play Rate: " ?championPlayRate crlf)
    ;(retract ?index)
)

(defrule y-magicChampion-y
    (and
        (answerOutput (key "difficulty") (answer "yes"))
        (answerOutput (key "budget") (answer ?budget))
        (or
        	(answerOutput (key "mana") (answer "yes"))
            (answerOutput (key "mana") (answer "no preference"))    
		)
        (answerOutput (key "popular") (answer "yes"))
        (answerOutput (key "role") (answer ?role))
	)
    
    ?index <- (magicChampion (name ?championName) (difficulty ?championDifficulty &: (eq ?championDifficulty "Hard")) (role ?championRole &: (neq (str-index ?championRole ?role) FALSE)) (price ?championPrice &: (>= ?budget ?championPrice )) (magicPower ?championMagicPower) (playRate ?championPlayRate &: (>= ?championPlayRate 60)))
	=>
    (assert (createChamp ?championName "magic" ?championDifficulty ?championRole ?championPrice ?championMagicPower ?championPlayRate ))
    (bind ?*chosenChampAssert* (+ ?*chosenChampAssert* 1))
    (printout t "magic y-y" crlf)
    (printout t "Name: " ?championName crlf)
    (printout t "Difficulty: " ?championDifficulty crlf)
    (printout t "Role: " ?championRole crlf)
    (printout t "Price: " ?championPrice crlf)
    (printout t "Magic: " ?championMagicPower crlf)
    (printout t "Play Rate: " ?championPlayRate crlf)
    ;(retract ?index)
)

(defrule y-magicChampion-n
    (and
        (answerOutput (key "difficulty") (answer "yes"))
        (answerOutput (key "budget") (answer ?budget))
        (or
        	(answerOutput (key "mana") (answer "yes"))
            (answerOutput (key "mana") (answer "no preference"))    
		)
        (answerOutput (key "popular") (answer "no"))
        (answerOutput (key "role") (answer ?role))
	)
    
    ?index <- (magicChampion (name ?championName) (difficulty ?championDifficulty &: (eq ?championDifficulty "Hard")) (role ?championRole &: (neq (str-index ?championRole ?role) FALSE)) (price ?championPrice &: (>= ?budget ?championPrice )) (magicPower ?championMagicPower) (playRate ?championPlayRate &: (< ?championPlayRate 60)))
	=>
    (assert (createChamp ?championName "magic" ?championDifficulty ?championRole ?championPrice ?championMagicPower ?championPlayRate ))
    (bind ?*chosenChampAssert* (+ ?*chosenChampAssert* 1))
    (printout t "magic y-n" crlf)
    (printout t "Name: " ?championName crlf)
    (printout t "Difficulty: " ?championDifficulty crlf)
    (printout t "Role: " ?championRole crlf)
    (printout t "Price: " ?championPrice crlf)
    (printout t "Magic: " ?championMagicPower crlf)
    (printout t "Play Rate: " ?championPlayRate crlf)
    (retract ?index)
)

(defrule n-magicChampion-y
    (and
        (answerOutput (key "difficulty") (answer "no"))
        (answerOutput (key "budget") (answer ?budget))
        (or
        	(answerOutput (key "mana") (answer "yes"))
            (answerOutput (key "mana") (answer "no preference"))    
		)
        (answerOutput (key "popular") (answer "yes"))
        (answerOutput (key "role") (answer ?role))
	)
    
    ?index <- (magicChampion (name ?championName) (difficulty ?championDifficulty &: (neq (str-index ?championDifficulty "Easy Medium" ) FALSE)) (role ?championRole &: (neq (str-index ?championRole ?role) FALSE)) (price ?championPrice &: (>= ?budget ?championPrice )) (magicPower ?championMagicPower) (playRate ?championPlayRate &: (>= ?championPlayRate 60)))
	=>
    (assert (createChamp ?championName "magic" ?championDifficulty ?championRole ?championPrice ?championMagicPower ?championPlayRate ))
    (bind ?*chosenChampAssert* (+ ?*chosenChampAssert* 1))
    (printout t "magic n-y" crlf)
    (printout t "Name: " ?championName crlf)
    (printout t "Difficulty: " ?championDifficulty crlf)
    (printout t "Role: " ?championRole crlf)
    (printout t "Price: " ?championPrice crlf)
    (printout t "Magic: " ?championMagicPower crlf)
    (printout t "Play Rate: " ?championPlayRate crlf)
    ;(retract ?index)
)

(defrule n-magicChampion-n
    (and
        (answerOutput (key "difficulty") (answer "no"))
        (answerOutput (key "budget") (answer ?budget))
        (or
        	(answerOutput (key "mana") (answer "yes"))
            (answerOutput (key "mana") (answer "no preference"))    
		)
        (answerOutput (key "popular") (answer "no"))
        (answerOutput (key "role") (answer ?role))
	)
    
    ?index <- (magicChampion (name ?championName) (difficulty ?championDifficulty &: (neq (str-index ?championDifficulty "Easy Medium" ) FALSE)) (role ?championRole &: (neq (str-index ?championRole ?role) FALSE)) (price ?championPrice &: (>= ?budget ?championPrice )) (magicPower ?championMagicPower) (playRate ?championPlayRate &: (<	 ?championPlayRate 60)))
	=>
    (assert (createChamp ?championName "magic" ?championDifficulty ?championRole ?championPrice ?championMagicPower ?championPlayRate ))
    (bind ?*chosenChampAssert* (+ ?*chosenChampAssert* 1))
    (printout t "magic n-n" crlf)
    (printout t "Name: " ?championName crlf)
    (printout t "Difficulty: " ?championDifficulty crlf)
    (printout t "Role: " ?championRole crlf)
    (printout t "Price: " ?championPrice crlf)
    (printout t "Magic: " ?championMagicPower crlf)
    (printout t "Play Rate: " ?championPlayRate crlf)
    ;(retract ?index)
)

;MENU-FUNCTION

(deffunction viewChampion()
    
    (bind ?input -1)
	(while (neq ?input 0)
        (enter)
		(chooseChampionType)
	    (bind ?input (read))
	    ;Check Numeric
	    (if (eq (numberp ?input) FALSE) then
	    	(bind ?input -1) 
	    )
	    (if (eq ?input 1) then
            (printChampionList "Physical")
            
            (printout t "Press ENTER to continue")
    		(readline)
	     elif (eq ?input 2) then
            (printChampionList "Magic")
            
            (printout t "Press ENTER to continue")
    		(readline)
	    )
	)
    
    
)

(deffunction addChampion()
    (enter)
    (bind ?input -1)
	(while (or (< ?input 0) (> ?input 2))
        (chooseChampionType)
	    (bind ?input (read))
	    ;Check Numeric
	    (if (eq (numberp ?input) FALSE) then
	    	(bind ?input -1) 
	    )
	)
    (if (eq ?input 0)then
    	(return)
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
     	(bind ?*physicalNum* (insert$ ?*physicalNum* (+ (length$ ?*physicalNum*) 1) (+ ?*totalChamp* 1) ))
        
     elif (eq ?input 2) then
        (assert (magicChampion (name ?championName) (difficulty ?championDifficulty) (role ?championRole) (price ?championPrice) (magicPower ?championMagic) (playRate ?championPlayRate) ) )
        (bind ?*magicNum* (insert$ ?*magicNum* (+ (length$ ?*magicNum*) 1) (+ ?*totalChamp* 1) ))
    )
    (bind ?*totalChamp* (+ ?*totalChamp* 1))
    (readline)       
    
)

(deffunction updateChampion()
	(enter)
    (bind ?input -1)
	(while (or (< ?input 0) (> ?input 2))
        (chooseChampionType)
	    (bind ?input (read))
	    ;Check Numeric
	    (if (eq (numberp ?input) FALSE) then
	    	(bind ?input -1) 
	    )
	)
    (if (eq ?input 0)then
    	(return)
    )
    (bind ?champChoice 0)
    (bind ?maxChamp 1)
    (bind ?champChoiceName "")
    (if (eq ?input 1) then
    	(bind ?maxChamp (length$ ?*physicalNum*))
        (bind ?champChoiceName "physical")
        (printChampionList "Physical")
     elif (eq ?input 2) then
        (bind ?maxChamp (length$ ?*magicNum*))
        (bind ?champChoiceName "magic")
        (printChampionList "Magic")
	)
    
    (while (or (< ?champChoice 1) (> ?champChoice ?maxChamp))
        (format t "Input champion number to be updated [1 - %d] : " ?maxChamp)
    	(bind ?champChoice (read))
        ;Check Numeric
	    (if (eq (numberp ?champChoice) FALSE) then
	    	(bind ?champChoice -1) 
	    )
	)
    
    (printout t "" crlf)
    
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
    
    (bind ?factNumber 0)
    (if (eq ?input 1) then
	    (bind ?champChoice (+ (- (length$ ?*physicalNum*) ?champChoice) 1))
	    (bind ?factNumber (nth$ ?champChoice ?*physicalNum*)) 
        (printout t "champ choice outside: " ?champChoice)
        (modify ?factNumber (name ?championName) (difficulty ?championDifficulty) (role ?championRole) (price ?championPrice) (playRate ?championPlayRate) )
        (bind ?*physicalNum* (delete$ ?*physicalNum* ?champChoice ?champChoice))
        (bind ?*physicalNum* (insert$ ?*physicalNum* (+ (length$ ?*physicalNum*) 1) ?factNumber  ))
     elif (eq ?input 2) then
        (bind ?champChoice (+ (- (length$ ?*magicNum*) ?champChoice) 1))
	    (bind ?factNumber (nth$ ?champChoice ?*magicNum*))
        (printout t "champ choice outside: " ?champChoice)
        (modify ?factNumber (name ?championName) (difficulty ?championDifficulty) (role ?championRole) (price ?championPrice) (magicPower ?championMagic) (playRate ?championPlayRate) )
		(bind ?*magicNum* (delete$ ?*magicNum* ?champChoice ?champChoice))
        (bind ?*magicNum* (insert$ ?*magicNum* (+ (length$ ?*magicNum*) 1) ?factNumber ))
    )
    ;(printout t "Fact Num: " ?factNumber crlf)
    ;(facts)
    
    (printout t "" crlf)
	(format t "Successfully update %s champion!% n" ?champChoiceName)
    (printout t "Press ENTER to continue ...")
    (readline)   
)

(deffunction deleteChampion()
    (enter)
    (bind ?input -1)
	(while (or (< ?input 0) (> ?input 2))
        (chooseChampionType)
	    (bind ?input (read))
	    ;Check Numeric
	    (if (eq (numberp ?input) FALSE) then
	    	(bind ?input -1) 
	    )
	)
    (if (eq ?input 0)then
    	(return)
    )
    (bind ?champChoice 0)
    (bind ?maxChamp 1)
    (if (eq ?input 1) then
    	(bind ?maxChamp (length$ ?*physicalNum*))
        (printChampionList "Physical")
     elif (eq ?input 2) then
        (bind ?maxChamp (length$ ?*magicNum*))
        (printChampionList "Magic")
	)
    (while (or (< ?champChoice 1) (> ?champChoice ?maxChamp))
        (format t "Input champion number to be deleted [1 - %d] : " ?maxChamp)
    	(bind ?champChoice (read))
	)
    (bind ?factNumber 0)
    
    (if (eq ?input 1) then
        (bind ?champChoice (+ (- (length$ ?*physicalNum*) ?champChoice) 1))
	    (bind ?factNumber (nth$ ?champChoice ?*physicalNum*)) 
        
        (printout t "champ choice outside: " ?champChoice)
        ;(bind ?champChoice (+ (- (length$ ?*physicalNum*) ?champChoice) 1))
        (bind ?*physicalNum* (delete$ ?*physicalNum* ?champChoice ?champChoice))
     elif (eq ?input 2) then
        (bind ?champChoice (+ (- (length$ ?*magicNum*) ?champChoice) 1))
	    (bind ?factNumber (nth$ ?champChoice ?*magicNum*))
        
        (printout t "champ choice outside: " ?champChoice)
        ;(bind ?champChoice (+ (- (length$ ?*magicNum*) ?champChoice) 1))
        (bind ?*magicNum* (delete$ ?*magicNum* ?champChoice ?champChoice))
    )
    (retract ?factNumber)
    
    (printout t "" crlf)
	(format t "Successfully deleted champion!")
    (printout t "Press ENTER to continue ...")
    (readline)   
    
)

(deffunction findSuitableChampion()
    (enter)
    (bind ?budget 0)
    (while (or (< ?budget 500) (> ?budget 5000))
		(printout t "How much is your budget ?[500-5000]: ")
    	(bind ?budget (read))
        ;Check Numeric
	    (if (eq (numberp ?budget) FALSE) then
	    	(bind ?budget -1) 
	    )
    )
    (bind ?moreSkill "")
    (while (and (neq ?moreSkill "yes")  (neq ?moreSkill "no") )
        (printout t "Would you prefer champion with more skill requirement ?[yes|no]: ")
        (bind ?moreSkill (readline))
    )
    (bind ?playStyle "")
    (while (and (neq ?playStyle "Carrying the game")  (neq ?playStyle "Setup Teamfight") (neq ?playStyle "Roaming and Objective focused") )
        (printout t "What describes your playstyle [Carrying the game|Setup Teamfight|Roaming and Objective focused]: ")
        (bind ?playStyle (readline))
    )
    (bind ?manaRelient "")
    (while (and (neq ?manaRelient "yes")  (neq ?manaRelient "no") (neq ?manaRelient "no preference"))
        (printout t "Do you prefer a mana reliant champion [yes|no|no preference]: ")
        (bind ?manaRelient (readline))
    )
    (bind ?popular "")
    (while (and (neq ?popular "yes")  (neq ?popular "no") )
        (printout t "Would you prefer a popular champion ?[yes|no]: ")
        (bind ?popular (readline))
    )
    ;Insert Info
    (assert (info (skill ?moreSkill) (playStyle ?playStyle) (manaRelient ?manaRelient) (budget ?budget) ))
    
    
	
    (assert (answerOutput (key "difficulty") (answer ?moreSkill)))
    (assert (answerOutput (key "playStyle") (answer ?playStyle)))
    (assert (answerOutput (key "budget") (answer ?budget)))
    (assert (answerOutput (key "mana") (answer ?manaRelient)))
    (assert (answerOutput (key "popular") (answer ?popular)))
    (run)
    
    
    
    (new Result)
    
    (bind ?*totalChamp* (+ ?*totalChamp* 7))
    (bind ?*totalChamp* (+ ?*totalChamp* 2))
    (bind ?*totalChamp* (+ ?*totalChamp* ?*chosenChampAssert*))
    (printout t "Total champ: " ?*totalChamp* crlf)
    
    
    
    (facts)
    
    (printout t "Chosen Champ: " ?*chosenChampAssert* crlf)
	(for (bind ?i 0) (< ?i (+ 7 ?*chosenChampAssert*)) (bind ?i (+ ?i 1))
    	(retract (- ?*totalChamp* ?i)) 
    )    
    (printout t "Total champ: " ?*totalChamp* crlf)
    (readline)
    (bind ?*chosenChampAssert* 0)
    
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
    (magicChampion (name "Akali") (difficulty "Hard") (role "Assassin") (price 3800) (magicPower 200) (playRate 60))   
    (magicChampion (name "Aurelion Sol") (difficulty "Hard") (role "Mage") (price 1000) (magicPower 70) (playRate 30))   
    (magicChampion (name "Fizz") (difficulty "Medium") (role "Mage") (price 3000) (magicPower 150) (playRate 50))   
    (magicChampion (name "Gragas") (difficulty "Medium") (role "Fighter") (price 3000) (magicPower 60) (playRate 50))
    (magicChampion (name "Mordekaiser") (difficulty "Easy") (role "Fighter") (price 3800) (magicPower 90) (playRate 70))
    (magicChampion (name "Zac") (difficulty "Hard") (role "Tank") (price 2000) (magicPower 70) (playRate 60))   
    (magicChampion (name "Singed") (difficulty "Hard") (role "Tank") (price 1500) (magicPower 50) (playRate 30))   
    (magicChampion (name "Soraka") (difficulty "Easy") (role "Support") (price 1500) (magicPower 50) (playRate 30))   
    (magicChampion (name "Blitzcrank") (difficulty "Easy") (role "Support") (price 3800) (magicPower 50) (playRate 60))        
)
(reset)
;(facts)

(bind ?menuInput 0)

(while (neq ?menuInput 6)
    (facts)
    (printout t ?*physicalNum* " " ?*magicNum* " " ?*totalChamp* crlf)
	(showMenu)
    (bind ?menuInput (read))
    ;Check Numeric
    (if (eq (numberp ?menuInput) FALSE) then
    	(bind ?menuInput 0) 
    )
    (if (eq ?menuInput 1) then
        (viewChampion)
     elif (eq ?menuInput 2) then
        (addChampion)
     elif (eq ?menuInput 3) then
        (updateChampion)
     elif (eq ?menuInput 4) then
        (deleteChampion)
     elif (eq ?menuInput 5) then
        (findSuitableChampion)
    )
)
