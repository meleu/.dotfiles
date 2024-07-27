#####################################
# Using nix as a Homebrew replacement
#####################################

# list installed packages
nix-env --query --installed

# install something
nix-env -iA nixpkgs.ripgrep

# search for a package to be installed:
# here: https://search.nixos.org
# or
nix-env -qaP $pkgName

# delete a pkg
nix-env -e ripgrep

# see all versions of nix "generations" that ever existed
nix-env --list-generations

# go to the previous generation
nix-env --rollback

# go to a specific generation
nix-env --switch-generation 2
