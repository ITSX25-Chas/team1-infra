# KPI:er och säkerhetsmätningar

**Namn:** Abdulghani Fkhir  
**Projekt/team:** Team 1, Avancerad IT-säkerhet (ITSX25)  
**Datum:** 2026-11-15  
**Repository:** [ITSX25-Chas/team1-infra](https://github.com/ITSX25-Chas/team1-infra)

Den här filen hör ihop med [individual-report-abdulghani.md](./individual-report-abdulghani.md) och [lessons-learned-abdulghani.md](./lessons-learned-abdulghani.md). Den knyter an till kursmål 4 och 10.

Jag har tre KPI:er, en för varje förmåga vi bedömde: förebygga, åtgärda och upptäcka. KPI 1 och 2 har jag räknat fram själv ur git-historiken, med stöd av AI (se avsnitt 7 i den individuella rapporten). KPI 3 bygger på teamets mätning av tid till upptäckt, som jag har definierat om.

---

## KPI 1

### Namn

Breda åtkomstregler kvar i vår kod

### Syfte och mottagare

Visar hur mycket vi lämnar öppet i miljön vi själva styr. Mottagare är IT-chef och CISO, som avgör om härdningen är klar.

### Definition och beräkning

Antal kvarvarande regler av tre typer: läsrätt för `allAuthenticatedUsers` på state-bucketen, rollen `roles/editor` på ett tjänstekonto och en brandväggsregel som släpper in all trafik från `0.0.0.0/0`.

`Breda regler kvar = antal allAuthenticatedUsers-läsrätter + antal roles/editor-roller + antal brandväggsregler öppna mot 0.0.0.0/0`

Värdet var 3 den 7 september, 2 den 16 september och 0 den 5 oktober. Listan med typer kan byggas ut.

### Datakälla och datakvalitet

Git-historiken i `team1-infra`. Den mäter koden och inte det som faktiskt körs i molnet. Ett nollvärde betyder dessutom inte minsta behörighet fullt ut, eftersom de ersättande rollerna fortfarande är administratörsroller.

### Målvärde eller önskad riktning

0, och värdet får aldrig gå upp igen.

### Mätfrekvens

Vid varje pull request och som en månadssiffra till ledningen.

### Tolkning och åtgärd vid avvikelse

0 är bra. Går värdet upp ska ändringen stoppas innan merge och orsaken förklaras för CISO.

---

## KPI 2

### Namn

Tid från dokumenterat fynd till åtgärd

### Syfte och mottagare

Visar om vi hinner stänga hål innan någon utnyttjar dem. Mottagare är IT-chef och systemägare, som äger frister och resurser.

### Definition och beräkning

Antal dagar från att en svaghet dokumenterats till commit som tar bort den ur koden, följt som median och längsta tid.

`Dagar till åtgärd = datum för åtgärds-commit - datum då svagheten dokumenterades`

Gamla CI/CD-nyckeln: 6 dagar (10/9 till 16/9). Öppna brandväggen: 19 dagar (16/9 till 5/10). Rollen editor: 25 dagar (10/9 till 5/10). Median 19 dagar, längsta 25.

### Datakälla och datakvalitet

Git-historiken och datumen då fynden skrevs ned i `SECURITY-ISSUES.md` och infraloggen. Det är datumet de dokumenterades och inte när de upptäcktes, så siffran är ett försiktigt värde. Det är bara tre mätpunkter, och "åtgärd" betyder att koden ändrats. Omtest ingår inte, och där är teamets utgångsläge 0 av 7 brister åtgärdade och omtestade, i en målmiljö vi inte äger.

### Målvärde eller önskad riktning

Kritiska och höga fynd inom 14 dagar. Det är mitt förslag och ska fastställas av systemägaren.

### Mätfrekvens

En gång i månaden.

### Tolkning och åtgärd vid avvikelse

Medianen 19 dagar ligger över målet. Om den inte kommer under 14 ska varje fynd få en namngiven ägare och ett slutdatum, och de som passerat datumet tas upp i ledningsgruppen.

---

## KPI 3

### Namn

Tid till upptäckt när en kontroll slutar fungera

### Syfte och mottagare

Visar hur länge vi kan sakna ett skydd utan att veta om det. Mottagare är CISO och IT-chef, som behöver avgöra om övervakning ska prioriteras.

### Definition och beräkning

Antal dygn från att en kontroll slutar rapportera tills någon upptäcker det, följt som längsta tid och median.

`Dygn till upptäckt = datum då felet upptäcktes - datum då kontrollen slutade rapportera`

Teamets mätning visar att signaturkontrollen låg nere i upp till 10 dygn.

### Datakälla och datakvalitet

Systemens statusloggar, som visar när en kontroll senast lyckades, och tidpunkten då felet upptäcktes. Tio dygn är värsta fallet och en enda mätning, inte ett genomsnitt. Att larm saknas i koden har jag kontrollerat själv i repot.

### Målvärde eller önskad riktning

Aldrig mer än ett dygn på kort sikt, och minuter till timmar när larm finns.

### Mätfrekvens

Varje vecka tills larm är på plats, därefter som månadssammanställning av larmen.

### Tolkning och åtgärd vid avvikelse

Över ett dygn betyder att vi litar på ett skydd som kanske inte fungerar. Då ska kontrollen få ett livstecken och CISO ska få veta vilka kontroller som saknar det.

---

## Samlad ledningsrapportering

Jag valde de här tre för att de täcker förebygga, åtgärda och upptäcka och för att alla går att kontrollera mot repot eller loggarna. Tillsammans säger de att vi har blivit bra på att minska exponeringen (3 till 0 breda regler, och två av tre driftsättningsflöden körs utan sparade nycklar) men att vi är långsamma på att stänga fynd (19 dagar) och på att upptäcka (10 dygn). Det är den skillnaden ledningen bör uppmärksamma.

KPI:erna stödjer beslutet att lägga resurser på larm och på en frist för åtgärder före fler förebyggande skydd. Ledningen kan använda dem för att besluta om frister, om vem som äger larmen och om hur ofta läget ska rapporteras. De säger inget om hur allvarliga fynden är, vad ett intrång skulle kosta eller hur ofta vi blir angripna. Underlaget är litet, det mäter kod och inte allt som körs i molnet, och 0 av 7 omtestade brister är ett utgångsläge i en miljö vi inte äger. Som komplement behövs en riskbedömning per fynd och uppgifter om incidenter.
