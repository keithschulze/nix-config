{
  nix = {
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 0; Minute = 0; };
      # Delete older generations too
      options = "--delete-older-than 7d";
    };
  };
}
