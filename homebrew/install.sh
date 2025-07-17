#!/bin/sh -x
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "Didn't find it! Installing Homebrew for you."
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/refs/heads/main/install.sh)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/HEAD/install/master/install)"
  fi
fi

echo "Now add brew to PATH!"
echo "# add brew to path" >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
echo "# end brew path" >. ~/.zprofile

# also add for our session!
eval "$(/opt/homebrew/bin/brew shellenv)"

exit 0
