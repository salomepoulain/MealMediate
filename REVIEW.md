
Maandag was ik ziek dus ben ik dinsdag pas op locatie geweest, echter was er geen andere student aanwezig, dus zal ik mijzelf reviewen.
___
Mijn eerste probleem is dat ik engels en nederlandse termen door elkaar gebruik. Mijn mobieltje staat ingesteld op engels maar ik wilde de app Nederlands hebben omdat recepten en gerechten en ingrediënten in het dagelijkse leven allemaal in het nederlands worden verteld. Ik denk dat als ik de app opnieuw zou maken, dat ik alle code, dus de modellen, de functies en de variabelen in het engels zou houden, evenals alle file names in het nederlands, maar alle user inface termen misschien wel in het nederlands had gedaan.

___

Ten tweede vind ik mijn sorteer extention vrij onduidelijk. Het is mooier om alle functionaliteit in de ViewModel te hebben. Ik zou dan de grotere sort functie kunnen opsplitsen in kleinere functies, zodat dit beter is voor de leesbaarheid en het onderhoud.
    Ook zou ik graag mijn sorteer functie opnieuw en slimmer willen herimplementeren. Ik vind dat ik een vrij ambigieuze manier heb gebruikt om te checken of er twee filters tegelijk worden gebruikt, maar zodra ik meer filter ga toevoegen wordt dit erg "messy". Ik moet eigenlijk kijken welke filters aan staan en dan van dit allemaal de intersection pakken. 

Ik zou dit willen herschrijven als volgt:

- In de ViewModel class komt een filterEnSorteer functie
- Als eerste wordt gekeken welke filters aan staan
- Vervolgens wordt de intersection bepaald
- Hierna wordt gesorteerd met een sorteerfunctie

Het bepalen van een intersection kan ik misschien met sets doen. Dit moet ik goed uitwerken.

Zodra deze code netjes is, is het makkelijker om extra filter opties toe te voegen. Wellicht met een set of met een .map en een switchcase.

___

Mijn ingredientenModel gebruikt een Int voor de isLekker eigenschap. Voor mij is duidelijk wat elk getal betekent, maar beter is om hiervan een Enum te maken, zodat alleen het juiste beperkt aantal opties mogelijk is. De code is netter als alleen al uit het model duidelijk is wat alles betekent.
___
De code achter het indelen van de dagen van mijn weekschema is vrij chaotisch. In plaats van echte datum getallen te gebruiken, maar ik gebruik van het tellen van 0-6. Als alleen maandag kon worden gekozen als begindag, was alle code vrij consistent. Als een recept op maandag en weonsdag zou worden gekozen, zou dit het getal 0 en 2 krijgen. Alles wordt echter ingewikkeld en vrij onleesbaar wanneer de begindag verandert kan worden. Dit heeft te maken met het feit dat sommige functies wel en niet gebruik moeten maken van % 7 en je het verschil tussen maandag en de gekozen begindag in acht moet nemen. Elke functie voelt nu als een ingewikkelde rekensom, in plaats van heldere code die direct goed te snappen is.

Als ik de code zou willen herschrijven zou ik misschien gebruikmaken van de echte datum voor het bepalen van de huidige dag, in plaats van een integer getal hiervoor te gebruiken. Ik denk dat hierdoor de code leesbaarder wordt en het wellicht makkelijker is om de begindag op een andere manier te integreren, zodat deze ook "volgende week" kan beginnen. Ik wilde dit doen, maar dit lukte niet vanwege mijn ingewikkelde implementatie. Nu kan moet de begindag per se binnen de huidige week vallen. 

Misschien kan ik ook toevoegen dat de gerechten een echte datum bevatten in plaats van de dag van de week. Ik kan misschien op deze manier misschien een soort geschiedenis bijhouden van wanneer een gerecht voor heet laatst is gegeten. 
____
Bij sommige functies mag ik meer documentatie en comments schrijven van wat de functie precies doet