# Individuell slutrapport
Samuel
Team1
2026/11/13
---
## Syfte och kursmål
---
## 1. Professionell sammanfattning
Under dom här 2 månaderna så har vårat lag aktivt arbetat med att härda en gcloud server som har  en webbapplikation inbygg i så vi gjorde flera tester på. Under denna period arbetade jag och mina lagkamrater aktivt tillsammans så att om en person upptäckte ett fel så förmedlade han det till alla andra i gruppen så att vi kunde snabbt starta en felsökning gällande vad som orsakade problemet. huvudsaken med allt detta var för att just härda våran application så mycket som vi kunde så att ingen ska kunna bryta sig in. En av dom största riskerna som står kvar fortfarande är att användare har för många behörigheter när man loggar in 
---
## 2. Kontext och avgränsning

Detta projektet handlade om både blue team och red team då vi skulle både härda en application och sen göra tester på den för att se och hitta sårbarheter som man sen noterar så att man sen kan patcha dom för att uppehålla en säker miljö

## 3. Mitt individuella bidrag
Så under denna period då jag arbetade med miljön så hjälpte jag  med att härda och ge ideer om vad som kan göra. Jag hjälpte även till med att dokumentera saker som gjordes och när lagkamrater i laget fastnade så försökte jag alltid hjälpa dom att troubleshooting vad som var problemet. 

I red team dock var jag som en guardrail för malcolm då han älskar att göra kanske för mycket och såg till att han inte bröt mot våran ROE medan jag samtidigt gjorde tester mot acme hemsidan och noterade fynd 
---
## 4. Viktigaste projektresultat och evidens


Gick från ssh inlog till tailscale med gcloud för att nå servern
### Resultat
Alla som loggar in måste ha ett kopplat gcloud konto som har behörighet
### Evidens
commits i github
### Verksamhets- och säkerhetsbetydelse
Vi har gått ifrån vanliga SSH nycklar då vem som helst kan logga in men om det krävs ett tillåtet gcloud konto så att vem som helst inte kan komma in
### Rekommendation
Granska tillåtna google konton regelbundet



Loggning men ingen reaction
### Resultat
Efter alla våra tester så hittade vi loggar men inga varningar om att någon attackerade
### Evidens
Loggarna från comerit mot våra dokumenterade attacksteg
### Verksamhets- och säkerhetsbetydelse
Intrång utan att någon skulle veta om det
### Rekommendation
Sätt upp regeldetektering så att i framtiden skulle systemet varna vid misstänktsam aktivitet


---
## 5. KPI:er och ledningsrapportering

Åtgärdade säkerhetsbrister, Ser till att man aktivt arbetar för att lösa alla
Infrastruktur stabilitet, Visar hur stabilt systemet är
CI/CD scanningar, Visar hur stor mängd är godkända

Dessa är användbara då det visar att man har aktivt arbetat för att förbättra systemet och håller det updaterat, det är anledningen till just domma så att man vet att systemet hålls uppe i ett bra skick, Ett säkert system kan vara säkert idag men imorgon so upptäcks en bugg så man måste alltid vara aktiv
---
## 6. Incidentrespons, post-mortem och förbättringsarbete

Efter allt detta jobb så visar det sig att det bästa man kan ha det är ett komplett loggsystem som övervakar vad som händer, Om vi hade haft det så hade många problem blivit larmade till oss, för att om vi bara tittar runt är det lätt att man missar något
---
## 7. AI i säkerhetsarbetetBeskriv och värdera din användning av generativa AI-assistenter och AI-assisterade
säkerhetsverktyg i projektets arbetsflöde.
### Konkreta användningsfall
Jag använde endast Chatgpt, Och när jag använde det var när jag behövde hjälp för att lista ut vad det mest troliga problemet var. ett exempel var när jag inte kunde komma in i spectre hemsidan och då kunde ai’n gissa efter informationen som jag gav den säga vad med det största sannolikheten problemet var någonstans vilket den var korrekt om.



### När AI var lämpligt
I exemplet ovan så visste jag inte riktigt var felet var om just varför jag inte kunde nå hemsidan så då är AI lämpligt för att kunna veta var man ska titta efter och med det lära sig vad problemet var för något


### När AI var olämpligt eller otillräckligt
Att bara be den generera kod för hela github projected. med det så ger man hela källkåden till chatgpt vilket inte är OK och att vem vet om koden som den skriver är säker eller inte då den ändrar stora delar på en gång utan att man själv vet vad koden gör

### Verifiering och mänsklig kontroll
Jag bad AI’n att beskriva varje liten sak som den gav förslag om så att jag hade en förståelse för sakerna så att man vet vad varje sak gör så att man har full koll på projectet istället för att man långsamt tappar förståelse med mer och mer användning

### Risker och professionella gränser
Läkt källkåd och att ha en person som bara använder chatgpt utan att tänka är så oproffsigt som det kan vara plus att säkerhetslösningar som AI’n förslår kan ha sina egna gigantiska hål som kan bli exploitade

### Professionell slutsats
AI’s är ett kraftigt verktyg för just felsökning men man ska vara försiktig med just lösningar som dom rekommenderar. För att även om man  skumläser så kan det väldigt lätt bli fel genom att man inte förstår allt som den spottar ut som kommer sen skapa problem längre ner. Så att även om det är attraktivt att låta en AI göra så mycket som möjligt så kommer det bara skada dig långsiktigt

---
## 8. Prioriterade rekommendationer
Det absolut viktigaste är att sätta upp regler för just loggningar som noterades ovanför så att man aktivt kan vara redo mot nya hot som dyker upp och därefter så skulle jag säga att se till att betala för github premium få att man får tillgång till alla starka verktyg så att man kan utöka säkerheten yttligare
---
## 9. Individuell reflektion
### Vad kan jag nu som jag inte kunde när kursen började?
Pentesting är det största, Innan så hade vi owasp juice shop men då så förstod jag i princip ingeting men nu efter jag fick vart jag skulle researcha om det så har jag fått kunskap inom området och jag har även blivit bättre på just att använde github.
### Vilket moment har förändrat mitt sätt att arbeta med cybersäkerhet mest?
Jag skulle säga att mitt tänk har ändrat lite mer hur jag  tacklar problem.
### Vad skulle jag göra annorlunda om projektet började idag?
Jag skulle säga att hur jag arbetar med andra personer samt hur man använder AI korrekt. Innan denna kursen har jag använt AI extremt sällan på grund av att jag är rädd av att jag skulle få ett beroende av verktyget men det är ett extremt bra verktyg gällande just lärande 
och kommer nu framöver fortsätta använde AI mer 
### Vad tar jag med mig till LIA och min framtida yrkesroll?
Hur man arbetar med andra personer i större project och gör pen test plus att hur man använder AI korrekt
**Omfattning:** cirka 300–500 ord totalt. AI-värderingen görs separat i avsnitt 7
och behöver inte upprepas här.
---
## 10. Källor och referenser
ChatGPT
Våra github repon och alla  dokument i dom ITSX25-Chas/team1-documentation: Documentation for Team 1 – Course 6 Advanced IT Security ITSX25-Chas/team1-infra 
MITRE ATT&CK® 


