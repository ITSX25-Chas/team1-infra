# Lessons Learned

## 1. Loggning är inte samma sak som upptäckt

**Vad lärde vi oss?**

Under projektet såg vi att det inte räcker att samla in loggar för att upptäcka säkerhetsincidenter. Miljön hade loggning, men det saknades fungerande realtidsövervakning och regler som automatiskt reagerade på misstänkt aktivitet. Wazuh SIEM implementerades inte under projektet.

**Orsak och konsekvens**

Fokus låg till stor del på att förebygga säkerhetsproblem genom exempelvis IAM-begränsningar, brandväggsregler och säkrare autentisering. Det gjorde miljön säkrare, men förmågan att upptäcka pågående attacker var fortfarande begränsad. En attack kan därför pågå utan att teamet får en tydlig varning.

**Förbättring och uppföljning**

Vi rekommenderar att införa en central SIEM-lösning, exempelvis Wazuh, med relevanta larmregler. Loggar bör inte bara samlas in utan också analyseras och kopplas till tydliga larm. Uppföljningen bör kontrollera att larmen fungerar genom regelbundna tester.

## 2. Säkerhetskontroller måste övervakas

**Vad lärde vi oss?**

En säkerhetskontroll kan vara konfigurerad men ändå sluta fungera utan att någon märker det. Under projektet upptäckte vi att SBOM-skannern inte gav förväntade larm på grund av en tom konfiguration. Vi såg även att en policy controller hade kraschat 915 gånger under en period på tio dagar.

**Orsak och konsekvens**

Problemet var att vi saknade tillräcklig övervakning av själva säkerhetskontrollerna. När en kontroll inte rapporterade något kunde det uppfattas som att allt fungerade, trots att kontrollen i själva verket kunde vara inaktiv. Det skapade en falsk känsla av säkerhet.

**Förbättring och uppföljning**

Varje viktig säkerhetskontroll bör ha en hälsokontroll eller heartbeat som visar att den fortfarande fungerar. Om en kontroll slutar rapportera eller kraschar ska ett larm skickas till ansvarig person. Kontrollerna bör också testas regelbundet så att vi kan verifiera både funktion och larm.

## 3. Hemligheter kan läcka genom manuella arbetsmoment

**Vad lärde vi oss?**

Vi upptäckte att känslig information kan exponeras även när den tekniska infrastrukturen har förbättrats. Exempel under projektet var en webhook som förekom i bash-historiken, en nyckel som syntes i en skärmbild och ett standardlösenord som fanns kvar i applikationen.

**Orsak och konsekvens**

Detta visar att säkerhet inte enbart handlar om tekniska konfigurationer. Även manuella arbetsrutiner, dokumentation och kommunikation kan skapa risker. Om hemligheter exponeras kan obehöriga få åtkomst till system eller tjänster.

**Förbättring och uppföljning**

Vi rekommenderar att använda en säker lösning för hantering av hemligheter och att undvika att skriva lösenord, nycklar och tokens i terminalhistorik, skärmbilder eller chattar. Standardlösenord ska bytas eller tas bort innan en miljö tas i bruk. Teamet bör även ha tydliga rutiner för hur hemligheter hanteras och regelbundet kontrollera att inga känsliga uppgifter har exponerats.

## Sammanfattning för ledningen

Projektet visade att flera viktiga säkerhetsförbättringar kunde genomföras i molnmiljön. Bland annat förbättrades autentiseringen genom övergång till kortlivade identiteter via WIF/OIDC, publik SSH-åtkomst stängdes och säkerhetskontroller infördes i CI/CD-flödet.

Verifieringen den 8 oktober visade att 27 av 28 infrastrukturtester passerade, samt att 15 av 15 applikationstester och 4 av 4 tester av åtkomstkontroll passerade.

Samtidigt visade projektet att tekniska skydd inte är tillräckliga om organisationen saknar fungerande övervakning och tydligt ansvar. De viktigaste förbättringsområdena är därför:

1. **Införa central säkerhetsövervakning:** Implementera SIEM och larm för misstänkt aktivitet.
2. **Övervaka säkerhetskontroller:** Införa heartbeat och larm när viktiga kontroller slutar fungera.
3. **Förbättra hanteringen av hemligheter:** Använda säkra rutiner och verktyg för lösenord, nycklar och tokens.
4. **Följa upp ansvar och behörigheter:** Genomföra regelbundna granskningar av IAM-behörigheter och säkerställa att det finns tydliga ansvariga.

Den övergripande lärdomen är att säkerhet kräver kontinuerlig uppföljning. Det räcker inte att införa skydd; organisationen måste också kunna verifiera att skydden fungerar och upptäcka när något går fel.
