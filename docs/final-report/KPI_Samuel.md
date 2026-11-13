# KPI:er och säkerhetsmätningar
## Syfte
I den här delen ska du ta fram tre KPI:er som kan användas för att följa upp
säkerhetsläget eller effekten av säkerhetsarbetet.
Utgå från det arbete och de resultat som redan finns i projektet. Du behöver inte
skapa nya tekniska tester enbart för denna uppgift.
En användbar KPI ska hjälpa organisationen att förstå:
- vad som mäts,
- varför det är viktigt,
- hur utvecklingen kan följas över tid,
- när resultatet kräver en åtgärd.
Undvik KPI:er som enbart mäter aktivitet, exempelvis "antal genomförda tester".
Försök i stället mäta säkerhetsläge, risk, kvalitet eller effekt.
---
## KPI 1
### Namn
Åtgärdade säkerhetsbrister
### Syfte
Visar hur många problem som har blivit åtgärdade
### Definition och beräkning
Antal säkerhets problem som har fått åtgärder
### Datakälla
team1-documentation/Säkerhetsrapport at main · ITSX25-Chas/team1-documentation 
### Målvärde eller önskad riktning
19/20 Fynd at blivit åtgärdade och målet är att få alla 20 gjorda
### Mätfrekvens
Varje vecka
### Mottagare
Chefen för företaget så att han kan enkelt se att säkerhetsbrister blir åtgärdad
### Åtgärd vid avvikelse
Spendera mer resurser på att få dom alla fixade
---
## KPI 2
### Namn
Infrastracturens stabilitet
### Syfte
Få en bra syn för just tillgängligheten 
### Definition och beräkning
Hur ofta systemet crashar
### Datakälla
team1-documentation/Säkerhetsrapport at main · ITSX25-Chas/team1-documentation 
### Målvärde eller önskad riktning
Tidigare fick vi 915 krashar på 10 dagar men nu har vi bara 1 omstart som är planerad per dag
### Mätfrekvens
Dagligen
### Mottagare
Chefen för att visa att arbetet har resulterat i dramatiskt mindre krashar som kan påverka project 
### Åtgärd vid avvikelse
---
## KPI 3
### Namn
CI/CD säkerhet skanningar
### Syfte
Detta är för att se till att nya ändringar blir kontrollerade innan dom blir släppta 
### Definition och beräkning
Hur många pull requests som har blivit godkända 
### Datakälla
All workflows 
### Målvärde eller önskad riktning
100% godkända är målet, Om dom blir nekade så blir nya releases försenade
Just nu har bara 1 utav 30 av dom senaste blivit nekade
### Mätfrekvens
Varje my release
### Mottagare
Devops arbetarna och dom som arbetar med säkerheten
### Åtgärd vid avvikelse
Fokusera på varför releases blir nekade
---
## Motivering
Detta visar i klar text just hur arbetet har förbättrat säkerheten och gjort tjänsterna tillgängliga, Det är bland dom viktigaste sakerna som finns genom att alla hatar när ett system går ner på grund av en crash. Samt att man har en KPI för just hur många releases blir godkända är användbart om det skulle plötsligt trenda att många blir nekade så kommer man kunna se det enkelt så att man då bara fråga, Varför är antalet godkända releases låga?


Tillsammans så har man då 3 relevant KPI’s som man regelbundet checkar för att kunna ha en så bra miljö som möjligt med en bra överblick.

