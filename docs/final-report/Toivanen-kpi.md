# KPI:er och säkerhetsmätningar

## Syfte och kursmål

Kursmål 4 och 10. Syftet är att ge systemägare och ledning ett beslutsunderlag för kontinuitet och återställningsförmåga i Team 1:s egen miljö. Jag har valt tre kompletterande KPI:er inom backup: återställningstid, möjlig dataförlust och verifierad återställningsbarhet. Projektets Blue Team-rapport visar 27 av 28 godkända infrastrukturkontroller och 15 av 15 godkända applikationstester, men dessa resultat bevisar inte att miljön kan återställas inom en viss tid.

**Mätstatus:** Ej fastställd för samtliga tre KPI:er. Underlaget innehåller inte tillräcklig evidens för att redovisa uppmätta återställningsvärden. Målen nedan är mina förslag för en fiktiv systemägare, inte beslutade SLA:er eller genomförda tester.

## KPI 1

### Namn
Faktisk återställningstid (Recovery Time Actual, RTA).

### Syfte och mottagare
Visar hur länge verksamheten behöver vara utan en kritisk tjänst efter ett avbrott. IT-chef och systemägare kan bedöma om återställningsförmågan motsvarar verksamhetens tolerans för driftstopp.

### Definition och beräkning
RTA = tidpunkt då tjänsten är återställd och godkänd genom funktionstest − tidpunkt för avbrott (eller simulerat avbrott i övning). Redovisas i minuter eller timmar per kritisk tjänst. Tiden omfattar upptäckt, beslut, återställning och verifiering. Vid ett isolerat tekniskt återställningstest där upptäckt inte ingår anges detta separat; resultatet får inte förväxlas med hela incidentens återställningstid.

### Datakälla och datakvalitet
Tidsstämplar från incidentärende, övervakning, backup-/restore-loggar, deployment och godkänt funktionstest. För Team 1 omfattar testet exempelvis återuppbyggnad av GCP-resurser, k3s, applikation, nödvändig konfiguration och databas. Samma scenario och omfattning måste användas vid jämförelser. Ingen uppmätt RTA framgår av rapportunderlaget.

### Målvärde eller önskad riktning
Föreslaget RTO (Recovery Time Objective): högst 4 timmar för den kritiska applikationen. RTO är målet; RTA är utfallet. Grönt ≤ 4 timmar, rött > 4 timmar, grått = saknat verifierat resultat.

### Mätfrekvens
Kvartalsvis återställningsövning och efter större ändringar; vid varje verkligt avbrott. Ledningen får senaste resultat, datum och trend.

### Tolkning och åtgärd vid avvikelse
Ett överskridet RTO innebär risk för längre verksamhetsavbrott än accepterat. Driftansvarig analyserar flaskhalsar, automatiserar återuppbyggnad, uppdaterar instruktioner och genomför ett nytt test. Systemägaren beslutar om resurser eller ändrat mål.

## KPI 2

### Namn
Faktisk återställningspunkt – möjlig dataförlust i tid.

### Syfte och mottagare
Visar hur mycket nyligen skapad eller ändrad information som kan gå förlorad vid ett avbrott. Systemägare och verksamhetsledning kan bedöma om backupfrekvensen är tillräcklig.

### Definition och beräkning
Faktisk återställningspunkt uttryckt som dataförlustfönster = tidpunkt för avbrott − tidsstämpel för senaste konsistenta, verifierat återställningsbara datapunkt före avbrottet. Redovisas i timmar. Vid löpande uppföljning används mättidpunkten i stället för avbrottstidpunkten och måttet benämns ålder på återställningspunkten. En genomförd backup utan verifierad återställningsbarhet räcker inte som bevis.

### Datakälla och datakvalitet
Backupjobbens loggar, databasens återställningsmetadata och resultat från återställningstest. Tidsstämplar ska ha gemensam tidsbas. Backup av konfiguration och databas behöver vara förenliga. Underlaget saknar verifierad återställningspunkt; dataförlustfönstret är därför okänt.

### Målvärde eller önskad riktning
Föreslaget RPO (Recovery Point Objective): högst 24 timmar för labbapplikationens data. Grönt ≤ 24 timmar, rött > 24 timmar, grått = saknad verifierad datapunkt. Tätare backup kan behövas i produktion efter verksamhetsanalys.

### Mätfrekvens
Daglig kontroll av backupstatus och återställningspunktens ålder; kvartalsvis verifiering genom återställning samt efter ändringar av backupkonfigurationen.

