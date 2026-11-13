## Händelse och avgränsning
den 20 och 27 oktober så körde vi red team och tillsammans som grupp gjorde vi penetrations tester mot en hemsida som vi kunde nå genom att hoppa in på våran tilldelad Gcloud server som vi har härdat under veckorna, 

Jag utförde ett visst antal tester mot hemsidan och höll mig inom ROE och noterade mina fynd i screenshots som jag har laddat upp i min red team inlämning men hemsidan hade flera kritiska sårbarheter som till exempel att man kunde logga in som en admin utan lösenord




---
## Lesson learned 1
### Observation
Loggar insamlade men inget som larmade
### Orsak
Vi hade inga regler läser av dom faktiska loggarna om vad som händer och vad folk gör
### Konsekvens
En obehörig person hade kunnat få tillgång till kritisk information utan angrepp
### Förbättring
Lägg in regler som varnar när onormal aktivitet  händer så att man kan titta in i vad just som sker.
### Uppföljning
Testa reglerna i tester för att se till att det funkar som det ska, Om man aldrig testar dom vet man inte om dom funkar eller ej
---
## Lesson learned 2
### Observation
Ingen tillgång till github secrets
### Orsak
Anledningen till att vi inte hade tillgång till secrets längre i github var för att det kostade nu för att ha tillgång till. I en tidigare kurs så var det en gratis funktion men inte längre och skolan betalade inte för det
### Konsekvens
Det blev ett mycket mer jobbigare arbete för att hålla credentials hemliga i arbetsprocessen
### Förbättring
resurser krävs från chas academy för att kunna göra arbetsprocessen bättre men i slutändan så hittade vi alternativa metoder som höll credentials hemliga genom att lagra dom på google cloud servern själv 
### Uppföljning
Vi lyckades undvika att  credentials blev läkta men det gjorde arbetet jobbigare
## Lesson learned 3
### Observation
Tailscale var helt nere och vi alla pratade med varandra och insåg att det var nere för alla i gruppen utan att någon av oss har gjort några ändringar
### Orsak
Tailscale på lärarens servern gick ner som ledde till att vi inte kunde logga in
### Konsekvens
Ingen kunde logga in på servern för att utföra tester eller för att dokumentera att vi är på plats med spectre appen
### Förbättring
Se till att man är uppmärksam om just att det alltid finns en möjlighet till att tail scale är nere genom att om det skulle hända igen att tail scale är nere utan att någon av oss har gjort en förändring så kollar vi med läraren som äger miljön först
### Uppföljning
Tail Scale gick aldrig ner igen
---
## Professionell sammanfattning

1. Vad inträffade eller simulerades?
Vi fick flera problem på grund av olika saker som inte gick som var planerade. I början så var det planerat att vi skulle använda github secrets för att hålla all kritisk information hemlig och när servern gick ner. Liknande saker hände flera gånger då något slutade fungera eller något funkade inte som det skulle. Då talade vi alla om vad problemet var och så kunde vi snabbt lista ut vad det var som orsakade dom och gällande log problemet så är det alltid viktigt att ha detektion med insamling 
2. Vilka är de viktigaste resultaten och lärdomarna?
När man arbetar tillsammans blir problemen mindre då man tänka igenom vad som gick snett tillsammans och att man alltid ska titta på dom mest troliga problemen först innan man rör om massor med saker för att försöka lösa dom och det är viktigt att testa alla funktioner 
3. Vilka risker eller förbättringsområden identifierades?
Med mindre resurser så blir arbetsprocessen segare som till exempel att vi inte hade tillgång till sekretess så alternativa metoder var tvungna att användas.
4. Vad bör organisationen prioritera härnäst?
Om resurser hade blivit givna till oss så hade vi som grupp kunnat arbeta på ännu bättre och haft bättre förutsättningar och bör därför att faktist spendera resurser för att ge oss bättre möjligheter 
5. Finns något som kräver beslut eller fortsatt uppföljning?
Ja, Om någon ska fortsätta leda projected så borde dom se till att skaffa premium konton på github för att öka säkerheten
