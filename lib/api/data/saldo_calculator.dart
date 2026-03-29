import '../models/models.dart';

class SaldoResult {
  final String name;
  final double netBalance;
  final String detailText;

  SaldoResult({
    required this.name,
    required this.netBalance,
    required this.detailText,
  });
}

class SaldoCalculator {
  static List<SaldoResult> calculateBalances(
      List<Transaktion> transaktionen, List<String> alleBenutzerNamen) {
    Map<String, double> balances = {
      for (var name in alleBenutzerNamen) name: 0.0
    };

    // 1. Netto-Bilanzen berechnen
    for (var t in transaktionen) {
      // Bezahler bekommt den Gesamtwert gutgeschrieben
      balances[t.bezahlername] = (balances[t.bezahlername] ?? 0) + t.gesamtwert;

      // Schuldner wird ihr Anteil abgezogen
      for (var tp in t.transaktionspersonen) {
        balances[tp.schuldner] = (balances[tp.schuldner] ?? 0) - tp.anteil;
      }
    }

    // 2. Settlement berechnen für detailText
    // Wir trennen Schuldner und Gläubiger
    List<_PersonBalance> debtors = [];
    List<_PersonBalance> creditors = [];

    balances.forEach((name, balance) {
      if (balance < -0.01) {
        debtors.add(_PersonBalance(name, balance.abs()));
      } else if (balance > 0.01) {
        creditors.add(_PersonBalance(name, balance));
      }
    });

    Map<String, List<String>> bekommtVon = {};
    Map<String, List<String>> schuldetAn = {};

    // Kopien für den Settlement-Algorithmus
    List<_PersonBalance> dTemp = debtors.map((e) => _PersonBalance(e.name, e.amount)).toList();
    List<_PersonBalance> cTemp = creditors.map((e) => _PersonBalance(e.name, e.amount)).toList();

    int dIdx = 0;
    int cIdx = 0;

    while (dIdx < dTemp.length && cIdx < cTemp.length) {
      double settleAmount = dTemp[dIdx].amount < cTemp[cIdx].amount 
          ? dTemp[dIdx].amount 
          : cTemp[cIdx].amount;
      
      String dName = dTemp[dIdx].name;
      String cName = cTemp[cIdx].name;

      if (settleAmount > 0.01) {
        bekommtVon.putIfAbsent(cName, () => []).add(dName);
        schuldetAn.putIfAbsent(dName, () => []).add(cName);
      }

      dTemp[dIdx].amount -= settleAmount;
      cTemp[cIdx].amount -= settleAmount;

      if (dTemp[dIdx].amount < 0.01) dIdx++;
      if (cTemp[cIdx].amount < 0.01) cIdx++;
    }

    // 3. Ergebnisse zusammenbauen
    return alleBenutzerNamen.map((name) {
      double balance = balances[name] ?? 0.0;
      String detailText = '';

      if (balance > 0.01) {
        List<String> von = bekommtVon[name] ?? [];
        detailText = von.isEmpty 
            ? 'Bekommt Geld zurück' 
            : 'bekommt Geld von ${von.join(', ')}';
      } else if (balance < -0.01) {
        List<String> an = schuldetAn[name] ?? [];
        detailText = an.isEmpty 
            ? 'Schuldet Geld' 
            : 'schuldet Geld an ${an.join(', ')}';
      } else {
        detailText = 'Ausgeglichen';
      }

      return SaldoResult(
        name: name,
        netBalance: balance,
        detailText: detailText,
      );
    }).toList();
  }
}

class _PersonBalance {
  final String name;
  double amount;
  _PersonBalance(this.name, this.amount);
}
