describe "AssociationQuestion", ->

  beforeEach ->
    loadFixtures("questions/association")
    @it = new App.AssociationQuestion("table")

  describe "#enhance", ->

    beforeEach ->
      @it.enhance()

    it "replaces input fields with spans", ->
      expect($("table span")).toBeVisible()
      expect($("table input")).toBeHidden()

  describe "#swap", ->

    it "swaps to elements", ->
      $one = $("table span").slice(0, 1)
      $oneText = $one.text()
      $two = $("table span").slice(1, 2)
      $twoText = $two.text()

      @it.swap($one, $two)

      $newOne = $("table span").slice(0, 1)
      $newTwo = $("table span").slice(1, 2)

      expect($newOne.siblings("input")).toHaveValue($twoText)
      expect($newTwo.siblings("input")).toHaveValue($oneText)
