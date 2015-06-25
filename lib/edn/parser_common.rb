module EDN

  # Object returned when there is nothing to return

  NOTHING = Object.new

  # Object to return when we hit end of file. Cant be nil or :eof
  # because either of those could be something in the EDN data.

  EOF = Object.new

end
