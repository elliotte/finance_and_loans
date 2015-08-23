describe("LedgerShow", function() {
  var ledger;

  beforeEach(function() {
    ledger = new LedgerShow();
  });

  it("should have a data instance", function() {
    ledger.data();
    expect(ledger.data).toBeDefined();
  });

});
