Voor mijn project had ik niet hele grote ideën, maar vooral veel samenhangende kleinde ideeën. Eigenlijk is de basis helemaal gelukt, dus ik kan niet zeggen dat ik andere beslissingen heb gemaakt. Evengoed zijn er een aantal dingen die ik niet wil dat gemist worden waar ik trots op ben.

- Ten eerste is dat er met een modelcontainer de modellen worden ingeladen, waar al standaard waarden in komen te staan als het de eerste keer is dat de app wordt gebruikt.
Hiervoor wordt gebruikgemaakt van een JSON decoder die ingredienten in de ingredientenItem model laadt. Ook wordt er meteen een User aangemaakt.

- Waar ik blij mee ben is dat als een recept wordt gewijzigd, en er op "terug" wordt gedrukt, dat de wijzigingen niet worden opgeslagen. Dit geldt voor zowel het recept zelf, als bij het toevoegen en/of verwijderen van ingrediënten. Bij het wijzigen van een recept wordt er eerst een kopie gemaakt en als er op "terug" wordt gedrukt zullen de wijzigingen via de kopie ongedaan worden gemaakt. Bij de ingredienten zullen de voorgaande geselecteerde ingredienten in een nieuwe array worden 'meegenomen' en zullen bij "voeg toe" tijdelijke toegevoegde ingredienten aan deze array worden toegevoegd, evenals het toevoegen van nieuwe gecreëerde ingredienten in de context. Ingrediënten die worden verwijdert, worden ook pas echt verwijdert als op "voeg toe" wordt geselecteerd. 

- Op drie plaatsen komt het toevoegen van een filter voor. Om kopiëren en plakken zo min mogelijk te voorkomen wilde ik zoveel mogelijk code van het filter in eigen bestandjes hebben. Dit was rond het einde van het project, en toen heb ik via youtube videos over MVVM bekeken (Model, View, ViewModel) wat een manier is om binnen swiftUI te programmeren. Ik besloot dit als een "uitprobeersel" toe te passen voor mijn filter systeem. Dit maakt meteen goed gebruik van het object georinteëerd programmeren zoals geleerd is in programmeren 1. De variabeles in de files die gebruik maken van het filtersysteem zijn nu veel korter, alleen weet ik niet zeker of de leesbaarheid van de code hierop is vooruitgegaan, of dat ik zelf nog moet wennen aan deze nieuwe methode. Ik heb namelijk een extentie gebruikt, maar misschien had ik deze functies in de ViewModel kunnen stoppen (zie review)

- Bij het selecteren van een weekgerecht wilde ik van origine dat het algoritme 6 ongezonde gerechten koos en 1 gezond gerecht. Achteraf bleek het implementeren van dit algoritme helemaal niet zo lastig dus lukte het mij ook om de optie toe te voegen dat er zelf kan worden gekozen hoeveel ongezonde gerechten worden geselecteerd. In de toekomst wil ik misschien implementeren dat een gekozen gerecht niet opnieuw kan worden gekozen. 