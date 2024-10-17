# install xcode manually
# xip -x ~/Desktop/Xcode_14.3.1.xip

# Install Xcode command line tools
# sudo /usr/sbin/softwareupdate -i "Command Line Tools for Xcode-14.3.1"


# Install brew manually
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# use homebrew to install gpg
brew install gnupg

# install cocoapods with brew version of ruby and gem
# MacOS installs a bugged version of Ruby.  Use brew to install a proper one instead
brew install ruby@3.0

echo 'export PATH="$HOME/.gem/ruby/3.0.0/bin:$PATH"' >> .zshrc
echo 'export PATH="/usr/local/opt/ruby@3.0/bin:$PATH"' >> .zshrc

# ADD THESE TWO LINES in your shell profile file like .zshrc to use this version of ruby first
echo 'export PATH="$HOME/.gem/ruby/3.0.0/bin:$PATH"' >> .zshrc
echo 'export PATH="/usr/local/opt/ruby@3.0/bin:$PATH"' >> .zshrc

gem install cocoapods -v 1.15.2 --user-install

# install java for utility tools
brew install openjdk@11
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
# ADD THIS LINE in your shell profile file like .zshrc to use java
echo 'export PATH="/usr/local/opt/openjdk@11/bin:$PATH"' >> .zshrc

# Apple certificates might not be trusted even for a brand new install.
# Get certificate from here and install in 'System' keychain:
curl -o ~/Desktop/AppleWWDRCAG3.cer https://www.apple.com/certificateauthority/AppleWWDRCAG3.cer

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# script would have already added NVM variables to shell profile, but we need to add for this script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# install latest version of node 18 and this becomes the default
nvm install 18

# Install GitHub self host runner agent
mkdir ~/actions-runner && cd ~/actions-runner
curl -o actions-runner-osx-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-osx-x64-2.311.0.tar.gz
tar xzf ./actions-runner-osx-x64-2.311.0.tar.gz
