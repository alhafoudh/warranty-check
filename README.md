# warranty-check

## HP notebooks

    hp = WarrantyCheck::HP.new("serial number")
    hp.check
    puts hp.warranties.inspect