### Tolkning och åtgärd vid avvikelse
Överskridet RPO betyder att mer data kan förloras än verksamheten accepterar. Driftansvarig undersöker uteblivna jobb, lagringsfel, behörigheter och datakonsistens. Vid behov ökas backupfrekvensen och systemägaren informeras om risken. En gammal verifierad punkt får inte döljas av nyare oprövade kopior.

## KPI 3

### Namn
Andel kritiska återställningsobjekt med verifierad återställning.

### Syfte och mottagare
Visar om organisationen faktiskt kan använda sina säkerhetskopior och återuppbyggnadsrutiner. CISO och IT-chef får ett mått på täckningen av återställningsförmågan, inte bara på antalet körda backupjobb.

### Definition och beräkning
Antal kritiska återställningsobjekt med godkänt återställningstest under senaste 90 dagarna / totalt antal kritiska objekt i fastställd återställningsinventering × 100. Ett objekt räknas som godkänt endast om återställningen fungerar, data och funktion kontrollerats och resultatet dokumenterats. Ändringar som gör ett tidigare test inaktuellt kräver nytt test. Objekt utan test räknas inte som godkända. Vid tom eller saknad inventering anges ej mätbart.

### Datakälla och datakvalitet
Inventering över kritiska resurser, backupkatalog, Terraform- och Git-referenser, återställningsprotokoll samt funktionstester. Exempel på objekt är databas, applikationsdeployment, klusterkonfiguration och nödvändiga identitets-/konfigurationsberoenden. Infrastruktur som återskapas via IaC får räknas om dess återuppbyggnad verifierats. Hemligheter ska återställas via godkänd säker hantering, inte lagras i klartext i Git. Varken komplett inventering eller godkända återställningsprotokoll finns styrkta i det tillgängliga rapportunderlaget.

### Målvärde eller önskad riktning
100 % av kritiska återställningsobjekt. Grönt = 100 %, rött < 100 % när inventeringen finns, grått = otillräckligt underlag för att beräkna måttet.

### Mätfrekvens
Månadsvis sammanställning av teststatus; återställningsövning minst kvartalsvis och efter väsentliga ändringar.

### Tolkning och åtgärd vid avvikelse
Ett lågt värde visar att återställning av vissa kritiska beroenden inte har bevisats. Det betyder inte nödvändigtvis att kopiorna är trasiga. Driftansvarig prioriterar oprövade kritiska objekt, dokumenterar fel och återtestar. Systemägaren följer upp tills täckningen är fullständig.

## Samlad ledningsrapportering

Jag har valt dessa tre KPI:er eftersom en fungerande backup inte enbart handlar om att säkerhetskopior skapas. Ledningen behöver veta hur länge verksamheten kan bli utan sin tjänst, hur mycket information som kan gå förlorad och om återställningen faktiskt har verifierats. De tre måtten besvarar dessa frågor ur olika perspektiv och ger tillsammans ett underlag för kontinuitetsbeslut.

En första ledningsbild är följande:

| KPI | Nuläge enligt underlaget | Föreslaget mål |
| --- | --- | --- |
| Faktisk återställningstid | Ej uppmätt | ≤ 4 timmar |
| Möjlig dataförlust i tid | Ej uppmätt | ≤ 24 timmar |
| Verifierad återställningstäckning | Ej beräkningsbar | 100 % |

En försämrad återställningstid, äldre återställningspunkter eller sjunkande testtäckning bör leda till åtgärd. Saknade mätvärden ska också uppmärksammas: de innebär att ledningen ännu inte har evidens för förmågan. Jag rekommenderar att systemägaren fastställer RTO och RPO, avsätter tid för en första återställningsövning och utser en ansvarig för regelbunden rapportering.

Måtten visar inte om ett intrång kan förhindras, om angriparen har läst information eller om backupen är fri från kompromettering. De behöver därför kompletteras med åtkomstkontroll, isolerade eller immutabla kopior, säkerhetsövervakning och bedömning av återställningsmiljön. Blue Team-rapportens godkända kontroller är värdefulla men ersätter inte ett dokumenterat återställningstest.

## Källor

- [B] Säkerhetsgranskning och fyndrapport, Team 1, 8 oktober 2026, sammanfattning och verifieringsresultat; sammanställd Blue Team-rapport.
- Målvärden och mätdefinitioner: egna förslag för projektets fiktiva systemägare.

## Kontroll före commit

- [x] Tre KPI:er definierade med mottagare, beräkning, datakälla, mål och mätfrekvens.
- [x] Tolkning, avvikelsehantering och begränsningar beskrivna.
- [ ] Kontrollera om ytterligare återställningsprotokoll finns i projektet och komplettera i så fall nuläget.
- [ ] Commit och push till GitHub.
